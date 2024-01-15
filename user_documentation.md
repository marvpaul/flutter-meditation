# Userdokumentation
<div style="display: flex; justify-content: space-between;">
    <img src="https://github.com/marvpaul/flutter-meditation/blob/master/screenshots/user_documentation/Homescreen.png?raw=true" width="200" alt="Meditation view">
    <img src="https://github.com/marvpaul/flutter-meditation/blob/master/screenshots/user_documentation/Session.png?raw=true" width="200" alt="Start screen">
    <img src="https://github.com/marvpaul/flutter-meditation/blob/master/screenshots/user_documentation/SessionSummarize.png?raw=true" width="200" alt="Settings">
    <img src="https://github.com/marvpaul/flutter-meditation/blob/master/screenshots/user_documentation/Settings.png?raw=true" width="200" alt="Settings">
</div>

1. Koppeln / Entkoppeln des Mi-Band: 
- beim starten der App bekommt der Nutzer die Möglichkeit, ein Mi-Band zu verbinden. Vor dem Nutzen innerhalb der App muss das Mi-Band mittels Zepp-App gekoppelt werden. Ist das Band einmal gekoppelt, kann der Nutzer es später innerhalb der Einstellungen wieder entkoppeln. 
2. Homescreen
- Ist die Uhr gekoppelt oder der Nutzer hat dies übersprungen, wird er auf den Startbildschirm weitergeleitet. Über das Icon oben links können die Einstellungen erreicht werden (2). Weiterhin symbolisiert ein grünes / rotes Watch-Symbol, ob das Mi-Band aktuell verbunden ist (1). Zusätzlich findet sich ein AI-Toggle, welches den intelligenten Modus innerhalb der App aktiviert (3). 
## KI aus 
Ist die KI deaktiviert, werden die in den Einstellungen vorgenommen Parameter für die Meditation genutzt. 
## KI an 
Ist die KI aktiviert und ein M-Band verbunden, werden durch zufälliges Durchschalten der Meditationsparameter in den ersten 20 Minuten (2x 10 Minuten Meditationssession) Trainingsdaten für das KI-Modell gesammelt. Anschließend werden diese Daten zum Trainieren eines KI-Modells genutzt, welches dann in darauffolgenden Sessions die bestmöglichen Meditationsparameter auswählt. Das Modell probiert anhand der Echtzeit Herzrate genau die Parameter zu finden, mit dennen sich der Nutzer bestmöglichst entspannen kann (niedrige Herzrate). 
3. Einstellungen
Über das Einstellungsicon oben links erreicht der User die Einstellungen. Hier können verschiene Einstellungen zu den Meditationsparametern vorgenommen werden. Weiterhin kann die Session-Dauer konfiguriert und das Mi-Band entkoppelt werden. Auch findet sich eine eindeutig dem User zugeordnete UUID, über die dieser in einer neueren Version der App die Möglichkeit haben soll, seine Daten auf einem anderen Gerät wiederherzustellen.
3. Meditationssession
Durch den großen Start-Button in der Mitte des Homescreens kommt der Nutzer in eine Meditationssessions (4). Hier wird bei gekoppeltem Mi-Band die Herzrate angezeigt. Ist die Watch nicht gekoppelt, werden aktuell zufällige Dummy-Werte für die Herzrate erzeugt. Zusätzlich zur Echtzeit-Visualisierung bekommt der Nutzer durch den sich bewegenden Kreis in der Mitte des Bildschirms eine Atemanleitung, welche zur Beruhigung dienen soll (6). 

4. Zusammenfassung der Sessions
Um einen Überblick über vergangene Sessions zu bekommen, befindet sich unten auf dem Homescreen ein Button der dem Nutzer eine Übersicht seiner bisherigen Meditationen aufzeigt (5). Hier können Details über die Länge der Meditation, die verwendeten Parameter und die Herzrate eingesehen werden. 