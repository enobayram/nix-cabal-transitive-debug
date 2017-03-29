{ mkDerivation, acid-state, base, stdenv }:
mkDerivation {
  pname = "foo";
  version = "4.3.0.0";
  src = ./.;
  libraryHaskellDepends = [ acid-state base ];
  description = "Foo";
  license = stdenv.lib.licenses.bsd3;
}
