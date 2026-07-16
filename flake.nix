{
  description = "Custom clang with ClangIR and MLIR";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.llvmPackages.stdenv.mkDerivation {
          name = "custom-clang";
          src = self;

          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            python3
            clang-tools
          ];

          buildInputs = with pkgs; [
            libxml2
            zlib
            ncurses
          ];

          hardeningDisable = [ "all" ];

          configurePhase = ''
            cmake -S llvm -B build \
              -G Ninja \
              -DCMAKE_INSTALL_PREFIX=$out \
              -DLLVM_ENABLE_PROJECTS="mlir;clang" \
              -DLLVM_TARGETS_TO_BUILD=Native \
              -DCMAKE_BUILD_TYPE=Release \
              -DCLANG_ENABLE_CIR=ON \
              -DLLVM_ENABLE_ASSERTIONS=OFF \
              -DLLVM_INCLUDE_TESTS=OFF \
              -DLLVM_INCLUDE_EXAMPLES=OFF \
              -DLLVM_INCLUDE_BENCHMARKS=OFF \
              -DLLVM_ENABLE_ZLIB=ON \
              -DLLVM_ENABLE_LIBXML2=ON
          '';

          buildPhase = ''
            cmake --build build
          '';

          installPhase = ''
            cmake --install build
          '';
        };

        defaultPackage = self.packages.${system}.default;
      }
    );
}
