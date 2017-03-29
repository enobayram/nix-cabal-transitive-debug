{ pkgs, profiling ? false }:
let
  myHaskellPackages = pkgs.haskellPackages.override {
      overrides = self: super: with pkgs.haskell.lib; {
        mkDerivation = args: super.mkDerivation (args // {
          enableLibraryProfiling = profiling;
        });
        foo = self.callPackage ./hs.nix {};
        bar = self.callPackage bar/hs.nix {};
      };
    };
  foo = myHaskellPackages.foo;
  bar = myHaskellPackages.bar;
in {
  inherit foo bar;
  haskellPackages = myHaskellPackages;
}
