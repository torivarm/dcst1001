# Introduksjon til PowerShell og Cmdlets

## Hva er PowerShell?

PowerShell er et kraftig skript- og automatiseringsverktøy utviklet av Microsoft. Det ble først introdusert i 2006 og har siden blitt en integrert del av Windows-operativsystemet. PowerShell er bygget på .NET Framework og tilbyr en kommandolinjegrensesnitt (CLI) og et skriptspråk.

Nøkkelegenskaper ved PowerShell inkluderer:

1. **Objektorientering**: I motsetning til tradisjonelle shell-skript som opererer med tekst, jobber PowerShell med .NET-objekter.
2. **Konsistent syntaks**: PowerShell bruker en "verb-substantiv" struktur for kommandoer, som gjør det lettere å lære og huske.
3. **Utvidbarhet**: Du kan enkelt legge til nye funksjoner gjennom moduler og snap-ins.
4. **Integrert skriptspråk**: PowerShell har et robust skriptspråk for mer komplekse oppgaver.
5. **Plattformuavhengig**: Fra PowerShell Core 6.0 er det tilgjengelig på Windows, macOS og Linux.

## Grunnleggende PowerShell-konsepter

### 1. Cmdlets

Cmdlets (uttales "command-lets") er de grunnleggende byggeklossene i PowerShell. De er spesialiserte .NET-klasser implementert som kommandoer. Cmdlets følger en "verb-substantiv" navnekonvensjon, for eksempel:

- `Get-Process`
- `Stop-Service`
- `New-Item`

### 2. Pipelining

PowerShell støtter pipelining, som lar deg sende utdata fra én kommando som inndata til en annen. Dette gjøres ved å bruke pipe-symbolet `|`. For eksempel:

```powershell
Get-Process | Sort-Object CPU -Descending
```

### 3. Aliaser

For å gjøre det lettere å bruke, har PowerShell aliaser for mange vanlige cmdlets. For eksempel:

- `ls` er et alias for `Get-ChildItem`
- `cd` er et alias for `Set-Location`
- `dir` er også et alias for `Get-ChildItem`

### 4. Variabler

Variabler i PowerShell starter med `$`-tegnet. For eksempel:

```powershell
$navn = "Ola Nordmann"
$alder = 30
```

### 5. Strenger

PowerShell støtter både enkle og doble anførselstegn for strenger. Doble anførselstegn tillater variabelekspansjon:

```powershell
$navn = "Ola"
Write-Host "Hei, $navn!"  # Skriver ut: Hei, Ola!
Write-Host 'Hei, $navn!'  # Skriver ut: Hei, $navn!
```

## Grunnleggende bruk av Cmdlets

La oss se på noen vanlige cmdlets og hvordan de brukes:

### 1. Get-Command

Denne cmdlet-en hjelper deg med å finne andre tilgjengelige cmdlets:

```powershell
Get-Command                 # Lister alle tilgjengelige cmdlets
Get-Command -Verb Get       # Lister alle cmdlets som starter med verbet "Get"
Get-Command -Noun Process   # Lister alle cmdlets relatert til prosesser
```

### 2. Get-Help

Denne cmdlet-en gir deg detaljert informasjon om hvordan du bruker andre cmdlets:

```powershell
Get-Help Get-Process        # Viser hjelp for Get-Process cmdlet
Get-Help Get-Process -Full  # Viser full hjelpedokumentasjon
Get-Help Get-Process -Examples  # Viser eksempler på bruk
```

### 3. Get-Process

Denne cmdlet-en henter informasjon om kjørende prosesser:

```powershell
Get-Process                 # Lister alle kjørende prosesser
Get-Process -Name chrome    # Henter informasjon om Chrome-prosesser
Get-Process | Where-Object {$_.CPU -gt 10}  # Finner prosesser som bruker mer enn 10% CPU
```

### 4. Get-Service

Denne cmdlet-en henter informasjon om tjenester (KUN WINDOWS):

```powershell
Get-Service                 # Lister alle tjenester
Get-Service -Name BITS      # Henter informasjon om BITS-tjenesten
Get-Service | Where-Object {$_.Status -eq "Running"}  # Lister kjørende tjenester
```

### 5. New-Item

Denne cmdlet-en brukes til å opprette nye filer eller mapper:

```powershell
New-Item -Path C:\Temp\NyMappe -ItemType Directory  # Oppretter en ny mappe
New-Item -Path C:\Temp\NyFil.txt -ItemType File     # Oppretter en ny fil
```

### 6. Set-Content og Get-Content

Disse cmdlet-ene brukes for å skrive til og lese fra filer:

```powershell
Set-Content -Path C:\Temp\Test.txt -Value "Dette er en test"
Get-Content -Path C:\Temp\Test.txt
```

### 7. Remove-Item

Denne cmdlet-en brukes for å slette filer eller mapper:

```powershell
Remove-Item -Path C:\Temp\NyFil.txt
Remove-Item -Path C:\Temp\NyMappe -Recurse  # Sletter mappen og alt innhold
```

## Avanserte Konsepter

### 1. Funksjoner

Du kan definere dine egne funksjoner i PowerShell:

```powershell
function Hils-Person {
    param($navn)
    Write-Host "Hei, $navn!"
}

Hils-Person -navn "Kari"
```

### 2. Løkker

PowerShell støtter flere typer løkker:

```powershell
# ForEach-Object løkke
1..5 | ForEach-Object { Write-Host $_ }

# For løkke
for ($i = 1; $i -le 5; $i++) {
    Write-Host $i
}

# While løkke
$i = 1
while ($i -le 5) {
    Write-Host $i
    $i++
}
```

### 3. Betingelser

If-setninger i PowerShell:

```powershell
$alder = 20
if ($alder -ge 18) {
    Write-Host "Du er myndig"
} else {
    Write-Host "Du er ikke myndig ennå"
}
```

### 4. Feilhåndtering

PowerShell har innebygd støtte for feilhåndtering:

```powershell
try {
    # Kode som kan kaste en feil
    $resultat = 10 / 0
} catch {
    Write-Host "En feil oppstod: $_"
} finally {
    Write-Host "Dette kjører uansett"
}
```

## Beste Praksis

1. **Bruk Verb-Substantiv navnekonvensjon**: Følg PowerShell's navnekonvensjon når du lager egne funksjoner eller skript.
2. **Bruk kommentarer**: Dokumenter koden din for å gjøre den mer forståelig.
3. **Bruk pipelining**: Utnytt PowerShell's pipelining-funksjonalitet for mer effektiv kode.
4. **Lær aliaser, men bruk fulle cmdlet-navn i skript**: Aliaser er nyttige i interaktiv bruk, men fulle cmdlet-navn gjør skript mer lesbare.
5. **Bruk Get-Help**: Ikke vær redd for å bruke Get-Help for å lære mer om cmdlets og deres parametere.

## Konklusjon

PowerShell er et kraftig verktøy som kan drastisk forbedre din evne til å administrere Windows-systemer og automatisere oppgaver. Med sin objektorienterte tilnærming og konsistente syntaks, tilbyr PowerShell en robust plattform for både nybegynnere og erfarne administratorer. Ved å mestre grunnleggende cmdlets og konsepter som presentert her, vil du være godt på vei til å bli en effektiv PowerShell-bruker.