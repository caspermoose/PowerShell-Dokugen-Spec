# Katalog_v2-1-2.ps1
# PowerShell-Dokumentationsgenerator - Template Katalog v2.1.2
# Alle Standardkapitel, Variablen, Marker und Content-Schablonen
# 
# Status:
#   - Bereich 1: Allgemein & Organisation (komplett)
#   - Bereich 2: Infrastruktur & Standort (komplett)
#   - Bereiche 3-5: Struktur-Vorlage (zur Erweiterung)

$TemplateCatalog = @(

    # ============================================================
    # HAUPTBEREICH 1: Allgemein & Organisation (KOMPLETT)
    # ============================================================
    
    [pscustomobject]@{
        Id = '1'
        Title = 'Allgemein & Organisation'
        Chapters = @(
            
            # 1.1 Dokumentinformationen
            [pscustomobject]@{
                Id = '1.1'
                Title = 'Dokumentinformationen'
                Description = 'Titel, Version, Verfasser und Status des IT-Dokuments'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='DOKUMENT_TITEL'
                        DisplayName='Dokumenttitel'
                        Type='Text'
                        Required=$true
                        Default='IT-Dokumentation'
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='DOKUMENT_VERSION'
                        DisplayName='Dokumentversion'
                        Type='Text'
                        Required=$false
                        Default='1.0'
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='VERFASSER_NAME'
                        DisplayName='Verfasser'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='VERFASSER_DATUM'
                        DisplayName='Erstellungsdatum'
                        Type='Date'
                        Required=$false
                        Default=''
                        Validation='Date'
                    }
                )
                Content = @"
# {{DOKUMENT_TITEL}}

**Version:** {{DOKUMENT_VERSION}}  
**Verfasser:** {{VERFASSER_NAME}}  
**Datum:** {{VERFASSER_DATUM}}  

---

Dieses Dokument beschreibt die IT-Infrastruktur und die Netzwerk-Konfiguration der Organisation.
"@
                Repeatable = $false
                Marker = $null
            }
            
            # 1.2 Firma und Geltungsbereich
            [pscustomobject]@{
                Id = '1.2'
                Title = 'Firma und Geltungsbereich'
                Description = 'Grundinformationen zum Unternehmen und Geltungsbereich der Dokumentation'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='KUNDE_FIRMA'
                        DisplayName='Firmenname'
                        Type='Text'
                        Required=$true
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='KUNDE_ORT'
                        DisplayName='Standort/Ort'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='KUNDE_EMAIL'
                        DisplayName='E-Mail der Firma'
                        Type='Email'
                        Required=$false
                        Default=''
                        Validation='Email'
                    }
                    [pscustomobject]@{ 
                        Name='GELTUNGSBEREICH'
                        DisplayName='Geltungsbereich der Dokumentation'
                        Type='MultiLineText'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
## Firma

**Name:** {{KUNDE_FIRMA}}  
**Standort:** {{KUNDE_ORT}}  
**E-Mail:** {{KUNDE_EMAIL}}  

## Geltungsbereich

{{GELTUNGSBEREICH}}
"@
                Repeatable = $false
                Marker = $null
            }
            
            # 1.3 Ansprechpartner
            [pscustomobject]@{
                Id = '1.3'
                Title = 'Ansprechpartner'
                Description = 'IT-Ansprechpartner und Kontaktpersonen'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='ANSPRECHPARTNER_1_NAME'
                        DisplayName='Ansprechpartner 1: Name'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='ANSPRECHPARTNER_1_ROLLE'
                        DisplayName='Ansprechpartner 1: Rolle'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='ANSPRECHPARTNER_1_EMAIL'
                        DisplayName='Ansprechpartner 1: E-Mail'
                        Type='Email'
                        Required=$false
                        Default=''
                        Validation='Email'
                    }
                )
                Content = @"
<!-- BEGIN ANSPRECHPARTNER_GRUPPE -->
### {{ANSPRECHPARTNER_ROLLE}}
<!-- BEGIN ANSPRECHPARTNER -->
- **{{ANSPRECHPARTNER_NAME}}** ({{ANSPRECHPARTNER_ROLLE}})  
  E-Mail: {{ANSPRECHPARTNER_EMAIL}}
