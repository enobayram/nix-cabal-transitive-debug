{ mkDerivation, base, foo, stdenv }:
mkDerivation {
  pname = "bar";
  version = "4.3.0.0";
  src = ./.;
  libraryHaskellDepends = [ base foo ];
  description = "Bar";
  license = stdenv.lib.licenses.bsd3;
}
