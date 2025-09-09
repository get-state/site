{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
  outputs = { nixpkgs, ... }: {
    devShells.x86_64-linux.default = 
      let pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in pkgs.mkShell {
        buildInputs = [ 
          (pkgs.buildFHSEnv {
            name = "fhs";
            targetPkgs = pkgs: [ pkgs.deno pkgs.gcc pkgs.stdenv.cc.cc.lib ];
          })
          pkgs.deno
        ];
        shellHook = "exec fhs";
      };
  };
}