<!-- END ANSPRECHPARTNER -->
<!-- END ANSPRECHPARTNER_GRUPPE -->
"@
                Repeatable = $true
                Marker = 'ANSPRECHPARTNER'
            }
            
            # 1.4 Änderungsverlauf
            [pscustomobject]@{
                Id = '1.4'
                Title = 'Änderungsverlauf'
                Description = 'Dokumentation von Änderungen und Updates'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='AENDERUNG_1_DATUM'
                        DisplayName='Änderung 1: Datum'
                        Type='Date'
                        Required=$false
                        Default=''
                        Validation='Date'
                    }
                    [pscustomobject]@{ 
                        Name='AENDERUNG_1_BESCHREIBUNG'
                        DisplayName='Änderung 1: Beschreibung'
                        Type='MultiLineText'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='AENDERUNG_1_AUTOR'
                        DisplayName='Änderung 1: Autor'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
| Datum | Beschreibung | Autor |
|-------|--------------|-------|
<!-- BEGIN AENDERUNG -->
| {{AENDERUNG_DATUM}} | {{AENDERUNG_BESCHREIBUNG}} | {{AENDERUNG_AUTOR}} |
<!-- END AENDERUNG -->
"@
                Repeatable = $true
                Marker = 'AENDERUNG'
            }
            
            # 1.5 Provider, Lizenzen und Verträge
            [pscustomobject]@{
                Id = '1.5'
                Title = 'Provider, Lizenzen und Verträge'
                Description = 'Verwaltete Verträge, Lizenzen und Provider'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='PROVIDER_1_NAME'
                        DisplayName='Provider 1: Name'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='PROVIDER_1_TYP'
                        DisplayName='Provider 1: Typ'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='PROVIDER_1_KONTAKT'
                        DisplayName='Provider 1: Kontakt'
                        Type='Email'
                        Required=$false
                        Default=''
                        Validation='Email'
                    }
                    [pscustomobject]@{ 
                        Name='PROVIDER_1_VERTRAG'
                        DisplayName='Provider 1: Vertrag bis'
                        Type='Date'
                        Required=$false
                        Default=''
                        Validation='Date'
                    }
                )
                Content = @"
<!-- BEGIN PROVIDER_GRUPPE -->
### {{PROVIDER_TYP}}
<!-- BEGIN PROVIDER -->
- **{{PROVIDER_NAME}}**  
  Kontakt: {{PROVIDER_KONTAKT}}  
  Vertrag bis: {{PROVIDER_VERTRAG}}
<!-- END PROVIDER -->
<!-- END PROVIDER_GRUPPE -->
"@
                Repeatable = $true
                Marker = 'PROVIDER'
            }
            
            # 1.6 Offene Punkte und Risiken
            [pscustomobject]@{
                Id = '1.6'
                Title = 'Offene Punkte und Risiken'
                Description = 'Bekannte Risiken und offene Punkte'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='RISIKO_1_BESCHREIBUNG'
                        DisplayName='Risiko 1: Beschreibung'
                        Type='MultiLineText'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='RISIKO_1_PRIORITAET'
                        DisplayName='Risiko 1: Priorität'
                        Type='Text'
                        Required=$false
                        Default='Mittel'
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='RISIKO_1_STATUS'
                        DisplayName='Risiko 1: Status'
                        Type='Text'
                        Required=$false
                        Default='Offen'
                        Validation='Text'
                    }
                )
                Content = @"
