let
  _pkgs = import <nixpkgs> {};
  nixpkgs = _pkgs.fetchFromGitHub (_pkgs.lib.importJSON ./nixpkgs-git.json );
  pkgs = import nixpkgs {
                         config = {
                           allowUnfree = true;
                           packageOverrides = oldPkgs: {
                             libvirt = oldPkgs.libvirt.override { xen = null; };
                           };
                         };
                       };
  in
    (import ./foo) {inherit pkgs;}
