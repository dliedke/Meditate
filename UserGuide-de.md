## Vermittler Garmin App Benutzeranleitung

### Funktionen

- Fähigkeit, die Vermittlungssitzung als Garmin Connect Aktivität zu speichern
  - Aktivitätstyp **Meditation** oder **Yoga**
- Möglichkeit, mehrere Meditations-/Yoga-Sitzungen zu konfigurieren
  - Zum Beispiel: eine 20-minütige Sitzung mit 1-minütigen wiederholten Alarmen, eine Erinnerung an den Ablauf nach 10 Minuten
- Jede Sitzung unterstützt Intervall-Vibrationsalarme
  - Intervallalarme können in Abständen von wenigen Sekunden bis zu wenigen Stunden ausgelöst werden
- Vorkonfigurierte Standardmeditationssitzungen mit 5/10/15/20/25/30min und auch kurze Vibrationsintervalle alle 5min
- Erweiterte Voreinstellungen für 45min und 1h mit kurzen Vibrationsalarmen alle 15min
- [HRV](https://en.wikipedia.org/wiki/Heart_rate_variability) (Herzfrequenzvariabilität)
  - RMSSD - Die Wurzel des Mittelquadratunterschieds (herzschlagübergreifenden) Intervalle
  - pNN20 - % erfolgreicher Intervallunterschiede von mehr als 20ms
  - pNN50 - % erfolgreicher Intervallunterschiede von mehr als 50ms
  - Intervall zu Intervall - direkt vom Uhr Sensor abgelesen
  - HRV Erfolgsunterschiede - Unterschiede zwischen den aktuellen und vorherigen Intervallunterschieden
  - SDRR - [Standardabweichung](https://en.wikipedia.org/wiki/Standard_deviation) der internen Intervalle
    - berechnet von den ersten und letzten 5min der Sitzung
  - HRV RMSSD 30 Sek Fenster - RMSSD berechnet für 30 Sekunden Intervall
  - Herz aus Herzschlag - Intervall umgewandelt in HR
- Stressverfolgung
  - Stress - Zusammenfassung des durchschnittlichen Stresses während der Sitzung
  - Durchschnittlicher Stress für den Anfang und das Ende der Sitzung (automatisch von der Uhr berechnet, wenn die Sitzung 5min oder mehr dauert)
  - HR Spitzen 10 Sekunden-Fenster
    - interne Metrik für die Berechnung von Stress

- Atemfrequenz
  - Berechnungen pro Minute in Echtzeit, die auf den Sitzungsdaten basieren (nur für Yoga-Aktivität und Fehler in der Connect IQ API für Atemaktivität)
- konfigurierbare Vorbereitungszeit vor der Meditationssitzung
- Zusammenfassung der Statistiken am Ende der Sitzung
  - Herzrate-Darstellung, einschließlich min, avg und max HR
  - Atemfrequenz
  - HRV
- Pause/Wiederaufnehmen der aktuellen Sitzung mit der Rücktaste
- Möglichkeit, Standard benutzerdefinierten Aktivitätsnamen in Garmin Connect mit Garmin Express in PC verbunden zu konfigurieren via die Uhr USB Kabel

### Anwendung

#### 1. Eine Sitzung starten

1.1. Drücken Sie auf die Schaltfläche "Start" von der Sitzungsauswahl oder berühren Sie den Bildschirm (nur auf Geräten mit dieser Funktion).

1.2. Der Bildschirm "Fortschritt der Sitzung" zeigt die folgenden Elemente:
- Abgelaufene Zeit
  - zeigt den Prozentanteil der abgelaufenen Sitzungszeit
  - ein voller Kreis bedeutet, dass die Sitzung abgelaufen ist
- Intervallalert-Trigger
  - die kleinen markierten Punkte repräsentieren die Zeit einer Intervallalarm-Auslöser
  - jede markierte Position entspricht einer Alarmauslösezeit
  - Sie können sie pro Alarm verbergen, indem Sie eine durchsichtige Farbe aus den [Erweiterten Alarmeinstellungen][2-konfigurieren-eine-sitzung] auswählen
- abgelaufene Zeit
- aktuelle Herzfrequenz
- aktuelle HRV Erfolgsdifferenz
  - Differenz zwischen dem aktuellen Intervall und dem vorherigen Intervall der messbaren internen Intervalle
  - zeigt nur, wann HRV-Tracking eingeschaltet ist
  - **um gute HRV-Werte zu erhalten, müssen Sie die Handgelenkbewegung während der Sitzung minimieren**
- aktuelle Respiration Ratenabschätzung, berechnet durch die Uhr
  - **um gute Respiration Lesungen zu erhalten, müssen Sie die Handgelenkbewegung minimieren**

Die Meditationssitzung wird abgeschlossen, sobald Sie die Start-Stop-Taste drücken. Die Meditationssitzung ist pausierbar/fortsetzbar, indem Sie die Rücktaste verwenden. Bildschirme während der Sitzung können mittels der Lichttaste aktiviert/deaktiviert oder durch Berühren des Bildschirms (nur Geräte mit dieser Funktion) gesteuert werden.

1.3. Einmal die Sitzung endet, haben Sie die Möglichkeit, sie zu speichern.

1.3.1. Sie können konfigurieren, automatisch zu speichern oder automatisch die Sitzung über die [Globale Einstellungen][4-globale-einstellungen] - > [Bestätigen Speichern][4-2-konfiguration-von-einer-session]. 

1.4. Wenn Sie sich im Einzelsitzungsmodus befinden (Standard), sehen Sie den Zusammenfassung-Bildschirm (für den Mehrfachsitzungsmodus, siehe den nächsten Abschnitt **1.5**). Wischen Sie auf/ab (nur für Touch-Geräte) oder drücken Sie nach oben/unten, um die Zusammenfassungsstatistiken von HR, Stress, und HRV zu sehen. Gehen Sie von dieser Ansicht zurück, um die App zu verlassen. 

1.5 Wenn Sie sich im Mehrfachsitzungsmodus befinden (bestimmt durch die [Globale Einstellungen][4-globale-einstellungen] - > [Mehrfachsitzung][43-multi-session]), dann kehren Sie zurück zur Sitzungsauswahl. Dort können Sie eine weitere Sitzung starten. Sobald Sie Ihre Sitzung abschließen, können Sie zurück zur Sitzungsübersicht gehen, um die Sitzungen-Zusammenfassung zu sehen.

1.6. Von der Sitzungen-Zusammenfassung-Ansicht aus können Sie in einzelne Sitzungen eintauchen oder die App beenden. Das Hinunterdrillen zeigt die Zusammenfassungsstatistiken von HR, Atemfrequenz, Stress und HRV. Wenn Sie von der Sitzungen-Zusammenfassung zurückkehren, können Sie weitere Sitzungen durchführen.

#### 2. Eine Sitzung konfigurieren

2.1. Vom Sitzungswähler-Bildschirm aus halten Sie die Mitteltaste (linke Mitte) gedrückt, bis Sie das Sitzungseinstellungsmenü sehen.
  - Bei unterstützten Touchscreen-Geräten können Sie auch den Bildschirm berühren und halten.

2.2. In Neu/Hinzufügen können Sie konfigurieren:
- Zeit - Gesamtdauer der Sitzung in H:MM-Format
- Farbe - Die Farbe der Sitzung, die in grafischen Kontrollen verwendet wird; Auswahl durch Hoch/Runter-Bewegung auf der Uhr (Vivoactive 3/4/Venu - wische hoch/runter)
- Vibe-Muster - kürzere oder längere Pattern, die vom Pulsieren oder kontinuierlichen
- Intervall-Alarme - Fähigkeit, mehrere intermediäre Alarme zu konfigurieren
  - Wenn Sie sich in einer spezifischen Intervall-Alarmeinstellung befinden, sehen Sie im Menü den Alarm ID (z.B. Alarm 1) im Vergleich zur aktuellen Sitzung Intervall Alarme
  - Zeit
      - Wählen Sie eine-off oder wiederholende Alerts
      - Wiederholende Alerts erlauben kürzere Laufzeiten als eine Minute
      - Nur ein einziger Alarm wird zu jeder gegebenen Zeit ausgeführt
      - Priorität der Alerts mit der gleichen Zeit wie
        1. Erster Alert
        2. Letzter eine-off Alarm
        3. Letzter wiederholender Alarm
  - Farbe - die Farbe des aktuellen Intervalls, das in der grafischen Kontrolle verwendet wird. Wählen Sie unterschiedliche Farben für jeden Alarm, um sie während der Mediation zu unterscheiden. Wählen Sie eine durchsichtige Farbe, wenn Sie keine visuellen Markierungen für den Alarm während der Mediation wünschen
  - Vibe-Muster/Sound - kürzere oder längere Pattern, die vom Pulsieren oder kontinuierlichem oder Sound
- Aktivitätstyp - Fähigkeit, die Sitzung als **Meditation** oder **Yoga** zu speichern. Sie können den Standard-Aktivitätstyp für neue Sitzungen von den Globalen Einstellungen aus konfigurieren. ([siehe Abschnitt 4](#4-globale-einstellungen)).
- HRV Tracking - bestimmt, ob HRV und Stress getrackt werden
  - EIN - verfolgt Stress und die folgenden HRV Metriken
    - RMSSD
    - HRV Unterschied
    - Stress
    - beat-to-beat- Intervall
    - pNN50
    - pNN20
    - HR aus Herzschlag
    - RMSSD 30 Sek Fenster
    - HR Peaks 10 Sec Window
    - SDRR Erste 5 Minuten der Sitzung
    - SDRR Letzte 5 Minuten der Sitzung
  - AUS (Standard) - verfolgt extra Stress und HRV-Metriken zusätzlich zur **Ein** Option
    - RMSSD
    - HRV Erfolg Unterschiede
    - Beat-to-Beat-Intervall
    - SDRR Erste 5 Minuten der Sitzung
    - SDRR Letzte 5 Minuten der Sitzung
    - RMSSD 30 Sekunden Fenster
    - Herz vom Herzschlag
- **Detailliert (Standard)** - verfolgt extra Stress und HRV Metriken zusätzlich zur **Ein** Option
    - RMSSD
    - HRV Erfolgsunterschiede
    - Beat to Beat-Intervall
    - pNN50
    - pNN20
    - pNN50
    - HR aus Herzschlag
    - RMSSD 30 Sek Fenster 
    - Herzpeaks 10 Sek-Fenster
    - SDRR Erste 5 Minuten der Sitzung
    - SDRR Letzte 5 Minuten der Sitzung
    - RMSDD 30 Sekunden Fenster 
    - Herz vom Herzschlag
          
2.3 Löschen - Löscht eine Sitzung nach Bestätigung

2.4 Globale Einstellungen - [siehe Abschnitt 4](#4-globale-einstellungen)

#### 3. Eine Sitzung auswählen

Vom Sitzungswähler-Bildschirm aus können Sie in der oberen/niederen Richtung klicken (für Touch-Geräte wischen Sie nach oben/unten). Auf diesem Bildschirm können Sie die anwendbaren Einstellungen der ausgewählten Sitzungen sehen.
- Aktivitätstyp - im Titel
  - Meditate
- Zeit - gesamte Dauer der Sitzung
- Vibe Pattern
- Intervall Alert Trigger
  - das Diagramm in der Mitte des Bildschirms repräsentiert den relativen Alert-Trigger-Zeit im Vergleich zur gesamten Sitzungszeit
- HRV Indikator
  - [Aus](/userGuideScreenshots/hrvIndicatorOff.png) Aus - sind Indikatoren, die Stress und HRV ausgeschaltet sind
  - ![Wartend HRV](/userGuideScreenshots/hrvIndicatorWaitingHrv.png) Wartend HRV 
    - der Herzfrequenzsensor erfasst keine HRV
    - Sie können die Sitzung beginnen, aber Ihnen werden die HRV-Daten fehlen, es wird empfohlen, das Gerät ruhig zu halten, bis die HRV bereit ist
  - ![HRV Bereit](/userGuideScreenshots/hrvIndicatorReady.png) HRV Bereit 
    - der Herzfrequenzsensor erfasst HRV
    - die Sitzung verfolgt standardmäßig HRV und Stress-Metriken
    - **die Sitzung kann mit zuverlässigen HRV-Daten aufzeichnet werden, sie benötigen minimale Bewegungen**

#### 4. Globale Einstellungen

Vom Sitzungswähler-Bildschirm halten Sie die Mitteltaste (oder berühren und halten den Bildschirm) bis Sie das Einstellung Menü sehen. Wählen Sie das Menü der globalen Einstellungen. Sie sehen eine Ansicht mit dem Status der globalen Einstellungen. Halten Sie die Menü-Taste erneut, (oder berühren und halten Sie den Bildschirm), um globale Einstellungen zu bearbeiten.


#### 4.1 HRV Nachverfolgung

Diese Einstellung stellt das **HRV Tracking** für neue Sitzungen standardmäßig bereit.
- **Ein** - verfolgt standardmäßig HRV Metriken und Stress
    - RMSSD
    - Erfolgsdifferenzen
    - Stress
- **Detailliert** - erweiterte HRV und Stress-Metriken
    - RMSSD
    - Erfolgsdifferenzen
    - Beat-to-Beat-Intervall
    - pnN50
    - PnN20
    - Herz aus Herzschlag
    - RMSSD 30 Sek Fenster
    - Herzpeaks 10 Sek-Fenster
    - SDRR Erste 5 Minuten der Sitzung
    - SDRR Letzte 5 Minuten der Sitzung
- **Aus** - überwacht HRV und Stress nicht

#### 4.2 Bestätigen Speichern

- Fragen - wenn eine Aktivität beendet wird, fragt ob die Speicherung erreicht 
- Auto Ja - wenn eine Aktivität abgeschlossen wird, wird sie automatisch gespeichert
- Auto Nein - wenn eine Aktivität abgeschlossen wird, wird sie automatisch verworfen

#### 4.3 Multi-Session

- Ja 
  - die App setzt fort, nach dem Abschluss einer Sitzung zu laufen
  - Sie können mehrere Sitzungen erfassen
- Nein
  - die App schließet sich nach dem Beenden einer Sitzung

#### 4.4 Vorbereitungszeit

- 0 Sek - keine Vorbereitungszeit
- 15 Sek (Standard) - 15 Sekunden für das Vorbereiten vor dem Starten der Meditationssitzung
- 30 Sek - 30 Sekunden für das Vorbereiten vor dem Starten der Meditationssitzung
- 60 Sek - 1 Minute für das Vorbereiten vor dem Starten der Meditationssitzung 

#### 4.5 Atemfrequenz
- Ein (Standard) - Atemfrequenzmetriken während Sitzung aktiviert
- Aus - Atemfrequenzmetriken während Sitzung deaktiviert  

#### 4.6 Neuer Aktivitätstyp

Sie können den Standardaktivitätstyp für neue Sitzungen auswählen.
- Yaga
- Meditation
