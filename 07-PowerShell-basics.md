# 💻 PowerShell Basics – Bachelor i digital infrastruktur og cybersikkerhet (NTNU)

> 🧠 Denne guiden er laget for bruk på **virtuell Windows 11** i **OpenStack-miljøet** ved NTNU.  
> Alle kommandoer og øvelser er testet i **PowerShell 7 (Core)**.  
> MacOS- og Linux-brukere kan også følge det meste, men små forskjeller i filstier og enkelte systemkommandoer kan forekomme.

---

## 🧩 Tema 1: Introduksjon til PowerShell

### 🎯 Læringsmål
Etter denne delen skal du kunne:
- Forklare hva PowerShell er og hva det brukes til  
- Kjenne til forskjellen mellom PowerShell, CMD og Bash  
- Kjøre dine første kommandoer og forstå resultatet  

---

### 📖 Hva er PowerShell?

PowerShell er et **kommandolinjeverktøy og skriptspråk** utviklet av Microsoft.  
Det brukes til **administrasjon, automatisering og konfigurasjon** av systemer — både lokalt og i skyen (Azure, Microsoft 365, osv.).

PowerShell er unikt fordi det:
- Sender **objekter**, ikke tekst, mellom kommandoer  
- Er bygd på .NET-plattformen  
- Kan kjøres på **Windows, macOS og Linux**  
- Kombinerer enkel kommandolinjebruk med kraftig skripting  

---

### ⚙️ Eksempler – Første steg i PowerShell

Åpne PowerShell (trykk `Start` → skriv `PowerShell` → velg “Windows PowerShell” eller “PowerShell 7”).

Prøv disse kommandoene:

```powershell
# Viser dagens dato og klokkeslett
Get-Date

# Viser alle prosesser som kjører på systemet
Get-Process

# Viser tjenester på maskinen
Get-Service

# Viser filer og mapper i gjeldende mappe
Get-ChildItem

# Viser din bruker og maskinnavn
$env:USERNAME
$env:COMPUTERNAME
````

💡 **Tips:**
PowerShell bruker alltid formatet **Verb-Substantiv**, f.eks. `Get-Process`, `Set-Service`, `New-Item`.
Dette gjør det lett å forstå hva kommandoene gjør.


### 🔍 Sammenligning med CMD og Bash

| Oppgave               | CMD        | Bash   | PowerShell                   |
| --------------------- | ---------- | ------ | ---------------------------- |
| Vise filer            | `dir`      | `ls`   | `Get-ChildItem` (eller `ls`) |
| Hente dato            | `date /t`  | `date` | `Get-Date`                   |
| Se kjørende prosesser | `tasklist` | `ps`   | `Get-Process`                |

PowerShell forstår ofte kommandoene fra CMD og Bash (som `dir` og `ls`), men den håndterer resultatet **som data**, ikke bare tekst.

---

### 🧠 Prøv selv – Oppgaver

1. Finn PowerShell-versjonen din: 

   ```
   $PSVersionTable.PSVersion
   ```
2. **HVIS** den sier 5.1, gå igjennom guiden for installasjon av chocolate og deretter PowerShell Core (PowerShell 7) for Windows 11 på virtuell maskin. MERK! En kan også kjøre det på egen maskin om ønskelig, men MERK at det er ikke alt som er likt for PowerShell på Windows og MacOS. [Install Choco - PowerShell Core](https://studntnu-my.sharepoint.com/:u:/g/personal/melling_ntnu_no/EUFoqx0uYVtBkn-Kb4SD360BZzK4rdHhXcwPMoXUoSPgIQ) - Start deretter på nytt i PowerShell 7.
3. Finn systemets dato og klokkeslett.

### 🚀 Ekstra utfordring

Prøv å kombinere kommandoer:

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
```

👉 Hva gjør hver del av kommandoen?
👉 Hvordan kunne du brukt dette i et skript som overvåker CPU-bruk?


### 💬 Refleksjon

* Hva er forskjellen mellom PowerShell og CMD?
* Hva betyr det at PowerShell sender “objekter”?
* Hvorfor tror du PowerShell er mye brukt innen cybersikkerhet?


## 🧩 Tema 2: Kommandostruktur og grunnleggende begreper

### 🎯 Læringsmål

Etter denne delen skal du kunne:

* Forklare hvordan PowerShell-kommandoer (cmdlets) er bygd opp
* Bruke `Get-Help`, `Get-Command` og `Get-Member`
* Tolke parametere og forstå hvordan man finner dokumentasjon

