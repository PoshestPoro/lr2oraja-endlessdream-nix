{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, gtk3
, jdk
, libjportaudio
, makeWrapper
, writeShellScript
, libGL
, xrandr
, makeDesktopItem
, copyDesktopItems
, addDriverRunpath
}:
stdenv.mkDerivation
  (finalAttrs: {
    pname = "lr2oraja-endlessdream";
    beatoraja-version = "0.8.8";
    lr2oraja-endlessdream-version = "0.4.0";


    version = finalAttrs.lr2oraja-endlessdream-version;

    jdkFx = jdk.override {
      enableJavaFX = true;
    };
    binPath = lib.makeBinPath [ xrandr ];
    libPath = lib.makeLibraryPath [
      libjportaudio
      libGL
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "lr2oraja-endlessdream";
        desktopName = "lr2oraja-endlessdream";
        genericName = "beatoraja fork with lr2 elements";
        icon = "lr2oraja-endlessdream-icon";
        tryExec = "lr2oraja-endlessdream";
        exec = "lr2oraja-endlessdream";
        categories = [
          "Application"
          "Game"
          "ArcadeGame"
        ];
        comment = "lr2oraja-endlessdream v${finalAttrs.lr2oraja-endlessdream-version}";
        terminal = false;
      })
    ];



    startupScript = writeShellScript
      "lr2oraja-endlessdream.sh"
      ''
        	build_java_options() {
        	  local options=(
        	    -Dsun.java2d.opengl=true
        	    -Dawt.useSystemAAFontSettings=on
        	    -Dswing.aatext=true
        	    -Dfile.encoding="UTF-8"
        	    -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
        	  )

        	  if [[ -n "''${JDK_JAVA_OPTIONS}" ]]; then
        	    while IFS= read -r opt; do
        	      [[ -n "$opt" ]] && options+=("$opt")
        	    done < <(echo "''${JDK_JAVA_OPTIONS}" | tr ' ' '\n')
        	  fi
        	}
        	dataDir="''${XDG_DATA_HOME:-$HOME/.local/share}/lr2oraja-endlessdream"
        	if [ ! -d "$dataDir" ]; then
        	  mkdir -p "$dataDir"
        	  cp -r $out/opt/lr2oraja-endlessdream/* "$dataDir"
        	  find "$dataDir" -type f -exec chmod 644 {} \;
        	  find "$dataDir" -type d -exec chmod 755 {} \;
        	fi
        	cd "''${XDG_DATA_HOME:-$HOME/.local/share}/lr2oraja-endlessdream"

        	JDK_JAVA_OPTIONS=$(build_java_options) \
        	SHUT_UP_TACHI=yes \
        	  ${finalAttrs.jdkFx}/bin/java \
        	    -Xms1g -Xmx4g \
        	    -cp lr2oraja-endlessdream.jar:ir/* bms.player.beatoraja.MainLoader \
        	    "$@"

      '';

    src = fetchurl
      {
        url = "https://github.com/seraxis/lr2oraja-endlessdream/releases/download/v0.4.0/lr2oraja-0.8.8-endlessdream-linux-0.4.0.jar";
        hash = "sha256-ViPMo1Xhw1DF57701RK4ddP7cAxz5g4iicmgrV730o4=";
      };

    icon = fetchurl
      {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/lr2oraja-endlessdream-icon.png?h=lr2oraja-endlessdream";
        hash = "sha256-/b03/0OqavIPnrZDvycad+9XkBSXCno9zs945lEj2D0=";
      };
    gitsrc = fetchFromGitHub {
      owner = "seraxis";
      repo = "lr2oraja-endlessdream";
      rev = "${finalAttrs.lr2oraja-endlessdream-version}";
      hash = "sha256-e9yjO1jbfPKPgozlURP7Sv3ci14T/1sj+1Cl1IYQgsY=";
    };

    nativeBuildInputs = [ makeWrapper copyDesktopItems ];
    unpackPhase = ":";

    installPhase = ''
      		runHook preInstall
                              mkdir -p $out/opt/lr2oraja-endlessdream
                              mkdir -p $out/bin
                              ln -s ${finalAttrs.startupScript} $out/bin/lr2oraja-endlessdream
                              mv * $out/opt/lr2oraja-endlessdream/

                              cp ${finalAttrs.src} $out/opt/lr2oraja-endlessdream/lr2oraja-endlessdream.jar
            		cp -r ${finalAttrs.gitsrc}/assets/* "$out/opt/lr2oraja-endlessdream/"
                              install -Dm644 ${finalAttrs.icon} $out/share/icons/lr2oraja-endlessdream-icon.png

                              wrapProgram $out/bin/lr2oraja-endlessdream \
                                --set out $out \
                                --suffix PATH : "${finalAttrs.binPath}" \
                                --prefix LD_LIBRARY_PATH : "${addDriverRunpath.driverLink}/lib:${finalAttrs.libPath}" \
                  	      --prefix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/* \

                              runHook postInstall
    '';
    meta = with lib; {
      description = "Cross-platform rhythm game based on Java and libGDX.";
      homepage = "https://github.com/seraxis/lr2oraja-endlessdream";
      license = [ licenses.gpl3Only "unknown" ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "lr2oraja-endlessdream";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
    };
  })
