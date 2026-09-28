# Variablen-Erfassungs-Workflow

**Spezifikation:** PowerShell-Dokumentationsgenerator v2.1  
**Datum:** 28.09.2026  
**Status:** Entwurf  
**Implementierungsdetail:** Szenario B (Editor-basiert mit Config-Prefill)

---

## 1. Gesamtablauf (integriert in Hauptablauf)

```
Schritt 1–6: Baukasten (Vorlage zusammenstellen)
    ↓
Schritt 7: Vorlage speichern & VORLAGE= in .config aktualisieren
    ↓
**[NEU] Schritt 7.5: Config mit Variablen-Gerüst befüllen**
    ↓
Schritt 8: Variablen erfassen (über Editor)
    ↓
Schritt 9: Markdown erzeugen
    ↓
Schritt 10: HTML-Konverter prüfen
```

---

## 2. Schritt 7.5: Config-Prefill beim Baukasten-Abschluss

### Zeitpunkt
Nach erfolgreicher Vorlage-Speicherung (nach Baukasten Schritt 8 der ursprünglichen Spezifikation).

### Ablauf

**2.1 Vorlage wird gescannt**
```powershell
# Generator ruft auf:
$Variables = Get-TemplateVariables -TemplatePath "templates/kmu_musterfirma_individuell.md"
# Rückgabe: Array mit allen {{PLATZHALTER}} aus der Vorlage
```

**2.2 Für jede Variable wird geprüft, ob sie bereits in .config existiert**
```
KUNDE_FIRMA=...          # existiert → wird behalten
KUNDE_ORT=               # existiert aber leer → bleibt leer
NEUE_VARIABLE=           # neu erkannt → wird hinzugefügt mit leerem Wert
```

**2.3 Neue/fehlende Variablen werden in .config eingefügt**

```text
# FIRMENDATEN
DOKUMENT_TITEL=
DOKUMENT_VERSION=
KUNDE_FIRMA=
KUNDE_ORT=
VERFASSER_NAME=
HARDWARE_1_TYP=
# ... (alle aus der Vorlage erkannten Variablen)

# PROJEKTVERWALTUNG
PROJEKT_NAME=musterfirma
VORLAGE=kmu_musterfirma_individuell.md
```

**2.4 `.config` wird atomar gespeichert**
- Temporäre Datei schreiben
- Bei Erfolg: alte Datei ersetzen
- Bei Fehler: Abbruch mit Fehlermeldung

**2.5 Benutzer erhält Bestätigung**
```
✓ Vorlage gespeichert: templates/kmu_musterfirma_individuell.md
✓ Config aktualisiert: configs/musterfirma.config
  
27 Variablen zur Erfassung erkannt.
→ Menü 5 wählen, um Werte einzutragen.
```

---

## 3. Schritt 8: Variablen erfassen (Editor-basiert)

### Trigger
Benutzer wählt: **Menü 5: Markdown- und HTML-Dokument generieren**

### Pre-Flight-Check
```
1. .config existiert? → JA
2. Vorlage (in VORLAGE=) existiert? → JA
3. Variablen aus Vorlage scannen
4. Mit .config abgleichen
5. Fehlende/neue Variablen gefunden?
```

### Ablauf bei fehlenden Variablen

**3.1 Dialog anzeigen**
```
┌──────────────────────────────────────────────────────────┐
│ Fehlende Variablen für 'musterfirma'                     │
│                                                          │
│ Es wurden 27 Variablen in der Vorlage erkannt.          │
│ Die .config enthält aber noch 12 leere Werte.           │
│                                                          │
│ 1 Config-Datei im Editor öffnen (empfohlen)             │
│ 2 Weiterhin mit leeren Werten generieren                │
│   (→ [FEHLENDER WERT: VARIABLENNAME] im Markdown)       │
│ 3 Vorlage noch mal bearbeiten (Baukasten)               │
│ 0 Abbrechen                                             │
│                                                          │
│ Wähle (1–3, 0): 1                                       │
└──────────────────────────────────────────────────────────┘
```

**3.2 Option 1 gewählt: Editor öffnen**

