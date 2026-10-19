# CLAUDE.md

## Before pushing

Never `git push` unless every check from `.github/workflows/` passes locally on the commit being pushed. Run them from the repo root:

```sh
# nix-check.yml: flake check
nix flake check --no-build --accept-flake-config

# nix-check.yml: dry-build every entry in ciMatrix
for attr in $(nix eval --json .#ciMatrix --accept-flake-config | jq -r '.include[].attr'); do
  nix build ".#$attr" --dry-run --accept-flake-config || echo "FAILED: $attr"
done

# deadnix.yml: no dead code
nix run nixpkgs#deadnix -- --fail .
```

- Flakes only see files tracked by git, so stage or commit new files before checking.
- If any check fails, fix it (or report the failure to the user) instead of pushing.
- If workflows in `.github/workflows/` change, update this list to match.