---

### 📖 Hva er en cmdlet?

En **cmdlet** er en PowerShell-kommando bygd opp som:
👉 **Verb–Substantiv**, f.eks. `Get-Process`, `Set-Service`, `New-Item`.

Noen vanlige verb:

| Verb         | Betydning             |
| ------------ | --------------------- |
| Get          | Hent data             |
| Set          | Endre data            |
| New          | Opprett noe nytt      |
| Remove       | Slett noe             |
| Start / Stop | Start eller stopp noe |

---

### ⚙️ Eksempler

```powershell
# Hent prosesser
Get-Process

# Stopp en prosess - Hvis den ikke finner en prosess med navn notepad, kan en starte notepad i PowerShell med å skrive notepad.exe: 

Stop-Process -Name notepad

# Opprett en ny mappe
New-Item -Path "C:\Temp\Test" -ItemType Directory
```

💡 **Kommandoer i PowerShell kalles “cmdlets”**, og de returnerer alltid **objekter** med data du kan jobbe videre med.

---

### 🔍 Hjelpeverktøy: Lær å lære PowerShell

```powershell
# Finn alle tilgjengelige kommandoer
Get-Command

# Finn alle kommandoer relatert til tjenester
Get-Command -Noun Service

# Finne alle kommandoer hvor verbet er "Add"
Get-Verb -verb "Add" | Get-Command

# Finn dokumentasjon og eksempler
Get-Help Get-Process -Examples

# Undersøk hvilke egenskaper et objekt har
Get-Process | Get-Member
```

💡 Bruk disse aktivt – de er PowerShells egen “dokumentasjon i terminalen”.

---

### 🧠 Prøv selv – Oppgaver

1. Finn tre kommandoer som starter med `Get-`
2. Finn ut hva `Get-Service` gjør med `Get-Help Get-Service -Examples`
3. Bruk `Get-Member` på `Get-Date` og finn ut hvilke egenskaper dato-objektet har

---

### 🚀 Ekstra utfordring

Finn en kommando som kan opprette nye filer, og bruk `Get-Help` til å finne ut hvordan du spesifiserer filtype og navn.
Bruk så `New-Item` til å opprette din egen `.txt`-fil i `C:\Temp`.

---

### 💬 Refleksjon

* Hvorfor tror du PowerShell bruker samme verb-noun-struktur i alle kommandoer?
* Hvordan hjelper dette deg som systemadministrator?

---

---

## 🧩 Tema 3: Pipeline og objekter i PowerShell

### 🎯 Læringsmål

Etter denne delen skal du kunne:

* Forklare hva en **pipeline** (`|`) er og hvordan den fungerer
* Forstå at PowerShell sender **objekter**, ikke tekst
* Bruke `Where-Object`, `Select-Object`, `Sort-Object` og `Measure-Object`

---

### 📖 Hva er en pipeline?

En pipeline (`|`) sender resultatet fra én kommando videre til neste.
Forskjellen fra CMD/Bash er at PowerShell sender **objekter**, ikke tekst.

```powershell
Get-Process | Sort-Object CPU -Descending
```

Her skjer:

1. `Get-Process` henter alle prosesser
2. `Sort-Object` sorterer resultatet etter CPU-bruk
3. Dataene vises pent i tabellform

---

### ⚙️ Eksempler

```powershell
# Filtrer tjenester som kjører
Get-Service | Where-Object { $_.Status -eq "Running" }

# Vis kun navn og status
Get-Service | Select-Object Name, Status

# Sorter prosesser etter CPU-forbruk
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

# Tell hvor mange tjenester som kjører
Get-Service | Where-Object { $_.Status -eq "Running" } | Measure-Object
```

💡 `$_` betyr “nåværende objekt” i PowerShell – altså elementet som behandles i pipelinen.

---

### 🧠 Prøv selv – Oppgaver

1. Finn alle tjenester som ikke kjører (status “Stopped”).
2. Hent de fem største prosessene basert på minnebruk (`WorkingSet`).
3. Sorter alle prosesser etter CPU og vis kun `Name` og `CPU`.

---

### 🚀 Ekstra utfordringer

1. Lag et PowerShell-script som viser de **10 mest CPU-krevende prosessene** og lagrer resultatet til skrivebordet som `.csv`:

   ```powershell
   Get-Process |
     Sort-Object CPU -Descending |
     Select-Object -First 10 Name, CPU, Id |
     Export-CSV "$HOME/Desktop/top10process.csv" -NoTypeInformation
   ```
