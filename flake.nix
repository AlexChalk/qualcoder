{
  description = "Application packaged using poetry2nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, poetry2nix, flake-utils }:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        qualcoder_module = pkgs.stdenv.mkDerivation {
          pname = "QualCoder";
          version = "3.4";

          src = pkgs.fetchzip {
            url = "https://github.com/ccbogel/QualCoder/archive/refs/tags/3.4.zip";
            sha256 = "sha256-xvwQMaTF829oWLBRvgRChiJ0DMuROKetoiv8A7ykCnk=";
          };

          installPhase = ''
            mkdir -p $out
            cp -r . $out
          '';
        };
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv overrides;

        python = mkPoetryEnv {
          projectDir = self;
          preferWheels = true;
          extraPackages = ps: [ ];
          overrides = overrides.withDefaults (final: prev: {
            ebooklib = prev.ebooklib.overridePythonAttrs (old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
                prev.setuptools
              ];
            });
            numpy = prev.numpy.overridePythonAttrs (old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
                prev.setuptools
              ];
            });
            qualcoder = prev.qualcoder.overridePythonAttrs (old: {
              src = qualcoder_module;
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
                prev.setuptools
              ];
            });
          });
        };
        qualcoder = {
          type = "app";
          program = "${python}/bin/qualcoder";
        };
      in
      {
        packages = { inherit python; };
        packages.default = python;
        apps = { inherit qualcoder; };
        apps.default = qualcoder;
      }
    );
}
