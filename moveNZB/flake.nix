# /flake.nix im 'LanceHardwoodXXX/mynixpackages' Repository
{
  description = "Ein Flake für diverse Skripte";

  inputs = {
    # Wir brauchen nixpkgs, um Zugriff auf Bau-Werkzeuge wie stdenv zu haben
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  # Der 'outputs'-Teil beschreibt, was dieses Flake "produziert"
  outputs = { self, nixpkgs }:
    let
      # Unterstützte Systeme definieren
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Eine Funktion, um für jedes System unsere Pakete zu generieren
      forAllSystems = function: nixpkgs.lib.genAttrs supportedSystems (system: function {
        pkgs = import nixpkgs { inherit system; };
      });

    in
    {
      # Wir "exportieren" hier unsere Pakete
      packages = forAllSystems ({ pkgs }: {
        # Das ist das Paket für dein Skript. Wir nennen es 'moveNZB'
        moveNZB = pkgs.stdenv.mkDerivation {
          pname = "moveNZB";
          version = "0.1.0";

          # Die Quelle ist das aktuelle Verzeichnis, also das gesamte Git-Repo
          src = self;

          # Die Installationslogik bleibt fast gleich
          installPhase = ''
            runHook preInstall
            install -d $out/bin

            # ERSETZE 'DEIN_SKRIPT_NAME.sh' mit dem echten Namen
            install -m 755 ./moveNZB/moveNZB.sh $out/bin/verschiebe-nzb
            
            # WICHTIG: Die Platzhalter werden jetzt nicht mehr ersetzt!
            # Das Skript bleibt generisch. Die Konfiguration erfolgt im System.
            runHook postInstall
          '';
        };
        
        # Das 'default' Paket ist ein Alias für moveNZB
        default = self.packages.${pkgs.system}.moveNZB;
      });
    };
}
