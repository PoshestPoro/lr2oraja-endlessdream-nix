{ lib
, stdenv
, fetchzip
, fetchurl
, jdk
, libjportaudio
, makeWrapper
, wrapGAppsHook3
, openal
, gsettings-desktop-schemas
, writeShellScript
, egl-wayland
, libGL
, mesa
, xrandr
, makeDesktopItem
, copyDesktopItems

,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lr2oraja-endlessdream";
  version = "0.8.8";
  fullName = "beatoraja${finalAttrs.version}-modernchic";

  jdkFx = jdk.override { enableJavaFX = true; };
  binPath = lib.makeBinPath [ xrandr ];
  libPath = lib.makeLibraryPath [ openal libjportaudio libGL egl-wayland mesa ];

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
      comment = "Fork of beatoraja, BMS";
      terminal = false;
    })
  ];



  startupScript = writeShellScript "lr2oraja-endlessdream.sh" ''
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
    	dataDir="''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"
    	if [ ! -d "$dataDir" ]; then
    	  mkdir -p "$dataDir"
    	  cp -r $out/opt/beatoraja/* "$dataDir"
    	  find "$dataDir" -type f -exec chmod 644 {} \;
    	  find "$dataDir" -type d -exec chmod 755 {} \;
    	fi
    	cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"

    	JDK_JAVA_OPTIONS=$(build_java_options) \
    	SHUT_UP_TACHI=yes \
    	  ${finalAttrs.jdkFx}/bin/java \
    	    -Xms1g -Xmx4g \
    	    -cp $out/opt/lr2oraja-endlessdream/beatoraja.jar:ir/* bms.player.beatoraja.MainLoader \
    	    "$@"

  '';

  lr2oraja-jar = fetchurl {
    url = "https://github.com/seraxis/lr2oraja-endlessdream/releases/download/v0.4.0/lr2oraja-0.8.8-endlessdream-linux-0.4.0.jar";
    hash = "sha256:5623cca355e1c350c5e7bef4d512b875d3fb700c73e60e2289c9a0ad5ef7d28e";
  };

  src = fetchzip {
    url = "https://mocha-repository.info/download/${finalAttrs.fullName}.zip";
    hash = "sha256-TujfJ7hgjEKs5NbGvwo3/nkbJFvcZ4mefgkdp6oQHw4=";
  };
  icon = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/lr2oraja-endlessdream-icon.png?h=lr2oraja-endlessdream";
    hash = "sha256-/b03/0OqavIPnrZDvycad+9XkBSXCno9zs945lEj2D0=";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook3 copyDesktopItems ];

  preInstall = ''
    rm beatoraja-config.bat
    rm beatoraja-config.command
    rm jportaudio_x64.dll
    rm portaudio_x64.dll
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/lr2oraja-endlessdream
    mkdir -p $out/bin
    ln -s ${finalAttrs.startupScript} $out/bin/lr2oraja-endlessdream
    mv * $out/opt/lr2oraja-endlessdream/

    cp ${finalAttrs.lr2oraja-jar} $out/opt/lr2oraja-endlessdream/beatoraja.jar
    install -Dm644 ${finalAttrs.icon} $out/share/icons/lr2oraja-endlessdream-icon.png

    wrapProgram $out/bin/lr2oraja-endlessdream \
      --set out $out \
      --suffix PATH : "${finalAttrs.binPath}" \
      --prefix LD_LIBRARY_PATH : "${finalAttrs.libPath}" \

    runHook postInstall
  '';
  meta = with lib; {
    description = "Cross-platform rhythm game based on Java and libGDX.";
    homepage = "https://github.com/exch-bms2/beatoraja";
    license = [ licenses.gpl3Only "unknown" ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lr2oraja-endlessdream";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
})