2. Filtrer alle tjenester som starter automatisk, men som ikke kjører.

---

### 💬 Refleksjon

* Hva er forskjellen mellom tekstbasert og objektbasert dataflyt?
* Hvorfor er pipeline så nyttig i automatisering?

---

---

## 🧩 Tema 4: Fil- og mappehåndtering

### 🎯 Læringsmål

Etter denne delen skal du kunne:

* Navigere i filsystemet i PowerShell
* Opprette, flytte, kopiere og slette filer og mapper
* Søke og filtrere filer med pipeline
* Lese og skrive innhold i filer

---
### 📂 Navigering mellom mapper i PowerShell

Når du jobber i PowerShell, er det viktig å kunne bevege seg mellom mapper (kataloger) på en enkel måte.  
PowerShell bruker mange av de samme kommandoene som gamle kommandolinjeverktøy (som CMD eller Bash), men i tillegg kan du bruke moderne cmdlets som `Get-ChildItem`.

---

#### 🧭 Grunnleggende navigasjonskommandoer

| Kommando | Forklaring | Eksempel |
|-----------|-------------|-----------|
| `cd <mappe>` | Gå **inn i** en mappe | `cd Dokumenter` |
| `cd ..` | Gå **ett nivå opp** (ut av mappen) | `cd ..` |
| `cd \` | Gå til **rotmappen** på disken | `cd \` |
| `dir` eller `ls` | **List opp** filer og mapper i gjeldende mappe | `dir` |
| `pwd` eller `Get-Location` | Vis **hvor du er** (gjeldende mappe) | `Get-Location` |

---

#### 📘 Eksempel: Navigere mellom mapper

La oss si at du befinner deg i mappen `C:\Users\<brukernavn>\Documents`, og du ønsker å gå inn i en mappe som heter `Prosjekt`:

```powershell
cd Prosjekt
````

Nå står du i `C:\Users\<brukernavn>\Documents\Prosjekt`.

Hvis du ønsker å gå **tilbake ett nivå**, skriver du:

```powershell
cd ..
```

Nå er du tilbake i `Documents`.

Hvis du vil gå **direkte til en bestemt mappe**, kan du skrive hele stien:

```powershell
cd "C:\Users\<brukernavn>\Desktop"
```

💡 Du kan bruke **TAB-tasten** for å autofullføre mappenavn mens du skriver — det sparer mye tid og reduserer skrivefeil.

---

#### 🗂️ Vise filer og mapper

For å se hva som finnes i mappen du står i:

```powershell
dir
```

Dette viser en oversikt over filer og undermapper.
Du kan også bruke aliaset `ls` (fra Linux) eller den fulle cmdleten `Get-ChildItem`:

```powershell
Get-ChildItem
```

For å se innholdet i en **spesifikk mappe**, selv om du ikke står der:

```powershell
Get-ChildItem "C:\Users\<brukernavn>\Desktop"
```

---

#### 💡 Tips for effektiv navigering

* Bruk `Up`-pilen for å hente tidligere kommandoer.
* Bruk **TAB** for automatisk utfylling av mappenavn.
* Skriv `cls` for å **rydde terminalvinduet**.
* Skriv `exit` for å lukke PowerShell.

---

#### 🧠 Prøv selv

1. Åpne PowerShell og gå til skrivebordet ditt:

   ```powershell
   cd "$HOME\Desktop"
   ```
2. Opprett en ny mappe:

   ```powershell
   mkdir TestMappe
   ```
3. Gå inn i mappen:

   ```powershell
   cd TestMappe
   ```
4. Opprett en ny fil og sjekk at den finnes:

   ```powershell
   New-Item info.txt -ItemType File
   dir
   ```
5. Gå ut av mappen igjen:

   ```powershell
   cd ..
   ```

---

💬 **Oppsummering:**

* `cd` brukes til å bytte mappe
* `cd ..` går ett nivå opp
* `dir` (eller `ls`) viser innhold
* `Get-Location` viser hvor du er

Ved å kombinere disse enkle kommandoene kan du navigere raskt og effektivt i PowerShell, akkurat som i et grafisk filsystem – men med mye mer kontroll.

### 📄 Arbeid med filer i PowerShell

