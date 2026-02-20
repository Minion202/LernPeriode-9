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

## 24.10.

- [x] Skizzen zum Backend und zur Datenbank machen. Ich zeige, wann Godot Daten an das Python Backend schickt und was lokal im Client passiert, zum Beispiel Sortieren oder Suchen der Scores.sondern sich im *client* bearbeiten lassen (sortieren, suchen etc.)
- [x] PostgreSQL mit Docker einrichten und eine einfache Tabelle für Highscores erstellen. Verbindung testen.
- [x] Kleines FastAPI Backend bauen mit einem Hello World Endpoint, der gleichzeitig die Datenbankverbindung prüft.

Heute habe ich PostgreSQL mit Docker gestartet und ein erstes Python Backend mit FastAPI erstellt. Danach habe ich einen Endpoint programmiert, der Hello World zurückgibt und überprüft, ob die Verbindung zur Datenbank funktioniert. So weiss ich, dass mein Spiel später korrekt mit dem Backend kommunizieren kann. Ich habe PostgreSQL gewählt, weil es in vielen echten Projekten genutzt wird, stabil ist und sich sehr gut für strukturierte Daten wie Highscores eignet. Den Code und meine Skizzen habe ich auf GitHub hochgeladen.

## 31.10.

- [ ] API Endpoints für Highscores erstellen (Score speichern und Top Scores abrufen).
- [ ] Verbindung von Godot zum Backend testen und erste Scores in die Datenbank schreiben.
- [ ] Highscores im Client anzeigen und lokal sortieren oder filtern.
- [ ] Code dokumentieren und auf GitHub aktualisieren.

✍️ Heute habe ich... (50-100 Wörter)