| Risiko | Priorität | Status |
|--------|-----------|--------|
<!-- BEGIN RISIKO -->
| {{RISIKO_BESCHREIBUNG}} | {{RISIKO_PRIORITAET}} | {{RISIKO_STATUS}} |
<!-- END RISIKO -->
"@
                Repeatable = $true
                Marker = 'RISIKO'
            }
        )
    }
    
    # ============================================================
    # HAUPTBEREICH 2: Infrastruktur & Standort (KOMPLETT)
    # ============================================================
    
    [pscustomobject]@{
        Id = '2'
        Title = 'Infrastruktur & Standort'
        Chapters = @(
            
            # 2.1 Standort und Technikräume
            [pscustomobject]@{
                Id = '2.1'
                Title = 'Standort und Technikräume'
                Description = 'Physikalische Standorte und Technikräume'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='STANDORT_1_NAME'
                        DisplayName='Standort 1: Name'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='STANDORT_1_ADRESSE'
                        DisplayName='Standort 1: Adresse'
                        Type='MultiLineText'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='STANDORT_1_TECHNIKRAUM'
                        DisplayName='Standort 1: Technikraum vorhanden'
                        Type='Boolean'
                        Required=$false
                        Default='$false'
                        Validation='Boolean'
                    }
                )
                Content = @"
<!-- BEGIN STANDORT_GRUPPE -->
### {{STANDORT_NAME}}

**Adresse:** {{STANDORT_ADRESSE}}  
**Technikraum vorhanden:** {{STANDORT_TECHNIKRAUM}}
<!-- END STANDORT_GRUPPE -->
"@
                Repeatable = $true
                Marker = 'STANDORT'
            }
            
            # 2.2 Internetanschluss und Provider
            [pscustomobject]@{
                Id = '2.2'
                Title = 'Internetanschluss und Provider'
                Description = 'Internet-Provider und Verbindungstypen'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='INTERNET_PROVIDER'
                        DisplayName='Internet-Provider'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='INTERNET_TYP'
                        DisplayName='Verbindungstyp (z.B. DSL, Glasfaser, LTE)'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='INTERNET_BANDBREITE_DOWN'
                        DisplayName='Bandbreite Download (Mbit/s)'
                        Type='Integer'
                        Required=$false
                        Default=''
                        Validation='Integer'
                    }
                    [pscustomobject]@{ 
                        Name='INTERNET_BANDBREITE_UP'
                        DisplayName='Bandbreite Upload (Mbit/s)'
                        Type='Integer'
                        Required=$false
                        Default=''
                        Validation='Integer'
                    }
                )
                Content = @"
