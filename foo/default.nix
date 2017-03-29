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
    configureFlags = [ "--ghc-option=-with-rtsopts=-T" "--ghc-option=-j12" ]
                    ++ (if profiling then [ "--ghc-option=-rtsopts"
                                            "--ghc-option=-auto-all"
                                            "--ghc-option=-caf-all" ]
                                     else []);
  });
  bar = myHaskellPackages.bar;
in {
  inherit bar;
  haskellPackages = myHaskellPackages;
}
