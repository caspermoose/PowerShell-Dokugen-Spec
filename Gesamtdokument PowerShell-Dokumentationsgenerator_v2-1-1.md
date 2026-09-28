# Gesamtdokument: PowerShell-Dokumentationsgenerator

**Dateiname:** `Gesamtdokument PowerShell-Dokumentationsgenerator_v2-1-1.md`  
**Projekt:** PowerShell-Dokumentationsgenerator („dokugen")  
**Version:** 2.1.1  
**Status:** Entwurf  
**Datum:** 28.09.2026  
**Zielumgebung:** Windows PowerShell 5.1; PowerShell 7 bevorzugt zusätzlich

## 1. Projektziel

Der Generator erstellt für kleine und mittlere Unternehmen eine strukturierte IT-Dokumentation des Firmennetzwerks. Er verwendet eine einfache `.config`-Textdatei als Datenquelle, eine individuell mit dem Vorlagen-Baukasten erzeugte Markdown-Vorlage und erzeugt daraus Markdown- sowie HTML-Ausgaben.

Zielgruppe sind Unternehmen mit 5–50 Mitarbeitenden, einem oder wenigen Standorten, Homeoffice und gegebenenfalls OpenVPN-Fernzugriff. Die Anwendung muss ohne vertiefte PowerShell-Kenntnisse bedienbar sein.

## 2. Abgrenzung

Der Generator ist kein Configuration- oder Asset-Management-System. Er führt keine Live-Netzwerkerkennung durch, speichert keine Passwörter oder privaten Schlüssel und bietet in Version 1 keine Benutzerverwaltung, kein Ticketing, Monitoring, keine automatische Sicherheitsbewertung, keinen Mehrbenutzerbetrieb und keinen Datenbankserver.

## 3. Begriffe

| Begriff | Bedeutung |
|---|---|
| Projekt | Dokumentation eines Unternehmens oder Standorts |
| Projektname | Validierter technischer Name; Basis aller Projektdateien |
| `.config` | UTF-8-Textdatei mit Firmen- und Projektverwaltungswerten |
| Vorlage | Markdown-Datei mit Kapitelstruktur und Platzhaltern |
| Vorlagen-Baukasten | Interaktiver Assistent zum Zusammenstellen einer Vorlage |
| Hauptbereich | Einer der fünf stets enthaltenen Bereiche |
| Kapitel | Aus dem Katalog vorgeschlagene Unterkategorie |
| Datensatz | Wiederholbares Objekt, z. B. Hardware oder VLAN |
| Platzhalter | `{{VARIABLENNAME}}` |

## 4. Verzeichnis und Dateinamen

Alle Pfade werden relativ zum Skriptverzeichnis gebildet. Das aktuelle Arbeitsverzeichnis darf keine Rolle spielen.

```text
dokugen/
├── GENERATOR_doku_V1.ps1
├── README.md
├── configs/
├── templates/
├── results/md/
├── results/html/
├── logs/
└── backup/
```

Beim Anlegen wird ein technischer Projektname abgefragt. Er wird validiert und automatisch als Basis verwendet:

```text
Projektname: musterfirma
configs/musterfirma.config
results/md/musterfirma.md
results/html/musterfirma.html
templates/kmu_musterfirma_individuell.md
```

Der Firmenname `Musterfirma GmbH` darf davon abweichen und wird als Wert `KUNDE_FIRMA` gespeichert. Eine spätere Änderung des Firmennamens ändert nicht automatisch die Dateinamen. Dadurch entstehen keine unvorhersehbaren zweiten Ausgabedateien.

Zulässige Projektnamen enthalten nur Buchstaben, Ziffern, Bindestrich und Unterstrich; reservierte Windows-Namen, Punkte am Ende sowie `CON`, `PRN`, `AUX`, `NUL`, `COM1`–`COM9` und `LPT1`–`LPT9` werden abgelehnt.

## 5. Architektur und Ablauf

Der Generator folgt einem zweiphasigen Workflow:

**Phase 1: Vorlage erstellen (Baukasten)**
1. Anwendung und Verzeichnisse initialisieren.
2. Neues Projekt mit technischem Projektnamen anlegen.
3. Alle fünf Hauptbereiche werden übernommen.
4. Je Hauptbereich mindestens ein Kapitel auswählen.
5. Kapitelreihenfolge festlegen; eigene Kapitel können ergänzt werden.
6. Vorlage als `kmu_NAME_INDIVIDUELL.md` speichern.
7. `VORLAGE=` in der Projektverwaltung der `.config` setzen.
8. **[NEU v2.1.1] Vorlage wird gescannt: Alle `{{PLATZHALTER}}` werden erkannt.**
9. **[NEU v2.1.1] `.config` wird mit erkannten Variablen befüllt (mit leeren Werten); neue Variablen werden hinzugefügt.**

**Phase 2: Dokumentation erfassen und generieren**
10. **[NEU v2.1.1] Benutzer öffnet `.config` in Standard-Editor und trägt Firmenwerte ein.**
11. **[NEU v2.1.1] Generator validiert `.config` vor Generierung.**
12. Markdown wird erzeugt; leere Variablen werden als `[FEHLENDER WERT: VARIABLENNAME]` ersetzt.
13. Beim Aufruf der HTML-Erzeugung Pandoc bzw. MarkdownPS prüfen und passende Qualitätsstufe verwenden.

## 6. Strikte Dateitrennung

| Datei | Darf enthalten | Darf nicht enthalten |
|---|---|---|
| Skript | Programmlogik, Katalog, Metadaten | konkrete Firmendaten, Secrets |
| individuelle Vorlage | Struktur, Standardtexte, Platzhalter | konkrete Firmendaten |
| `.config` | Firmenwerte und Projektverwaltung | JSON, XML, YAML, PowerShell-Code |
| Markdown/HTML | fertiges Ergebnis | ungelöste Pflichtplatzhalter, interne Daten |

`VORLAGE` ist keine Vorlagenlogik, sondern eine Referenz auf die aktive Vorlagendatei.

## 7. `.config`-Format

Die Datei besteht aus UTF-8-Zeilen im Format `NAME=WERT`. Leerzeilen und Zeilen mit führendem `#` werden übersprungen. Das erste `=` trennt Schlüssel und Wert. Der Schlüssel wird an den Rändern getrimmt; der Wert wird nicht unkontrolliert getrimmt. Ungültige Zeilen, doppelte Schlüssel und ungültige Namen werden gemeldet und geloggt.

### 7.1 Semantische Bereiche

Die Datei enthält zwei klar getrennte Arten von Einträgen:

**FIRMENDATEN:** Werte, die das Unternehmen und seine IT beschreiben, z. B. `KUNDE_FIRMA`, `HARDWARE_1_TYP` oder `VPN_SERVER`.

**PROJEKTVERWALTUNG:** technische Projektreferenzen, die der Generator benötigt. In Version 2.1 gehört dazu insbesondere:

```text
# PROJEKTVERWALTUNG
PROJEKT_NAME=musterfirma
VORLAGE=kmu_musterfirma_individuell.md
```

`VORLAGE` wird beim Erzeugen oder Wechseln automatisch aktualisiert. Eine manuelle Änderung ist möglich, wird beim Laden aber auf eine existierende Datei und einen zulässigen Namen geprüft. Die Projektverwaltung enthält keine Kapitelstruktur und keine Vorlagenlogik.

### 7.2 Automatisches Befüllen bei Baukasten-Abschluss (v2.1.1)

Nach erfolgreicher Vorlage-Speicherung (Schritt 9, Phase 1) werden alle erkannten Platzhalter aus der Vorlage in die `.config` eingefügt:

```text
# FIRMENDATEN
DOKUMENT_TITEL=
DOKUMENT_VERSION=
KUNDE_FIRMA=
KUNDE_ORT=
VERFASSER_NAME=
HARDWARE_1_TYP=
HARDWARE_1_HOSTNAME=
NETZWERK_1_NAME=
VPN_TYP=

# PROJEKTVERWALTUNG
PROJEKT_NAME=musterfirma
VORLAGE=kmu_musterfirma_individuell.md
```

Alle Variablen werden mit leeren Werten eingefügt. Bereits vorhandene Variablen behalten ihre Werte. Die Datei wird atomar (über temporäre Datei) gespeichert.

Beispiel mit Werten:

```text
# FIRMENDATEN
DOKUMENT_TITEL=IT-Dokumentation Firmennetzwerk
DOKUMENT_VERSION=1.0
KUNDE_FIRMA=Musterfirma GmbH
KUNDE_ORT=Frankfurt am Main
VERFASSER_NAME=Erika Beispiel
HARDWARE_1_TYP=Firewall
HARDWARE_1_HOSTNAME=firewall01
NETZWERK_1_NAME=LAN
VPN_TYP=OpenVPN

# PROJEKTVERWALTUNG
PROJEKT_NAME=musterfirma
VORLAGE=kmu_musterfirma_individuell.md
```

Zulässige Variablennamen folgen `^[A-Z][A-Z0-9_]*$`. Secrets werden abgelehnt oder mindestens deutlich gewarnt und niemals geloggt.

## 8. Variablen und Datensätze

Unterstützt werden Text, mehrzeiliger Text, Ganzzahl, Dezimalzahl, Ja/Nein, Datum, E-Mail, IPv4, IPv6, CIDR, Port und Auswahlwert. Wiederholbare Datensätze verwenden die Form `BEREICH_N_FELD`, beispielsweise `HARDWARE_1_TYP`.

Nummern bleiben stabil. Wird ein Datensatz gelöscht, bleibt die Nummer als Lücke frei; neue Datensätze erhalten die nächste freie Nummer nach dem höchsten bisher verwendeten Index. Die Nummer ist zugleich die Datensatznummer im Ergebnis. Das Verhalten gilt auch bei manueller `.config`-Bearbeitung. Ungültige Indexformen wie `HARDWARE_1_5_TYP` werden gemeldet und nicht als regulärer Datensatz verarbeitet.

## 9. Vorlagen-Baukasten

### 9.1 Verbindliche Struktur

Alle fünf Hauptbereiche sind Pflichtbestandteil jeder Vorlage:

1. Allgemein & Organisation
2. Infrastruktur & Standort
3. Netzwerk & Konnektivität
4. Systeme & Dienste
5. Sicherheit & Notfall

Innerhalb jedes Hauptbereichs wählt der Benutzer mindestens ein Kapitel. Kapitel sind frei auswählbar und frei anordenbar. Eigene Kapitel mit Titel und Markdown-Inhalt sind zulässig. Ohne mindestens ein Kapitel je Hauptbereich wird die Vorlage abgelehnt.

### 9.2 Ablauf

1. technischen Vorlagennamen eingeben; Ergebnis `kmu_NAME_individuell.md`;
2. Kapitel je Hauptbereich einzeln auswählen;
3. Reihenfolge der Hauptbereiche und Kapitel festlegen;
4. eigene Kapitel ergänzen;
5. Vorschau anzeigen;
6. bestätigen;
7. bei bestehender Datei Überschreiben und optionales Backup bestätigen;
8. Vorlage atomisch speichern und `VORLAGE` aktualisieren;
9. **[NEU v2.1.1] Vorlage scannen, Variablen extrahieren und `.config` befüllen.**

Ein Abbruch vor der Bestätigung (Schritt 6) verändert keine Datei.

### 9.3 Platzhaltererkennung

Alle Vorkommen des Musters `{{VARIABLENNAME}}` werden aus der gesamten Vorlagendatei extrahiert. Gültig sind nur Namen nach `^[A-Z][A-Z0-9_]*$`.

1. **Automatische Erkennung:** Auch manuell ergänzte Platzhalter werden erkannt.
2. **Unbekannte Variablen:** Sind sie syntaktisch gültig, werden sie als benutzerdefinierte Variablen in die `.config` aufgenommen.
3. **Tippfehlerprüfung:** Für unbekannte Variablen werden ähnliche bekannte Namen vorgeschlagen, z. B. `NETZWERK_1_NETT` → `NETZWERK_1_NAME`, `NETZWERK_1_NETZ`. Der Benutzer kann korrigieren, als neue Variable akzeptieren oder abbrechen.

Ungültige Platzhalter werden nicht stillschweigend ersetzt. Sie erzeugen eine Warnung; die Generierung kann bei Konfiguration „streng" abgebrochen werden.

### 9.4 Pflichtfelder

Jedes Katalogkapitel und jede bekannte Variable besitzt Metadaten. Alle Kapitelvariablen sind in Version 2.1 standardmäßig optional; die Metadaten enthalten dennoch `Required`, damit einzelne Felder später oder projektspezifisch als Pflichtfeld festgelegt werden können. Die fünf Hauptbereiche selbst sind strukturell verpflichtend; alle fünf müssen mindestens ein Kapitel enthalten.

**[GEÄNDERT v2.1.1]** Fehlende optionale Werte werden standardmäßig als `[FEHLENDER WERT: NAME]` in Markdown und HTML ausgegeben und gemeldet. Fehlende als `Required=true` gekennzeichnete Werte blockieren standardmäßig die Generierung. Der Benutzer kann einen ausdrücklich angebotenen Übergehvorgang nutzen; dieser muss protokolliert werden.

Beispiel einer Abfrage (falls `Required=true` Wert fehlt):

```text
Pflichtwert fehlt: KUNDE_FIRMA (Kapitel 1.2)
1 Jetzt ausfüllen
2 Trotzdem generieren
3 Abbrechen
```

### 9.5 Wiederholbare Bereiche und Sortierung

Bereichsmarker haben die Form:

```markdown
<!-- BEGIN HARDWARE_GRUPPE -->
### {{HARDWARE_GRUPPE_TYP}}
<!-- BEGIN HARDWARE -->
- Gerät {{HARDWARE_INDEX}}: {{HARDWARE_HERSTELLER}} {{HARDWARE_MODELL}}
<!-- END HARDWARE -->
<!-- END HARDWARE_GRUPPE -->
```

Bei Datensatzarten mit Typfeld wird zuerst alphabetisch nach Typ gruppiert, danach innerhalb der Gruppe nach stabiler Datensatznummer. Die Nummer im Datensatz ist die Nummer im Dokument. Beispiel: Hardware 1 Firewall, 2 NAS, 3 NAS, 4 Switch ergibt die Gruppen Firewall, NAS, Switch und die Gerätenummern 1, 2, 3, 4. Die Benutzerreihenfolge in der `.config` verändert diese Regel nicht.

Datensatzarten ohne Typfeld werden ausschließlich nach Nummer sortiert. Ungruppierte Marker bleiben zulässig.

### 9.6 Zwischenüberschriften

Zwischenüberschriften werden innerhalb jedes Kapitels durchgehend nummeriert. Bei Kapitel `2.3` lauten sie `2.3.1`, `2.3.2`, `2.3.3` usw. Mehrere wiederholbare Bereiche teilen sich denselben Zähler in ihrer tatsächlichen Vorlagenreihenfolge. Entfällt eine Gruppe, werden die verbleibenden Gruppen neu und lückenlos nummeriert. Dadurch können sich Nummern nach einer Strukturänderung ändern; Querverweise müssen deshalb über stabile Kapitel-IDs oder Textbezeichnungen erfolgen, nicht über automatisch erzeugte Gruppennummern.

## 10. Katalogstruktur in PowerShell

Der Katalog ist Teil des Skripts und enthält keine Firmendaten. Die konkrete Struktur muss mindestens folgende Felder enthalten:

```powershell
$TemplateCatalog = @(
    [pscustomobject]@{
        Id = '1'
        Title = 'Allgemein & Organisation'
        Chapters = @(
            [pscustomobject]@{
                Id = '1.1'; Title = 'Dokumentinformationen'
                Description = 'Titel, Version, Verfasser und Status'
                Variables = @(
                    [pscustomobject]@{ Name='DOKUMENT_TITEL'; DisplayName='Dokumenttitel'; Type='Text'; Required=$false; Default=''; Validation=$null }
                    [pscustomobject]@{ Name='DOKUMENT_VERSION'; DisplayName='Dokumentversion'; Type='Text'; Required=$false; Default='1.0'; Validation=$null }
                )
                Content = '# {{DOKUMENT_TITEL}}'
                Repeatable = $false
                Marker = $null
            }
        )
    }
)
```

Jedes Kapitel benötigt mindestens ID, Titel, Beschreibung, Inhalt, Variablenmetadaten, Pflichtfeldstatus und Angaben zu wiederholbaren Markern. `Get-TemplateCatalog` liefert den Katalog; `Get-TemplateVariables` scannt zusätzlich die tatsächliche Datei.

## 11. Standardkapitel

| Hauptbereich | Standardkapitel |
|---|---|
| 1 Allgemein & Organisation | 1.1 Dokumentinformationen; 1.2 Firma und Geltungsbereich; 1.3 Ansprechpartner; 1.4 Änderungsverlauf; 1.5 Provider, Lizenzen und Verträge; 1.6 Offene Punkte und Risiken |
| 2 Infrastruktur & Standort | 2.1 Standort und Technikräume; 2.2 Internetanschluss und Provider; 2.3 Netzwerkgeräte und Hardwareinventar |
| 3 Netzwerk & Konnektivität | 3.1 Netzwerkübersicht; 3.2 Netzwerkbereiche und VLANs; 3.3 IP-Adress- und DHCP-Übersicht; 3.4 WLAN; 3.5 OpenVPN für Homeoffice; 3.6 Firewall und Freigaben |
| 4 Systeme & Dienste | 4.1 Server, NAS und wichtige Dienste; 4.2 Benutzer und Berechtigungen |
| 5 Sicherheit & Notfall | 5.1 Backup und Wiederherstellung; 5.2 Notfall- und Wiederanlaufanleitungen; 5.3 Monitoring und Wartung |

Die ausführlichen Inhaltsfelder umfassen insbesondere Netzwerkgeräte, IPs, VLANs, WLAN, OpenVPN, Firewallregeln, Server, Dienste, Benutzer, Backups, Notfallkontakte, Provider, Verträge, Risiken und Änderungsverlauf. Passwörter und private Schlüssel sind ausgeschlossen.

## 12. Menüs und Funktionen

Hauptmenü:

```text
1 Neues Projekt anlegen
2 Bestehendes Projekt öffnen
3 Projekt bearbeiten
4 Vorlage zusammenstellen, wechseln, anzeigen
5 Markdown- und HTML-Dokument generieren
6 Projekte verwalten
7 Einstellungen
0 Beenden
```

Alle Untermenüs erlauben Zurück, Abbruch mit `A` oder `0` und Speichern mit `S`. Änderungen werden vor dem Verlassen erkannt.

### 12.1 Menü 5: Markdown- und HTML-Dokument generieren (v2.1.1)

**Pre-Flight-Check:**
1. `.config` existiert und ist lesbar?
2. Vorlage (in `VORLAGE=`) existiert?
3. Variablen aus Vorlage scannen.
4. Mit `.config` abgleichen.
5. Leere oder fehlende Variablen gefunden?

**Dialog bei leeren/fehlenden Variablen:**
```
┌──────────────────────────────────────────────────────────┐
│ Fehlende oder leere Variablen für 'musterfirma'          │
│                                                          │
│ Es wurden 27 Variablen in der Vorlage erkannt.          │
│ Die .config enthält aber noch 12 leere Werte:           │
│   - KUNDE_ORT                                           │
│   - VERFASSER_NAME                                      │
│   - HARDWARE_2_TYP                                      │
│   - ... (weitere)                                       │
│                                                          │
│ 1 Config-Datei im Standard-Editor öffnen (empfohlen)   │
│ 2 Trotzdem generieren                                   │
│   (→ [FEHLENDER WERT: NAME] wird in MD/HTML eingefügt)  │
│ 3 Vorlage noch mal bearbeiten                           │
│ 0 Abbrechen                                             │
│                                                          │
│ Wähle (1–3, 0): 1                                       │
└──────────────────────────────────────────────────────────┘
```

**Option 1:** Editor öffnen
- `.config` wird in Standard-Editor geöffnet (notepad/nano/vim/code)
- Benutzer füllt Werte aus, speichert, schließt
- Generator wartet bis Editor beendet ist
- `.config` wird erneut validiert
- Falls Fehler oder Secret erkannt: Menü erneut anzeigen
- Sonst: Weiterfahren zu Schritt 12

**Option 2:** Trotzdem generieren
- Alle leeren Variablen werden in Markdown und HTML als `[FEHLENDER WERT: VARIABLENNAME]` eingefügt
- Werte mit Inhalt werden normal ersetzt
- Generator fährt mit Schritt 12 fort

**Option 3:** Vorlage bearbeiten
- Zurück zu Menü 4 (Vorlagen-Baukasten)
- Nach Änderung und Speicherung wird automatisch `.config` aktualisiert (Schritt 9)
- Menü 5 kann erneut aufgerufen werden

Empfohlene Funktionen:

```text
Initialize-Application, Initialize-Directories, Get-ApplicationPaths
Show-MainMenu, Show-ProjectMenu, Show-TemplateMenu
Get-TemplateCatalog, Invoke-TemplateBuilder, New-IndividualTemplate
Read-ConfigFile, Write-ConfigFile, Parse-ConfigLine, Validate-Config
Get-TemplateVariables, Replace-TemplateVariables, Prefill-ConfigVariables
Invoke-PreFlightCheck, Invoke-ConfigEditor, Validate-ConfigAfterEdit
Get-RepeatingRecords, Add-Record, Edit-Record, Remove-Record
Generate-Markdown, Generate-Html, Test-ExternalConverter
Backup-ProjectFile, Write-Log, Confirm-Action
```

## 13. Validierung

### 13.1 Config-Validierung beim Baukasten-Abschluss (v2.1.1)

Nach automatischem Prefill werden folgende Prüfungen durchgeführt:
- Datei ist UTF-8 und syntaktisch gültig (`NAME=WERT` Format)
- Keine doppelten Variablennamen
- Alle Variablennamen folgen `^[A-Z][A-Z0-9_]*$`

### 13.2 Config-Validierung vor Markdown-Generierung (v2.1.1)

Nach Benutzer-Edit oder vor Generierung:
- Pflichtwerte (bei `Required=true`) nicht leer
- Datentypen korrekt (Text, Int, Dezimal, Bool, Datum, E-Mail, IPv4, IPv6, CIDR, Port)
- Dateinamen-Validierung
- E-Mail, IPv4/IPv6, CIDR, Gateway, DHCP-Bereich, VLAN 1–4094 und Ports 1–65535 korrekt
- Doppelte Variablen, doppelte IPs, überlappende VPN-Netze gemeldet
- Offensichtliche Secrets (PASSWORT, PASSWORD, SECRET, etc.) gewarnt
- Keine unkontrollierten Programmabbrüche durch Benutzereingaben

## 14. HTML-Erzeugung

Die Prüfung erfolgt erst beim Aufruf von „Markdown- und HTML-Dokument generieren" (Menü 5, Schritt 12+).

**Qualitätsstufe 1 – Pandoc:** Wenn `pandoc` gefunden wird, erzeugt es strukturiertes HTML mit Überschriften, Tabellen, Listen, Codeblöcken und UTF-8. Die konkrete erkannte Version wird angezeigt.

**Qualitätsstufe 2 – MarkdownPS-Modul:** Wenn Pandoc fehlt, wird geprüft, ob ein geeignetes MarkdownPS-Modul verfügbar ist. Bei Erfolg wird dieses verwendet.

**Qualitätsstufe 3 – einfacher Fallback:** Wenn beide Optionen fehlen oder nicht ausführbar sind, erzeugt das Programm eine einfache, gültige HTML-Grundstruktur mit UTF-8, Überschriften, Listen, Tabellen und Codeblöcken, soweit der Parser dies sicher unterstützt. Die Ausgabe wird als „vereinfachtes HTML" gekennzeichnet.

**Qualitätsstufe 0 – nur Markdown:** Wenn auch der Fallback nicht durchführbar ist, wird nur Markdown erzeugt. Der Benutzer erhält die Meldung, dass Pandoc oder ein MarkdownPS-Modul installiert werden kann. Eine fehlende externe Abhängigkeit darf die Markdown-Erzeugung nicht verhindern.

Beispielmeldung:

```text
✓ Markdown erzeugt: results/md/musterfirma.md
✓ HTML erzeugt: results/html/musterfirma.html
Konverter: Pandoc 2.18
Hinweis: [12 Variablen mit [FEHLENDER WERT: ...] ersetzt]
```

## 15. Fehlerbehandlung, Logging und Backup

Fehler werden verständlich angezeigt und zusätzlich in `logs/dokugen_JJJJ-MM-TT.log` mit Zeitstempel, Level, Funktion und Meldung protokolliert. Secrets dürfen nicht in Meldungen oder Logs erscheinen.

**[GEÄNDERT v2.1.1]** Vor dem Überschreiben vorhandener Konfigurationen, Vorlagen und Ergebnisse wird gefragt. Für kritische Dateien, insbesondere eine vorhandene Vorlage, wird vor dem Überschreiben standardmäßig ein Backup angeboten bzw. entsprechend der Einstellung automatisch angelegt. Backups können als `.bak` oder datiertem Ordner gespeichert werden. Backupfehler werden gemeldet und geloggt; unvollständige Zieldateien dürfen nicht entstehen. Speichern soll nach Möglichkeit über eine temporäre Datei und anschließendes Ersetzen erfolgen.

**[NEU v2.1.1]** `.config` wird nach Benutzer-Edit (im Editor) erneut validiert:
- Datei noch lesbar?
- Syntax OK?
- Keine neuen Secrets?
- Variablen-Namen OK?
Fehler werden geloggt und im Dialog angezeigt; Benutzer kann zurück zu Editor oder Menü.

## 16. Abnahmekriterien

- Projektname wird einmal validiert und bildet die Basis aller Dateinamen.
- `.config` bleibt einfache Textdatei und trennt FIRMENDATEN und PROJEKTVERWALTUNG.
- Alle fünf Hauptbereiche sind vorhanden; je Hauptbereich ist mindestens ein Kapitel enthalten.
- Kapitel sind wählbar, umsortierbar und durch eigene Kapitel erweiterbar.
- Abbruch des Baukastens verändert keine Datei.
- Platzhalter werden vollständig erkannt, validiert und gemeldet.
- Unbekannte syntaktisch gültige Platzhalter können aufgenommen werden; Tippfehler werden vorgeschlagen.
- Pflichtfeldentscheidungen basieren auf Kapitel-/Variablenmetadaten.
- Datensatznummern bleiben stabil; Löschungen hinterlassen Lücken.
- Sortierung erfolgt nach Typ und Nummer wie beschrieben.
- Zwischenüberschriften werden je Kapitel durchgehend nummeriert.
- Markdown wird UTF-8 erzeugt; HTML-Konverter wird erst bei der Generierung geprüft.
- Vor Überschreiben wird gefragt; kritische Vorlagen können gesichert werden.
- Keine Passwörter oder privaten Schlüssel werden gespeichert oder geloggt.
- **[NEU v2.1.1] Nach Baukasten-Abschluss wird `.config` automatisch mit erkannten Variablen befüllt.**
- **[NEU v2.1.1] Leere Variablen werden beim Markdown-Generieren als `[FEHLENDER WERT: NAME]` ersetzt.**
- **[NEU v2.1.1] Editor-Workflow für Config-Erfassung funktioniert; Config wird nach Edit validiert.**

## 17. Testfälle

| # | Szenario | Erwartung |
|---|----------|-----------|
| 1 | Neues Projekt mit technischem Namen `musterfirma` erzeugt die vier erwarteten Dateipfade | ✓ |
| 2 | Änderung von `KUNDE_FIRMA` ändert nicht den technischen Dateinamen | ✓ |
| 3 | Vorlage mit `{{CUSTOM_FIELD_1}}` wird erkannt und kann als neue Variable gespeichert werden | ✓ |
| 4 | Ungültiger Platzhalter bzw. Tippfehler wird gemeldet und mit ähnlichen Namen angezeigt | ✓ |
| 5 | Vorlage ohne Kapitel in einem Hauptbereich wird abgelehnt | ✓ |
| 6 | Fehlendes optionales Feld erzeugt Ersatztext; fehlendes `Required=true` blockiert standardmäßig | ✓ |
| 7 | Hardware 2 wird gelöscht; Hardware 3 bleibt Hardware 3 und wird als solche ausgegeben | ✓ |
| 8 | Hardware wird nach Typ, dann Nummer gruppiert | ✓ |
| 9 | Eine zusätzliche Gruppe erhält die nächste durchgehende Zwischenüberschriftsnummer | ✓ |
| 10 | Pandoc vorhanden: Pandoc wird verwendet | ✓ |
| 11 | Pandoc und MarkdownPS fehlen: Fallbackmeldung wird angezeigt und Markdown bleibt verfügbar | ✓ |
| 12 | Baukastenabbruch erzeugt oder verändert keine Vorlage | ✓ |
| 13 | Überschreiben einer bestehenden Vorlage fragt und erstellt vorab ein Backup | ✓ |
| **T14** | **[NEU v2.1.1] Nach Baukasten-Speicherung wird `.config` mit allen erkannten Variablen befüllt** | **27 Variablen in .config, alle leer** |
| **T15** | **[NEU v2.1.1] Benutzer öffnet `.config` im Editor und trägt 5 Werte ein** | **Editor öffnet, speichert, schließt; .config hat 5 Werte, 22 leer** |
| **T16** | **[NEU v2.1.1] Markdown-Generierung mit 22 leeren Variablen** | **MD enthält 22× [FEHLENDER WERT: ...], Warnungen geloggt** |
| **T17** | **[NEU v2.1.1] `.config` mit SECRET_PASSWORD=geheim123 bearbeitet** | **Sicherheitswarnung beim Laden, Benutzer kann abbrechen** |
| **T18** | **[NEU v2.1.1] Editor-Schließung ohne Speichern** | **Alte Werte bleiben erhalten, Warnung angezeigt** |
| **T19** | **[NEU v2.1.1] Vorlage ändert sich (neue Variablen hinzugefügt)** | **`.config` wird automatisch mit neuen Variablen aktualisiert** |
| **T20** | **[NEU v2.1.1] Benutzer wählt Option 2 (trotzdem generieren)** | **Markdown mit leeren Werten generiert, Warnungen geloggt** |

## 18. Lieferumfang und Priorisierung

Lieferumfang: PowerShell-Skript, README, Verzeichnisse, Katalog, Beispielprojekt, Beispielvorlage, Beispielausgabe, Beschreibung des `.config`-Formats, Platzhalterregeln, Baukasten, HTML-Abhängigkeiten, Testprotokoll und Versionsinformationen.

**Muss:** Projektverwaltung, Text-Config, Baukasten, fünf Hauptbereiche, Markdown, Fehlermeldungen, Netzwerk/Hardware/OpenVPN/Benutzer/Backup, **Config-Prefill, Editor-Workflow, Variablen-Erfassung**.  
**Soll:** PowerShell-7-Unterstützung, Wiederholungsmarker, Validierung, Backups, Änderungsverlauf und Vorschau.  
**Kann:** PDF, GUI, Diagramme, CSV, externe Katalogdatei, Vorlagenvergleich.

## 19. Versionshistorie

- **1.0:** Grundkonzept mit Firmenvorlage.
- **1.1:** Statische Vorlagen eingeführt.
- **2.0:** Statische Vorlagen durch den interaktiven Vorlagen-Baukasten ersetzt.
- **2.1:** Automatische Dateinamen; klare Trennung von Firmen- und Projektverwaltungsdaten; automatische Platzhaltererkennung mit Tippfehlerprüfung; Metadaten für Kapitel und Variablen; alle fünf Hauptbereiche verpflichtend; stabile Datensatznummern; durchgehende Zwischenüberschriften; konkreter PowerShell-Katalog; HTML-Qualitätsstufen mit Prüfung beim Generierungsaufruf.
- **2.1.1:** Config-Prefill beim Baukasten-Abschluss; Editor-basierte Variablen-Erfassung (Szenario B); leere Variablen als `[FEHLENDER WERT: NAME]` in Markdown/HTML; Pre-Flight-Check vor Generierung; Menü 5 mit Dialog für Fehlerbehandlung; detaillierte Testfälle für neuen Workflow.