**Provider:** {{INTERNET_PROVIDER}}  
**Verbindungstyp:** {{INTERNET_TYP}}  
**Bandbreite Download:** {{INTERNET_BANDBREITE_DOWN}} Mbit/s  
**Bandbreite Upload:** {{INTERNET_BANDBREITE_UP}} Mbit/s
"@
                Repeatable = $false
                Marker = $null
            }
            
            # 2.3 Netzwerkgeräte und Hardwareinventar
            [pscustomobject]@{
                Id = '2.3'
                Title = 'Netzwerkgeräte und Hardwareinventar'
                Description = 'IT-Hardware und Netzwerkgeräte'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='HARDWARE_1_TYP'
                        DisplayName='Hardware 1: Typ (z.B. Firewall, Switch, Server)'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='HARDWARE_1_HERSTELLER'
                        DisplayName='Hardware 1: Hersteller'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='HARDWARE_1_MODELL'
                        DisplayName='Hardware 1: Modell'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='HARDWARE_1_HOSTNAME'
                        DisplayName='Hardware 1: Hostname'
                        Type='Hostname'
                        Required=$false
                        Default=''
                        Validation='Hostname'
                    }
                    [pscustomobject]@{ 
                        Name='HARDWARE_1_SERIENNUMMER'
                        DisplayName='Hardware 1: Seriennummer'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
<!-- BEGIN HARDWARE_GRUPPE -->
### {{HARDWARE_TYP}}
<!-- BEGIN HARDWARE -->
- **{{HARDWARE_HERSTELLER}} {{HARDWARE_MODELL}}**  
  Hostname: {{HARDWARE_HOSTNAME}}  
  Seriennummer: {{HARDWARE_SERIENNUMMER}}
<!-- END HARDWARE -->
<!-- END HARDWARE_GRUPPE -->
"@
                Repeatable = $true
                Marker = 'HARDWARE'
            }
        )
    }
    
    # ============================================================
    # HAUPTBEREICH 3: Netzwerk & Konnektivität
    # (STRUKTUR-VORLAGE – zur Erweiterung markiert)
    # ============================================================
    
    [pscustomobject]@{
        Id = '3'
        Title = 'Netzwerk & Konnektivität'
        Description = '[v2.1.2: Struktur-Vorlage – bitte vollständig ausarbeiten]'
        Chapters = @(
            
            # 3.1 Netzwerkübersicht
            [pscustomobject]@{
                Id = '3.1'
                Title = 'Netzwerkübersicht'
                Description = 'Übersicht der Netzwerk-Architektur'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='NETZWERK_TOPOLOGIE'
                        DisplayName='Netzwerk-Topologie'
                        Type='MultiLineText'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
## Netzwerk-Architektur

{{NETZWERK_TOPOLOGIE}}

[HINWEIS: Vollständige Netzwerk-Übersicht erforderlich]
"@
                Repeatable = $false
                Marker = $null
            }
            
            # 3.2 Netzwerkbereiche und VLANs
            [pscustomobject]@{
                Id = '3.2'
                Title = 'Netzwerkbereiche und VLANs'
                Description = 'VLAN-Konfiguration und Netzwerkbereiche'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='VLAN_1_NAME'
                        DisplayName='VLAN 1: Name'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='VLAN_1_ID'
                        DisplayName='VLAN 1: ID'
                        Type='Integer'
                        Required=$false
                        Default=''
                        Validation='VLAN'
                    }
                )
                Content = @"
<!-- BEGIN VLAN_GRUPPE -->
| VLAN-Name | VLAN-ID | Beschreibung |
|-----------|---------|--------------|
<!-- BEGIN VLAN -->
| {{VLAN_NAME}} | {{VLAN_ID}} | {{VLAN_BESCHREIBUNG}} |
<!-- END VLAN -->
<!-- END VLAN_GRUPPE -->

[HINWEIS: Vollständige VLAN-Dokumentation erforderlich]
"@
                Repeatable = $true
                Marker = 'VLAN'
            }
            
            # 3.3 IP-Adress- und DHCP-Übersicht
            [pscustomobject]@{
                Id = '3.3'
                Title = 'IP-Adress- und DHCP-Übersicht'
                Description = 'IP-Adressierungsschema und DHCP-Bereiche'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='DHCP_BEREICH_1_NAME'
                        DisplayName='DHCP-Bereich 1: Name'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='DHCP_BEREICH_1_START'
                        DisplayName='DHCP-Bereich 1: Start-IP'
                        Type='IPv4'
                        Required=$false
                        Default=''
                        Validation='IPv4'
                    }
                    [pscustomobject]@{ 
                        Name='DHCP_BEREICH_1_END'
                        DisplayName='DHCP-Bereich 1: End-IP'
                        Type='IPv4'
                        Required=$false
                        Default=''
                        Validation='IPv4'
                    }
                )
                Content = @"
| DHCP-Bereich | Start-IP | End-IP |
|--------------|----------|--------|
<!-- BEGIN DHCP_BEREICH -->
| {{DHCP_BEREICH_NAME}} | {{DHCP_BEREICH_START}} | {{DHCP_BEREICH_END}} |
<!-- END DHCP_BEREICH -->

[HINWEIS: Vollständige IP-Übersicht erforderlich]
"@
                Repeatable = $true
                Marker = 'DHCP_BEREICH'
            }
            
            # 3.4 WLAN
            [pscustomobject]@{
                Id = '3.4'
                Title = 'WLAN'
                Description = 'Wireless-Netzwerk-Konfiguration'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='WLAN_1_SSID'
                        DisplayName='WLAN 1: SSID'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='WLAN_1_SICHERHEIT'
                        DisplayName='WLAN 1: Sicherheit (z.B. WPA2, WPA3)'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
| SSID | Sicherheit | Status |
|------|-----------|--------|
<!-- BEGIN WLAN -->
| {{WLAN_SSID}} | {{WLAN_SICHERHEIT}} | [Aktiv/Inaktiv] |
<!-- END WLAN -->

[HINWEIS: Vollständige WLAN-Dokumentation erforderlich]
"@
                Repeatable = $true
                Marker = 'WLAN'
            }
            
            # 3.5 OpenVPN für Homeoffice
            [pscustomobject]@{
                Id = '3.5'
                Title = 'OpenVPN für Homeoffice'
                Description = 'VPN-Konfiguration für Fernzugriff'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='VPN_SERVER'
                        DisplayName='VPN-Server Hostname/IP'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Hostname'
                    }
                    [pscustomobject]@{ 
                        Name='VPN_PORT'
                        DisplayName='VPN-Port'
                        Type='Integer'
                        Required=$false
                        Default='1194'
                        Validation='Port'
                    }
                )
                Content = @"