```powershell
# Generator bestimmt Standard-Editor:
# Windows: notepad.exe
# Linux/macOS: nano oder $EDITOR
# PS-intern: Out-GridView (optional, für PS7)

Invoke-Item "configs/musterfirma.config"
# oder
& notepad "configs/musterfirma.config"
```

**3.3 Benutzer bearbeitet .config manuell**

Beispiel-Edit im Editor:
```
# FIRMENDATEN
DOKUMENT_TITEL=IT-Dokumentation Firmennetzwerk
DOKUMENT_VERSION=1.0
KUNDE_FIRMA=Musterfirma GmbH
KUNDE_ORT=Frankfurt am Main          # ← benutzer füllt aus
VERFASSER_NAME=Erika Beispiel
HARDWARE_1_TYP=Firewall
HARDWARE_1_HOSTNAME=firewall01
...
```

**3.4 Datei speichern und schließen**

Benutzer speichert (`Ctrl+S`) und schließt Editor.

**3.5 Generator wartet auf Editor-Schließung**

```powershell
# Wartet, bis Editor geschlossen wurde
# (Script blockiert, bis notepad.exe beendet ist)

# Nach Rückkehr:
Write-Host "Editor geschlossen. Fahre fort..."
```

**3.6 .config wird erneut validiert**

```
1. Datei existiert und ist lesbar?
2. Syntaktisch gültig? (NAME=WERT format)
3. Keine doppelten Schlüssel?
4. Keine offensichtlichen Secrets eingegeben?
   → Warnung: "PASSWORT_XYZ eingegeben. Sicher?"
5. Keine ungültigen Variablennamen?
```

Wenn Fehler: Benutzer kann zurück zu Optionsmenü.

---

## 4. Ablauf Option 2: Mit leeren Werten weitermachen

**4.1 Benutzer wählt Option 2**

```
Wähle (1–3, 0): 2

⚠ Warnung: Es fehlen noch 12 Werte:
  - KUNDE_ORT
  - VERFASSER_NAME
  - HARDWARE_2_TYP
  - ... (Liste)

Diese werden im Markdown als [FEHLENDER WERT: NAME] ausgegeben.

Wirklich weitermachen? (j/n): j
```

**4.2 Markdown wird mit Platzhaltern erzeugt**

```markdown
# IT-Dokumentation Firmennetzwerk

**Firma:** Musterfirma GmbH  
**Ort:** [FEHLENDER WERT: KUNDE_ORT]  
**Verfasser:** [FEHLENDER WERT: VERFASSER_NAME]  

## Hardware

- Firewall: firewall01
- [FEHLENDER WERT: HARDWARE_2_TYP]: [FEHLENDER WERT: HARDWARE_2_HOSTNAME]
```

**4.3 Log-Eintrag**

```
[2026-09-28 14:23:45] INFO [Generate-Markdown] 12 fehlende Werte in musterfirma.md
[2026-09-28 14:23:45] WARN [Generate-Markdown] KUNDE_ORT fehlt
[2026-09-28 14:23:45] WARN [Generate-Markdown] VERFASSER_NAME fehlt
```

---

## 5. Ablauf Option 3: Vorlage bearbeiten

**5.1 Benutzer wählt Option 3**

```
Wähle (1–3, 0): 3

→ Zurück zum Vorlagen-Baukasten
   (Menü 4: Vorlage zusammenstellen, wechseln, anzeigen)
```

**5.2 Nach Baukasten-Änderung**

Neue Vorlage wird gespeichert → **Schritt 7.5 erneut aufgerufen**
→ `.config` wird mit neuen Variablen aktualisiert
→ Dialog erscheint erneut

---

## 6. Pre-Flight-Check: Config wird VOR Markdown-Generierung validiert

