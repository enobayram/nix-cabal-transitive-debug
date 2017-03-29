{ pkgs, profiling ? false }:
let
  shared = "shared";
  overrideCabal = pkgs.haskell.lib.overrideCabal;
  generateHsNix = name: folder:
    pkgs.runCommand name {buildInputs = [pkgs.cabal2nix];} "${pkgs.cabal2nix}/bin/cabal2nix ${folder} >$out";
  myHaskellPackages = pkgs.haskellPackages.override {
      overrides = self: super: with pkgs.haskell.lib; {
        mkDerivation = args: super.mkDerivation (args // {
          enableLibraryProfiling = profiling;
        });
        foo = fooHs;
        bar = self.callPackage (generateHsNix "bar" ./bar) {};
      };
    };
  fooHs' = myHaskellPackages.callPackage (generateHsNix "foo" ./.) {};
  fooHs = overrideCabal fooHs' (drv: {
    preCheck = ''
      export SHAREDDIR=${shared}
    '';
    configureFlags = [ "--ghc-option=-with-rtsopts=-T" "--ghc-option=-j12" ]
                    ++ (if profiling then [ "--ghc-option=-rtsopts"
                                            "--ghc-option=-auto-all"
                                            "--ghc-option=-caf-all" ]
                                     else []);
    src = builtins.filterSource (path: type:
       ( ( type == "directory"
        && baseNameOf path != "doc"
        && baseNameOf path != "dist"
        && baseNameOf path != "scripts"
        && baseNameOf path != "shared"
         )
      || ( type == "regular"
        && !pkgs.lib.hasSuffix ".nix" path
        && !pkgs.lib.hasSuffix ".md"  path
        && !pkgs.lib.hasSuffix ".o"   path
        && !pkgs.lib.hasSuffix ".hi"  path
        && !pkgs.lib.hasSuffix ".swp" path
        && !pkgs.lib.hasSuffix ".swp" path
        && !pkgs.lib.hasSuffix ".swo" path
         )
       )
     ) ./.;
    enableSharedExecutables = profiling;
    enableExecutableProfiling = profiling;
    doHaddock = false;
  });
  bar = myHaskellPackages.bar;
in {
  inherit bar;
  haskellPackages = myHaskellPackages;
}
