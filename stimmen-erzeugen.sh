#!/bin/bash
# Erzeugt die Ansagen für Doogie mit einer deutschen Mac-Stimme (macOS).
# Aufruf:  bash stimmen-erzeugen.sh            (Standardstimme "Anna")
#          bash stimmen-erzeugen.sh "Markus"   (andere Stimme)
# Verfügbare deutsche Stimmen anzeigen:  say -v '?' | grep de_DE
VOICE="${1:-Anna}"
OUT="$HOME/Desktop/Doogie-Stimme"
mkdir -p "$OUT"

make() {  # Dateiname, Text
  say -v "$VOICE" -r 120 -o "$OUT/$1.aiff" "$2" \
  && afconvert -f m4af -d aac "$OUT/$1.aiff" "$OUT/$1.m4a" \
  && rm "$OUT/$1.aiff" \
  && echo "OK  $1.m4a"
}

make einatmen   "Einatmen"
make halten     "Halten"
make ausatmen   "Ausatmen"
make begruessung "Guten Tag, Doogie."
make abschluss  "Ich wünsche dir einen entspannten Tag."

echo
echo "Fertig. Dateien liegen in: $OUT"
echo "Per AirDrop ans iPhone schicken (landen in der Dateien-App)."
