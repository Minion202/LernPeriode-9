# Lern-Periode 9

## Grob-Planung

Grundlagen
Zuerst richte ich die Datenbank PostgreSQL mit Docker ein und teste die Verbindung. Danach baue ich ein einfaches Python Backend mit FastAPI, das mit der Datenbank kommuniziert. Ziel ist eine stabile Verbindung zwischen Backend und Datenbank.

API und Logik
Ich erstelle Endpoints zum Speichern von Scores und zum Abrufen der Top Highscores. Dabei definiere ich ein klares JSON Format. Anschliessend teste ich alles mit curl und prüfe direkt in der Datenbank, ob die Daten korrekt gespeichert werden.

Verbindung mit Godot
Ich verbinde Godot über HTTPRequest mit meinem Backend. Beim Spielende soll ein Score an das Backend gesendet werden. Danach lade ich die Highscores und zeige sie im Spiel an.

Erweiterung und Optimierung
Ich baue zusätzliche Funktionen wie Sortieren oder Filtern im Client ein, ohne jedes Mal die API aufzurufen. Danach dokumentiere ich das Projekt sauber und lade alles auf GitHub hoch.

Ziel des Projekts
Am Ende soll mein Spiel ein funktionierendes Highscore System haben, das über ein Python Backend mit PostgreSQL läuft und sauber dokumentiert ist.

## 20.10.

- [x] Skizzen zum Backend und zur Datenbank machen. Ich zeige, wann Godot Daten an das Python Backend schickt und was lokal im Client passiert, zum Beispiel Sortieren oder Suchen der Scores.sondern sich im *client* bearbeiten lassen (sortieren, suchen etc.)
- [x] PostgreSQL mit Docker einrichten und eine einfache Tabelle für Highscores erstellen. Verbindung testen.
- [x] Kleines FastAPI Backend bauen mit einem Hello World Endpoint, der gleichzeitig die Datenbankverbindung prüft.

Heute habe ich PostgreSQL mit Docker gestartet und ein erstes Python Backend mit FastAPI erstellt. Danach habe ich einen Endpoint programmiert, der Hello World zurückgibt und überprüft, ob die Verbindung zur Datenbank funktioniert. So weiss ich, dass mein Spiel später korrekt mit dem Backend kommunizieren kann. Ich habe PostgreSQL gewählt, weil es in vielen echten Projekten genutzt wird, stabil ist und sich sehr gut für strukturierte Daten wie Highscores eignet. Den Code und meine Skizzen habe ich auf GitHub hochgeladen.

## 27.02.

- [x] API Endpoints für Highscores erstellen (Score speichern und Top Scores abrufen).
- [x] Verbindung von Godot zum Backend testen und erste Scores in die Datenbank schreiben.
- [x] Highscores im Client anzeigen und lokal sortieren oder filtern.
- [x] Code dokumentieren und auf GitHub aktualisieren.

Heute habe ich begonnen, mein Highscore System im Spiel fertig umzusetzen. Ich habe das Game Over UI geplant und vorbereitet, damit der Spieler seinen Namen eingeben kann. Danach habe ich getestet, ob die Coins korrekt an mein Python Backend gesendet werden. Ziel ist, dass die Daten sauber in PostgreSQL gespeichert werden. Anschliessend möchte ich die Highscores im Spiel anzeigen lassen. Den aktuellen Stand habe ich auf GitHub hochgeladen.

## 04.03.

- [ ] UI für Game Over fertig bauen. Panel mit NameInput und SaveButton korrekt positionieren und sichtbar machen. Testen, ob der Name richtig ausgelesen wird.
- [ ] Coins korrekt an Backend senden. Beim Game Over soll der aktuelle Coin Stand zusammen mit dem eingegebenen Namen an die API geschickt werden.
- [ ] Leaderboard Scene erstellen. Highscores vom Backend abrufen und im Spiel als Liste anzeigen.
- [ ] Testen und Fehler beheben. Mehrere Scores speichern, prüfen ob Sortierung stimmt, Code auf GitHub aktualisiere