Når du har lært å bevege deg mellom mapper, er neste steg å lære hvordan du håndterer filer – altså **oppretter, flytter, kopierer, sletter og viser** innhold.  
PowerShell gjør dette enkelt med et sett kommandoer (cmdlets) som følger et tydelig mønster:  
👉 **Verb–Substantiv**, for eksempel `New-Item`, `Copy-Item`, `Remove-Item`.

---

#### 📁 Opprette filer og mapper

Du kan bruke `New-Item` for å opprette både filer og mapper.

```powershell
# Opprett en ny mappe på skrivebordet
New-Item -Path "$HOME\Desktop\TestMappe" -ItemType Directory

# Opprett en ny fil inne i mappen
New-Item -Path "$HOME\Desktop\TestMappe\info.txt" -ItemType File
````

💡 **Tips:** Du kan bruke `mkdir` som en kortversjon for `New-Item -ItemType Directory`.

---

#### ✏️ Skrive og lese innhold i filer

```powershell
# Skriv tekst til en fil (overskriver alt som er der fra før)
Set-Content -Path "$HOME\Desktop\TestMappe\info.txt" -Value "Hei NTNU!"

# Legg til mer tekst på slutten av filen
Add-Content -Path "$HOME\Desktop\TestMappe\info.txt" -Value "Dette er en ny linje."

# Les innholdet i filen
Get-Content -Path "$HOME\Desktop\TestMappe\info.txt"
```

💡 `Set-Content` **erstatter** alt innhold, mens `Add-Content` **legger til** uten å slette eksisterende tekst.

---

#### 🔄 Kopiere og flytte filer

Bruk `Copy-Item` og `Move-Item` for å duplisere eller flytte filer.

```powershell
# Kopier filen til en ny plassering
Copy-Item -Path "$HOME\Desktop\TestMappe\info.txt" -Destination "$HOME\Desktop\info_kopi.txt"

# Flytt filen (eller gi nytt navn)
Move-Item -Path "$HOME\Desktop\info_kopi.txt" -Destination "$HOME\Desktop\info_omdøpt.txt"
```

💡 Du kan bruke **relative stier** hvis du står i samme mappe:

```powershell
Copy-Item .\info.txt .\backup_info.txt
```

---

#### ❌ Slette filer og mapper

Bruk `Remove-Item` for å slette filer eller mapper.

```powershell
# Slett én fil
Remove-Item "$HOME\Desktop\TestMappe\info.txt"

# Slett hele mappen og alt inni
Remove-Item "$HOME\Desktop\TestMappe" -Recurse -Force
```

⚠️ Vær forsiktig med `-Recurse -Force` — det fjerner **alt** i mappen uten bekreftelse.

---

#### 🕵️‍♀️ Kontrollere om filer finnes

Før du prøver å bruke eller slette en fil, kan du sjekke om den finnes med `Test-Path`.

```powershell
# Sjekk om en fil finnes
Test-Path "$HOME\Desktop\TestMappe\info.txt"

# Sjekk om en mappe finnes
Test-Path "$HOME\Desktop\TestMappe"
```

Hvis filen finnes, returnerer PowerShell `True`. Hvis ikke, returnerer den `False`.

💡 Dette er nyttig når du bygger skript som skal kjøre automatisk – du kan kombinere `Test-Path` med `if`-setninger:

```powershell
if (Test-Path "$HOME\Desktop\logg.txt") {
    Write-Host "Filen finnes!"
} else {
    Write-Host "Filen finnes ikke, oppretter nå..."
    New-Item "$HOME\Desktop\logg.txt" -ItemType File
}
```

---

#### 🧠 Prøv selv

1. Opprett en mappe på skrivebordet som heter `PS_Øving`.
2. Lag en tekstfil inni mappen med navnet `minfil.txt`.
3. Skriv inn tekst i filen med `Set-Content`.
4. Les innholdet i filen med `Get-Content`.
5. Kopier filen til en undermappe og gi den nytt navn.
6. Test om filen finnes, og slett den hvis den gjør det.

---

#### 🚀 Ekstra utfordring

Lag et lite script som:

1. Oppretter en mappe `BackupDemo` på skrivebordet
2. Lager en ny tekstfil med dagens dato i navnet
3. Kopierer filen til en undermappe `Arkiv`
4. Sletter filen fra hovedmappen etter kopiering

**Hint:**

```powershell
$root = "$HOME\Desktop\BackupDemo"
New-Item -Path $root -ItemType Directory -Force
New-Item -Path "$root\Arkiv" -ItemType Directory -Force