### Checkliste
```powershell
function Invoke-PreFlightCheck {
    param([string]$ProjectName)
    
    # 1. .config lesbar?
    if (-not (Test-Path "configs/$ProjectName.config")) {
        throw "Config nicht gefunden!"
    }
    
    # 2. Vorlage existiert?
    $VorlagePath = Read-ConfigValue -Config $Config -Key "VORLAGE"
    if (-not (Test-Path "templates/$VorlagePath")) {
        throw "Vorlage $VorlagePath nicht gefunden!"
    }
    
    # 3. Variablen aus Vorlage scannen
    $TemplateVars = Get-TemplateVariables -TemplatePath "templates/$VorlagePath"
    
    # 4. Mit Config abgleichen
    $ConfigVars = Get-ConfigVariables -ConfigPath "configs/$ProjectName.config"
    
    # 5. Fehlende finden
    $Missing = $TemplateVars | Where-Object { -not $ConfigVars.Contains($_) }
    $Empty = @()
    foreach ($Var in $TemplateVars) {
        $Value = Read-ConfigValue -Config $Config -Key $Var
        if ([string]::IsNullOrWhiteSpace($Value)) {
            $Empty += $Var
        }
    }
    
    # 6. Rückgabe: Zusammenfassung
    return @{
        AllVariables = $TemplateVars.Count
        MissingVars = $Missing.Count
        EmptyVars = $Empty.Count
        Details = $Empty  # Liste der leeren Variablen
    }
}
```

---

## 7. Platzhalter-Ersetzung beim Markdown-Generieren

### Regel: Leere Werte werden zu `[FEHLENDER WERT: NAME]`

```powershell
function Replace-TemplateVariables {
    param(
        [string]$TemplateContent,
        [hashtable]$Variables
    )
    
    $Result = $TemplateContent
    
    foreach ($Var in $Variables.Keys) {
        $Value = $Variables[$Var]
        $Placeholder = "{{$Var}}"
        
        if ([string]::IsNullOrWhiteSpace($Value)) {
            # Leerer Wert → Fehlermeldung im Markdown
            $Result = $Result -replace [regex]::Escape($Placeholder), "[FEHLENDER WERT: $Var]"
        } else {
            # Wert vorhanden → ersetzen
            $Result = $Result -replace [regex]::Escape($Placeholder), $Value
        }
    }
    
    return $Result
}
```

### Beispiel-Output
```markdown
Ort: [FEHLENDER WERT: KUNDE_ORT]
Verfasser: Erika Beispiel
Provider: [FEHLENDER WERT: PROVIDER_NAME]
```

---

## 8. Integration ins Hauptmenü (Menü 5)

### Ablauf: Menü 5 klickt

```
Menü 5: Markdown- und HTML-Dokument generieren
│
├─ Projekt geladen: 'musterfirma'
│
├─ Pre-Flight-Check
│  ├─ .config OK
│  ├─ Vorlage OK
│  └─ 27 Variablen, 12 leer
│
├─ Fehlende Variablen gefunden?
│  │
│  └─ Dialog:
│     1 Config im Editor öffnen (empfohlen)
│     2 Weitermachen mit leeren Werten
│     3 Vorlage bearbeiten
│     0 Abbrechen
│     Wähle: 1
│
├─ → Editor öffnet configs/musterfirma.config
│  Benutzer füllt aus, speichert, schließt
│
├─ Post-Editor-Validierung
│  ├─ Config erneut gescannt
│  ├─ Neue Fehler?
│  │  └─ NEIN → Weiterfahren
│  │
│  └─ Passwort erkannt? (offensichtlicher Secret)
│     └─ JA → Warnung + Confirm
│
├─ Markdown erzeugen
│  └─ Variablen ersetzen (leere → [FEHLENDER WERT: ...])
│
├─ HTML-Konverter prüfen
│  ├─ Pandoc vorhanden? → Stufe 1
│  ├─ MarkdownPS? → Stufe 2
│  ├─ Fallback? → Stufe 3
│  └─ Nichts? → Stufe 0 (nur MD)
│
├─ Dateien speichern
│  ├─ results/md/musterfirma.md ✓
│  └─ results/html/musterfirma.html ✓
│
└─ Abschlussmeldung
   ✓ Markdown erzeugt: results/md/musterfirma.md
   ✓ HTML erzeugt: results/html/musterfirma.html
   Konverter: Pandoc 2.18
   [12 Variablen mit [FEHLENDER WERT: ...] ersetzt]
```

---

## 9. Fehlerbehandlung & Edge Cases