**VPN-Server:** {{VPN_SERVER}}  
**Port:** {{VPN_PORT}}  
**Protokoll:** [Hier Protokoll angeben]  

[HINWEIS: Vollständige VPN-Dokumentation erforderlich]
"@
                Repeatable = $false
                Marker = $null
            }
            
            # 3.6 Firewall und Freigaben
            [pscustomobject]@{
                Id = '3.6'
                Title = 'Firewall und Freigaben'
                Description = 'Firewall-Konfiguration und Regeln'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='FIREWALL_REGEL_1_BESCHREIBUNG'
                        DisplayName='Firewall-Regel 1: Beschreibung'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='FIREWALL_REGEL_1_QUELLE'
                        DisplayName='Firewall-Regel 1: Quell-IP'
                        Type='IPv4'
                        Required=$false
                        Default=''
                        Validation='IPv4'
                    }
                    [pscustomobject]@{ 
                        Name='FIREWALL_REGEL_1_ZIEL'
                        DisplayName='Firewall-Regel 1: Ziel-IP'
                        Type='IPv4'
                        Required=$false
                        Default=''
                        Validation='IPv4'
                    }
                )
                Content = @"
| Beschreibung | Quelle | Ziel | Status |
|--------------|--------|------|--------|
<!-- BEGIN FIREWALL_REGEL -->
| {{FIREWALL_REGEL_BESCHREIBUNG}} | {{FIREWALL_REGEL_QUELLE}} | {{FIREWALL_REGEL_ZIEL}} | [Aktiv/Inaktiv] |
<!-- END FIREWALL_REGEL -->