$file = "log_$(Get-Date -Format 'yyyy-MM-dd').txt"
Set-Content -Path "$root\$file" -Value "Backup kjørt kl $(Get-Date)"
Copy-Item -Path "$root\$file" -Destination "$root\Arkiv\$file"
Remove-Item "$root\$file"
```

---

💬 **Oppsummering:**

* `New-Item` → Opprett filer og mapper
* `Set-Content` / `Add-Content` → Skriv til filer
* `Copy-Item` / `Move-Item` → Kopier eller flytt
* `Remove-Item` → Slett
* `Test-Path` → Sjekk om noe finnes

Disse kommandoene gir deg full kontroll over filsystemet – og når du kombinerer dem med løkker og betingelser (fra tema 5), kan du automatisere nesten alt.

### 📁 Navigering i filsystemet

```powershell
# Vis gjeldende mappe
Get-Location

# Bytt mappe
Set-Location C:\Temp

# Gå én mappe opp
Set-Location ..

# Vis filer og mapper
Get-ChildItem

# Lag en ny mappe
New-Item -Path "C:\Temp\TestMappe" -ItemType Directory
```

💡 **Tips:** Alias som `ls` og `cd` fungerer også!

---

### 📄 Filoperasjoner

```powershell
# Opprett en ny fil
New-Item -Path "C:\Temp\TestMappe\logg.txt" -ItemType File

# Kopier fil
Copy-Item "C:\Temp\TestMappe\logg.txt" "C:\Temp\kopi.txt"

# Flytt eller gi nytt navn
Move-Item "C:\Temp\kopi.txt" "C:\Temp\nylogg.txt"

# Sjekk om fil finnes
Test-Path "C:\Temp\nylogg.txt"

# Slett fil
Remove-Item "C:\Temp\nylogg.txt"
```

---

### 🔍 Søking og filtrering

```powershell
# Finn alle .txt-filer i en mappe
Get-ChildItem -Path "C:\Temp" -Recurse | Where-Object { $_.Extension -eq ".txt" }

# Finn filer større enn 1 MB
Get-ChildItem -Path "C:\Temp" -Recurse | Where-Object { $_.Length -gt 1MB }

# Sorter etter sist endret
Get-ChildItem -Path "C:\Temp" | Sort-Object LastWriteTime -Descending | Select-Object -First 5
```

---

### 🧾 Lese og skrive innhold

```powershell
# Skriv tekst til fil
Set-Content -Path "C:\Temp\TestMappe\info.txt" -Value "Hei NTNU-studenter!"

# Les fil
Get-Content "C:\Temp\TestMappe\info.txt"

# Legg til mer tekst
Add-Content "C:\Temp\TestMappe\info.txt" -Value "Dette er en ny linje."

# Lagre output fra kommando til fil
Get-Process | Out-File "C:\Temp\processer.txt"
```

---

### 🧠 Prøv selv – Oppgaver

1. Opprett en mappe `PS_Test` på skrivebordet.
2. Lag en fil `info.txt` og skriv inn valgfri tekst.
3. Kopier filen til en undermappe og gi den nytt navn.
4. Finn alle `.txt`-filer på skrivebordet.
5. Sorter filene etter størrelse og eksporter til CSV.

---

### 🚀 Ekstra utfordring

Lag et lite PowerShell-script som:

1. Oppretter en mappe `LogDemo`
2. Oppretter en fil med dagens dato i navnet
3. Skriver “Script kjørt OK” i filen

**Hint:**

```powershell
$path = "$HOME/Desktop/LogDemo"
New-Item -Path $path -ItemType Directory -Force
$date = Get-Date -Format "yyyy-MM-dd_HH-mm"
Set-Content -Path "$path\log_$date.txt" -Value "Script kjørt OK"
```

---

### 💬 Refleksjon

* Hvordan kan du bruke PowerShell til å automatisere filarbeid?
* Hvorfor er det nyttig å bruke pipeline med filoperasjoner?

---

✅ **Neste steg (for viderekomne):**

* Lær mer om **variabler, løkker og kontrollstrukturer**
* Utforsk **moduler** og hvordan du kan administrere systemer og brukere med PowerShell
* Begynn å bygge egne **scripts** for automasjon!

---

© NTNU – Emne: DCST1001 - IT Infrastruktur, grunnleggende ferdigheter. Digital infrastruktur og cybersikkerhet
Utarbeidet som del av undervisningsopplegg i PowerShell og systemadministrasjon

