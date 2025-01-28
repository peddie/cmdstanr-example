{
  description = "Example environment for cmdstanr.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils/main";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        rPackages = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [
            pkgs.cmdstan
            reprex
            (buildRPackage {
              name = "cmdstanr";
              src = pkgs.fetchurl {
                url = "https://stan-dev.r-universe.dev/src/contrib/cmdstanr_0.8.1.tar.gz";
                sha256 = "sha256-IrjzaqcP9+5U6y35CoSGmkjGUc96/2pYGAteSXXMnH4=";
              };
              propagatedBuildInputs = [ checkmate data_table jsonlite posterior processx R6 withr ];
            })
          ];
        };
        packageName = "cmdstanr-example";
      in {
        packages.default = pkgs.R;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            rPackages
          ];
          shellHook = ''
    mkdir -p "$(pwd)/_libs"
    export R_LIBS_USER="$(pwd)/_libs"
    echo ${rPackages}/bin/R
    export CMDSTAN=${pkgs.cmdstan}/opt/cmdstan
    R --quiet -e "cmdstanr::set_cmdstan_path('$CMDSTAN')"
  '';
        };
      });

}
