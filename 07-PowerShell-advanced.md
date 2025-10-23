# 💻 PowerShell videregående del – Bachelor i digital infrastruktur og cybersikkerhet (NTNU)

> 🧠 Denne guiden er laget for bruk på **virtuell Windows 11 i OpenStack-miljøet ved NTNU**.  
> Alle eksempler er testet i **PowerShell 7 (Core)**.  
> MacOS- og Linux-brukere kan følge mesteparten av øvelsene, men noen Windows-moduler krever Windows-miljø.

---

## 🧩 Tema 5: Variabler, løkker og kontrollstrukturer

### 🎯 Læringsmål
Etter denne delen skal du kunne:
- Opprette og bruke variabler i PowerShell  
- Forklare forskjellen mellom datatyper (tekst, tall, boolske verdier, arrays)  
- Bruke løkker (`foreach`, `for`, `while`) og kontrollstrukturer (`if/else`)  
- Skrive enkle automatiseringsskript med logisk flyt  

---

### 🧠 Hva er en variabel?

En **variabel** brukes til å lagre data som kan brukes senere i skriptet.  
Variabler i PowerShell starter alltid med `$`.

```powershell
# Eksempler på variabler
$name = "Ola"
$age = 25
$running = $true

Write-Output "Navn: $name, Alder: $age, Aktiv: $running"
````

💡 **PowerShell gjetter datatypen** – du trenger ikke definere den på forhånd.

---

### 📦 Arrays og lister

Arrays brukes for å lagre flere verdier.

```powershell
# Lag en liste med navn
$students = @("Ola", "Kari", "Ali", "Sara")

# Hent ut første element (index starter på 0)
$students[0]

# Skriv ut alle med en løkke
foreach ($s in $students) {
    Write-Output "Student: $s"
}
```

---

### 🔁 Løkker og kontrollstrukturer

Løkker brukes for å gjenta handlinger.
Kontrollstrukturer (`if`, `else`) brukes for å styre logikken.

```powershell
# If/Else-eksempel
$cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue

if ($cpu -gt 80) {
    Write-Host "⚠️ Høy CPU-bruk: $cpu%" -ForegroundColor Red
} else {
    Write-Host "✅ Normal CPU-bruk: $cpu%" -ForegroundColor Green
}
```

```powershell
# For-løkke
for ($i = 1; $i -le 5; $i++) {
    Write-Host "Telling: $i"
}

# While-løkke
$count = 0
while ($count -lt 3) {
    Write-Host "Runde $count"
    $count++
}
```

---

### 💡 Prøv selv

1. Lag et script som skriver ut navnet ditt fem ganger.
2. Lag en variabel `$temp` og skriv et `if/else`-utsagn som sier om det er "Varmt" (>20) eller "Kaldt".
3. Lag et array med tre prosessnavn (for eksempel “chrome”, “pwsh”, “explorer”) og skriv ut CPU-bruken for hver.

---

### 🚀 Ekstra utfordring

Lag et lite script som:

1. Henter CPU-prosenten hvert 5. sekund i 30 sekunder
2. Skriver verdiene til en `.txt`-fil
3. Gir beskjed hvis gjennomsnittet overstiger 70%

**Hint:**

```powershell
$logfile = "$HOME/Desktop/cpu_log.txt"
for ($i = 0; $i -lt 6; $i++) {
    $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    Add-Content $logfile "[$(Get-Date)] CPU: $cpu%"
    Start-Sleep -Seconds 5
}
```

---

---

## 🧩 Tema 6: PowerShell for systemadministrasjon

### 🎯 Læringsmål

Etter denne delen skal du kunne:

* Forklare hvordan PowerShell brukes i systemadministrasjon
* Hente ut og endre informasjon om brukere, tjenester og prosesser
* Installere og bruke moduler for utvidet funksjonalitet
* Utføre grunnleggende systemadministrasjon med skript

---

### ⚙️ Administrere tjenester og prosesser

```powershell
# Se alle tjenester som kjører
Get-Service | Where-Object { $_.Status -eq "Running" }

# Stopp og start en tjeneste
Stop-Service -Name Spooler
Start-Service -Name Spooler

# Hent CPU og minnebruk
Get-Process | Select-Object Name, CPU, Id, WorkingSet
```

💡 **Tips:** Kombiner med pipeline for å sortere eller logge resultater.

```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table
```

---

### 🧑‍💻 Administrasjon av brukere (lokalt)

```powershell
# Opprett en ny lokal bruker
New-LocalUser -Name "student1" -Password (ConvertTo-SecureString "Passord123!" -AsPlainText -Force)

# Legg bruker til i gruppen "Administrators"
Add-LocalGroupMember -Group "Administrators" -Member "student1"

# Vis alle brukere
Get-LocalUser
```

💡 Krever at du kjører PowerShell som administrator.

---

### 📦 Moduler og utvidelser

PowerShell kan installere moduler for å utvide funksjonaliteten, f.eks. for Azure eller Microsoft 365.

```powershell
# Finn moduler relatert til Azure
Find-Module -Name *Azure*

# Installer en modul (krever nett)
Install-Module -Name Az -Scope CurrentUser

# Importer modulen
Import-Module Az

