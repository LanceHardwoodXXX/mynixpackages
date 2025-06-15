#! /usr/bin/env bash

# Pfade anpassen!

# Platzhalter, die von Nix ersetzt werden
#DOWNLOAD_ORDNER="@downloadDir@"
#ZIEL_ORDNER="@targetDir@"
#LOG_FILE="@logFile@"


DOWNLOAD_ORDNER="/home/florian/Downloads" # Passe diesen Pfad an deinen tatsächlichen Download-Ordner an
ZIEL_ORDNER="/home/florian/mnt/Media/Download/watch/"
LOG_FILE="home/florian/.local/share/moveNZB/moveNZB.log" # Pfad für die Log-Datei # Pfad für die Log-Datei

# Funktion zur Protokollierung
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Überprüfen, ob die Ordner existieren
if [ ! -d "$DOWNLOAD_ORDNER" ]; then
    log_message "Fehler: Download-Ordner '$DOWNLOAD_ORDNER' existiert nicht."
    exit 1
fi

if [ ! -d "$ZIEL_ORDNER" ]; then
    log_message "Fehler: Ziel-Ordner '$ZIEL_ORDNER' existiert nicht. Versuche ihn zu erstellen..."
    mkdir -p "$ZIEL_ORDNER"
    if [ $? -ne 0 ]; then
        log_message "Fehler: Konnte Ziel-Ordner '$ZIEL_ORDNER' nicht erstellen."
        exit 1
    else
        log_message "Ziel-Ordner '$ZIEL_ORDNER' erfolgreich erstellt."
    fi
fi

# NZB-Dateien verschieben
# Mit 'find' suchen wir nach NZB-Dateien im Download-Ordner und seinen Unterordnern
# Mit '-exec mv {} ...' verschieben wir die gefundenen Dateien
# '-print' gibt den Namen der verschobenen Datei aus
find "$DOWNLOAD_ORDNER" -maxdepth 1 -type f -name "*.nzb" -print | while read -r nzb_file; do
    if [ -f "$nzb_file" ]; then # Überprüfen, ob die Datei noch existiert (könnte in der Zwischenzeit verschoben/gelöscht worden sein)
        mv "$nzb_file" "$ZIEL_ORDNER"
        if [ $? -eq 0 ]; then
            log_message "Verschoben: '$nzb_file' nach '$ZIEL_ORDNER'"
        else
            log_message "Fehler beim Verschieben von '$nzb_file'."
        fi
    fi
done

log_message "Skript-Durchlauf beendet."

exit 0
