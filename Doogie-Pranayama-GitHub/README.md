# Doogie – Pranayama

Bestehende GitHub-Web-App plus kleine native iOS-Hülle.

## Was damit umgesetzt wird

- Die bestehende `www/index.html` bleibt die UI und kommt aus deinem GitHub-Projekt.
- Während einer Atemsession wird der iPhone-Bildschirm automatisch aktiv gehalten.
- Beim Pausieren, Beenden oder Verlassen der Session wird die normale iOS-Bildschirmsperre wieder aktiviert.
- Die Atemansagen werden an die native iOS-Sprachwiedergabe übergeben.
- iOS verwendet `AVAudioSession` mit `mixWithOthers`: Spotify kann parallel weiterlaufen.
- `duckOthers` wird nicht verwendet: Spotify wird nicht automatisch leiser geregelt.

## Einmalig anpassen

Die GitHub-Pages-Adresse ist bereits eingetragen:

```swift
private let githubURL = URL(string: "https://doogie187.github.io/doogie-pranayama/")!
```

## Xcode

1. Auf dem Mac Xcode öffnen.
2. Ein neues iOS-App-Projekt `Doogie` mit SwiftUI anlegen.
3. Die beiden Swift-Dateien aus `ios/Doogie/` in das Projekt übernehmen.
4. `Info.plist`-Einträge aus `ios/Doogie/Info.plist` übernehmen.
5. Eigenes iPhone als Run Destination auswählen.
6. Signing Team auswählen und App auf dem iPhone starten.

Die Web-App bleibt in GitHub. Änderungen an HTML/CSS/JS werden nach dem nächsten GitHub-Pages-Deployment von der iOS-Hülle geladen.

## Wichtiger Punkt

Die native Hülle ist nur für iOS-Verhalten zuständig. Das Layout der Atem-App wird nicht neu gebaut.
