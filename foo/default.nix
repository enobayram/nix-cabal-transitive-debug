{ pkgs, profiling ? false }:
let
  shared = "shared";
  overrideCabal = pkgs.haskell.lib.overrideCabal;
  myHaskellPackages = pkgs.haskellPackages.override {
      overrides = self: super: with pkgs.haskell.lib; {
        mkDerivation = args: super.mkDerivation (args // {
          enableLibraryProfiling = profiling;
        });
        foo = fooHs;
        bar = self.callPackage bar/hs.nix {};
      };
    };
  fooHs' = myHaskellPackages.callPackage ./hs.nix {};
  fooHs = overrideCabal fooHs' (drv: {
  });
  bar = myHaskellPackages.bar;
in {
  inherit bar;
  haskellPackages = myHaskellPackages;
}