# Se hvilke kommandoer som finnes
Get-Command -Module Az.Accounts
```

---

### 🧠 Prøv selv

1. Start og stopp en valgt tjeneste (for eksempel `Spooler` eller `wuauserv`).
2. Lag et script som henter alle tjenester med status “Stopped” og starter dem.
3. Installer en valgfri modul fra PowerShell Gallery og finn minst to kommandoer fra den.

---

### 🚀 Ekstra utfordring

Lag et lite “admin-panel” i PowerShell som lar deg:

* Velge mellom å vise prosesser, starte en tjeneste, eller se diskplass
* Bruk `Read-Host` til å lese input fra brukeren
* Bruk `if/else` for å styre valgene

**Hint:**

```powershell
Write-Host "Velg en handling:"
Write-Host "1 - Vis prosesser"
Write-Host "2 - Start en tjeneste"
Write-Host "3 - Sjekk diskplass"

$valg = Read-Host "Skriv inn nummer"

if ($valg -eq 1) {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
} elseif ($valg -eq 2) {
    $tjeneste = Read-Host "Skriv navnet på tjenesten"
    Start-Service -Name $tjeneste
} elseif ($valg -eq 3) {
    Get-PSDrive -PSProvider FileSystem
} else {
    Write-Host "Ugyldig valg"
}
```

---

---

## 🧩 Tema 7: Mini-case / praktisk utfordring

### 🎯 Læringsmål

Etter denne delen skal du kunne:

* Kombinere flere PowerShell-konsepter i ett sammenhengende script
* Bruke variabler, løkker og pipeline sammen
* Automatisere en enkel IT-administrasjonsoppgave

---

### 💼 Scenario: Systemovervåking og loggføring

Du er systemadministrator og skal lage et PowerShell-script som:

* Logger de fem mest CPU-krevende prosessene
* Lagrer resultatet til en CSV-fil
* Viser en melding hvis en prosess bruker mer enn 80% CPU

---

### 🧰 Forslag til løsning

```powershell
# Sett loggsti
$path = "$HOME/Desktop/Systemlogg"
New-Item -ItemType Directory -Path $path -Force

# Hent prosesser
$prosesser = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU, Id

# Lagre til fil
$filename = "$path\CPUlog_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').csv"
$prosesser | Export-CSV $filename -NoTypeInformation

# Sjekk for høy CPU
foreach ($p in $prosesser) {
    if ($p.CPU -gt 80) {
        Write-Host "⚠️ Prosessen $($p.Name) bruker mye CPU!" -ForegroundColor Red
    }
}
```

---

### 💡 Ekstra oppgaver

1. Legg til logging av tid og dato i filen.
2. La scriptet kjøre automatisk hvert minutt med `Start-Sleep` og en `while`-løkke.
3. Legg til en funksjon som sender en varsling til terminalen hvis en prosess stopper.

---

---

## 🧩 Tema 8: Oppsummering og refleksjon

### 🎯 Læringsmål

Etter denne delen skal du kunne:

* Forklare hvordan PowerShell brukes til automasjon og administrasjon
* Reflektere over sikkerhetsaspekter ved PowerShell-bruk
* Identifisere områder der PowerShell kan brukes videre i studiet

---

### 🧠 Oppsummering

PowerShell lar deg:

* Automatisere repetitive oppgaver
* Overvåke og feilsøke systemer
* Administrere brukere, tjenester og filer
* Jobbe mot skyplattformer (Azure, Microsoft 365, osv.)
* Skrive skript som sparer tid og øker sikkerheten

---

### 💬 Refleksjonsspørsmål

1. Hvilke oppgaver i IT-drift tror du kan automatiseres med PowerShell?
2. Hvordan kan PowerShell brukes til å forbedre sikkerhetsarbeidet i en organisasjon?
3. Hva var det mest overraskende du lærte om hvordan PowerShell håndterer data (objekter, pipeline osv.)?
4. Hvordan vil du bruke PowerShell i videre arbeid eller studier?

---

### 🧩 Avsluttende utfordring (valgfri)

Lag et komplett PowerShell-script som:

* Oppretter en mappe med dagens dato
* Logger topp 5 CPU-prosesser
* Logger diskbruk (`Get-PSDrive`)
* Skriver resultatet til én rapportfil
* Kjører hver time automatisk i en `while`-løkke

💡 **Eksempel:**

```powershell
$root = "$HOME/Desktop/SystemRapporter"
New-Item -ItemType Directory -Path $root -Force

while ($true) {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $rapport = "$root\rapport_$timestamp.txt"

    Add-Content $rapport "=== Systemrapport $timestamp ==="
    Add-Content $rapport "`nCPU-toppliste:"
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU | Out-File -Append $rapport

    Add-Content $rapport "`nDiskbruk:"
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, Used, Free | Out-File -Append $rapport

    Add-Content $rapport "`n--------------------------------`n"
    Start-Sleep -Seconds 3600
}
```

---

### 🎓 Neste steg

Du kan nå:

* Bygge videre på dette for å administrere **Azure**, **Active Directory** eller **Microsoft 365**. (Som vi skal gjøre i neste semester i DCST1005 - Infrastruktur, sikre grunntjenester)
* Utforske **PowerShell Remoting** for å kjøre kommandoer på flere maskiner samtidig.
* Bruke PowerShell i **DevOps / CI-CD**-sammenheng.

---

© NTNU – Emne: DCST1001 - IT Infrastruktur, grunnleggende ferdigheter. Digital infrastruktur og cybersikkerhet
Utarbeidet som del av undervisningsopplegg i PowerShell og systemadministrasjon