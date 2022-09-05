{ stdenv, lib, fetchurl, libX11, libXft, harfbuzzFull, pkgconfig, ncurses }:
with lib;

stdenv.mkDerivation {
  name = "st-head";

  src = builtins.filterSource
    (path: type: (toString path) != (toString ./.git)) ./.;

  nativeBuildInputs = [ pkgconfig ncurses ];
  buildInputs = [ libX11 libXft harfbuzzFull ];

  prePatch = ''
    substituteInPlace config.mk --replace '/usr/local' $out
  '';

  installPhase = ''
    sed -i '/man/d' Makefile
    sed -i '/tic/d' Makefile
    TERMINFO=$out/share/terminfo make PREFIX=$out install
  '';

  meta = {
    description = "Dynamic window manager that suck less";
    homepage = https://dwm.suckless.org/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