[HINWEIS: Vollständige Firewall-Dokumentation erforderlich]
"@
                Repeatable = $true
                Marker = 'FIREWALL_REGEL'
            }
        )
    }
    
    # ============================================================
    # HAUPTBEREICH 4: Systeme & Dienste
    # (STRUKTUR-VORLAGE – zur Erweiterung markiert)
    # ============================================================
    
    [pscustomobject]@{
        Id = '4'
        Title = 'Systeme & Dienste'
        Description = '[v2.1.2: Struktur-Vorlage – bitte vollständig ausarbeiten]'
        Chapters = @(
            
            # 4.1 Server, NAS und wichtige Dienste
            [pscustomobject]@{
                Id = '4.1'
                Title = 'Server, NAS und wichtige Dienste'
                Description = 'Verwaltete Server und Dienste'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='SERVER_1_NAME'
                        DisplayName='Server 1: Name'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Hostname'
                    }
                    [pscustomobject]@{ 
                        Name='SERVER_1_BETRIEBSSYSTEM'
                        DisplayName='Server 1: Betriebssystem'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='SERVER_1_DIENSTE'
                        DisplayName='Server 1: Dienste'
                        Type='MultiLineText'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
<!-- BEGIN SERVER_GRUPPE -->
### {{SERVER_NAME}}

**Betriebssystem:** {{SERVER_BETRIEBSSYSTEM}}  
**Dienste:** {{SERVER_DIENSTE}}
<!-- END SERVER_GRUPPE -->

[HINWEIS: Vollständige Server-Dokumentation erforderlich]
"@
                Repeatable = $true
                Marker = 'SERVER'
            }
            
            # 4.2 Benutzer und Berechtigungen
            [pscustomobject]@{
                Id = '4.2'
                Title = 'Benutzer und Berechtigungen'
                Description = 'Benutzerverwaltung und Berechtigungskonzept'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='BENUTZER_1_NAME'
                        DisplayName='Benutzer 1: Name'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='BENUTZER_1_ROLLE'
                        DisplayName='Benutzer 1: Rolle'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
| Benutzer | Rolle | Gruppen |
|----------|-------|---------|
<!-- BEGIN BENUTZER -->
| {{BENUTZER_NAME}} | {{BENUTZER_ROLLE}} | [Gruppen eintragen] |
<!-- END BENUTZER -->

[HINWEIS: Vollständige Benutzer-Dokumentation erforderlich]
"@
                Repeatable = $true
                Marker = 'BENUTZER'
            }
        )
    }
    
    # ============================================================
    # HAUPTBEREICH 5: Sicherheit & Notfall
    # (STRUKTUR-VORLAGE – zur Erweiterung markiert)
    # ============================================================
    
    [pscustomobject]@{
        Id = '5'
        Title = 'Sicherheit & Notfall'
        Description = '[v2.1.2: Struktur-Vorlage – bitte vollständig ausarbeiten]'
        Chapters = @(
            
            # 5.1 Backup und Wiederherstellung
            [pscustomobject]@{
                Id = '5.1'
                Title = 'Backup und Wiederherstellung'
                Description = 'Backup-Strategie und Wiederherstellungsverfahren'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='BACKUP_1_ZIEL'
                        DisplayName='Backup 1: Ziel-System'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Hostname'
                    }
                    [pscustomobject]@{ 
                        Name='BACKUP_1_FREQUENZ'
                        DisplayName='Backup 1: Häufigkeit'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='BACKUP_1_AUFBEWAHRUNG'
                        DisplayName='Backup 1: Aufbewahrungsdauer'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
| Ziel | Häufigkeit | Aufbewahrung |
|------|-----------|--------------|
<!-- BEGIN BACKUP -->
| {{BACKUP_ZIEL}} | {{BACKUP_FREQUENZ}} | {{BACKUP_AUFBEWAHRUNG}} |
<!-- END BACKUP -->

[HINWEIS: Vollständige Backup-Dokumentation erforderlich]
"@
                Repeatable = $true
                Marker = 'BACKUP'
            }
            
            # 5.2 Notfall- und Wiederanlaufanleitungen
            [pscustomobject]@{
                Id = '5.2'
                Title = 'Notfall- und Wiederanlaufanleitungen'
                Description = 'Verfahren für Notfallszenarien'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='NOTFALL_KONTAKT'
                        DisplayName='Notfall-Kontaktperson'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                    [pscustomobject]@{ 
                        Name='NOTFALL_HOTLINE'
                        DisplayName='Notfall-Hotline'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
**Notfall-Kontakt:** {{NOTFALL_KONTAKT}}  
**Notfall-Hotline:** {{NOTFALL_HOTLINE}}  

[HINWEIS: Vollständige Notfall-Dokumentation erforderlich]
"@
                Repeatable = $false
                Marker = $null
            }
            
            # 5.3 Monitoring und Wartung
            [pscustomobject]@{
                Id = '5.3'
                Title = 'Monitoring und Wartung'
                Description = 'Monitoring-Strategien und Wartungsverfahren'
                Variables = @(
                    [pscustomobject]@{ 
                        Name='MONITORING_1_SYSTEM'
                        DisplayName='Monitoring 1: System'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Hostname'
                    }
                    [pscustomobject]@{ 
                        Name='MONITORING_1_METRIK'
                        DisplayName='Monitoring 1: Überwachte Metrik'
                        Type='Text'
                        Required=$false
                        Default=''
                        Validation='Text'
                    }
                )
                Content = @"
| System | Metrik | Schwellenwert |
|--------|--------|---------------|
<!-- BEGIN MONITORING -->
| {{MONITORING_SYSTEM}} | {{MONITORING_METRIK}} | [Schwellenwert] |
<!-- END MONITORING -->

[HINWEIS: Vollständige Monitoring-Dokumentation erforderlich]
"@
                Repeatable = $true
                Marker = 'MONITORING'
            }
        )
    }
)

# Export für Generator
Export-ModuleMember -Variable TemplateCatalog