### Fall 1: Benutzer speichert ungültiges Format
```
❌ Fehler beim Laden der Config:
   Zeile 7: KUNDE_FIRMA  (ohne =)
   Zeile 15: KEY=VALUE=EXTRA (zu viele =)

→ Zurück zum Dialog, Benutzer kann erneut wählen
```

### Fall 2: Benutzer gibt Secret ein (Passwort erkannt)
```
⚠ Sicherheitswarnung:
   Zeile 22: ADMIN_PASSWORD=geheim123
   
Diese Variable enthält möglicherweise ein Geheimnis!
Es wird NICHT geloggt und nur im RAM verarbeitet.
Passwörter sollten NICHT in der .config gespeichert werden!

Wirklich weitermachen? (j/n): n
→ Zurück zum Dialog
```

### Fall 3: Editor wird ohne Speichern geschlossen
```
Config nicht verändert. Fahre mit alten Werten fort.
→ Markdown-Generierung mit vorherigen Werten
```

### Fall 4: Vorlage hat neue Variablen, aber Config ist älter
```
⚠ Config ist älter als Vorlage!
Neue Variablen erkannt:
  - NEUE_VAR_1
  - NEUE_VAR_2

Diese werden zur Config hinzugefügt mit leerem Wert.
→ Dialog erscheint, Benutzer kann editieren
```

---

## 10. Dateiablauf (chronologisch)

```
1. Baukasten speichert Vorlage
   → templates/kmu_musterfirma_individuell.md ✓

2. Config wird mit Variablen befüllt
   → configs/musterfirma.config ✓
   (mit leeren Werten und Kommentaren)

3. Benutzer editiert Config
   → configs/musterfirma.config (aktualisiert)

4. Markdown wird generiert
   → results/md/musterfirma.md ✓
   (mit [FEHLENDER WERT: ...] für leere Werte)

5. HTML wird konvertiert
   → results/html/musterfirma.html ✓
   (mit [FEHLENDER WERT: ...] als Text)

6. Log wird geschrieben
   → logs/dokugen_2026-09-28.log ✓
   (alle Aktionen, Fehler, Warnungen)
```

---

## 11. Testfälle für diesen Workflow

| # | Szenario | Erwartung |
|---|----------|-----------|
| T1 | Neues Projekt → Baukasten → Config-Prefill | 27 Variablen in .config, alle leer |
| T2 | Editor öffnen → 5 Werte ausfüllen → speichern | .config hat 5 Werte, 22 leer |
| T3 | Markdown generieren mit 22 leeren Werten | MD enthält 22× [FEHLENDER WERT: ...] |
| T4 | Config mit SECRET_PASSWORD=xyz öffnen | Sicherheitswarnung erscheint |
| T5 | Editor schließen ohne zu speichern | Alte Werte werden verwendet |
| T6 | Vorlage ändert sich (neue Variablen) | Config wird automatisch aktualisiert |
| T7 | Benutzer wählt Option 2 (weitermachen) | Markdown wird mit leeren Werten erzeugt |
| T8 | Benutzer wählt Option 3 (Vorlage ändern) | Zurück zum Baukasten, Config wird erneut aktualisiert |
| T9 | Config-Zeile ungültig (kein =) | Validierungsfehler, Dialog erneut |
| T10 | Alle Werte erfasst, kein [FEHLENDER WERT: ...] | Markdown ohne Fehlermeldungen |

---

## 12. Zusammenfassung: Dein Szenario B

**Du wähltest:**
1. ✅ Szenario B: Editor-basierte Erfassung
2. ✅ Config wird beim Baukasten mit Variablen-Gerüst befüllt
3. ✅ Leere Werte werden zu `[FEHLENDER WERT: NAME]` im Markdown

**Implementierungsaufwand:**
- Get-TemplateVariables: ~100 Zeilen
- Config-Prefill: ~80 Zeilen
- Pre-Flight-Check: ~60 Zeilen
- Replace-TemplateVariables: ~40 Zeilen
- Dialog + Editor-Integration: ~120 Zeilen
- **Gesamt: ~400 Zeilen PowerShell**

**Vorteil:** Pragmatisch, Power-User-freundlich, weniger Code als Szenario C
