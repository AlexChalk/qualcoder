## To run:
```bash
./download-qualcoder-lib.sh
nix build
nix run .#qualcoder
```


## Notes:

Only added pdfminer.six (not pdfminer too, as per readme)

https://discourse.nixos.org/t/import-a-global-cfg-variable-file-error-access-to-the-absolute-path-nix-store-cfg-is-forbidden-in-pure-eval-mode/28061/2

git submodule add <repository-url> <path>

poetry add --lock
poetry update --lock / poetry lock (--no-update)
nix build
nix run
nix flake update
