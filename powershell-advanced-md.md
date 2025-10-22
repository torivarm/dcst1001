# Avansert PowerShell Guide for Viderekomne

PowerShell er et kraftig verktøy for automatisering og systemadministrasjon. Denne guiden vil ta deg dypere inn i noen av de mer avanserte aspektene ved PowerShell, med fokus på å finne og utforske kommandoer, bruke Get-Member, og arbeide med Expand-Property.

## Finne og Utforske Kommandoer

I PowerShell finnes det flere måter å oppdage og utforske kommandoer på. Her er noen avanserte teknikker:

### Bruk av Get-Command

Get-Command er en kraftig cmdlet for å finne kommandoer. Her er noen avanserte bruksområder:

```powershell
# Finn alle kommandoer som inneholder ordet "process"
Get-Command -Name *process*
```

```powershell
# Finn alle cmdlets i modulen "Microsoft.PowerShell.Management"
Get-Command -Module Microsoft.PowerShell.Management
```

```powershell
# Finn alle kommandoer som tar imot et bestemt parameter
Get-Command -ParameterName ComputerName
```

### Bruk av Where-Object for Filtrering

Du kan kombinere Get-Command med Where-Object for mer presis filtrering:

```powershell
# Finn alle kommandoer som har både "Get" og "IP" i navnet
Get-Command | Where-Object { $_.Name -like "*Get*" -and $_.Name -like "*IP*" }
```

### Utforske Kommandoparametre

For å få detaljert informasjon om en kommandos parametre, kan du bruke Get-Help med -Full eller -Parameter flagget:

```powershell
# Vis full hjelp for Get-Process
Get-Help Get-Process -Full
```

```powershell
# Vis kun parameterinformasjon for Get-Process
Get-Help Get-Process -Parameter *
```

## Bruk av Get-Member

Get-Member er en nyttig cmdlet for å utforske egenskapene og metodene til objekter i PowerShell. Her er noen avanserte brukseksempler:

### Utforske Objektegenskaper

```powershell
# Vis alle egenskaper og metoder for prosessobjekter
Get-Process | Get-Member
```

```powershell
# Vis kun egenskaper for prosessobjekter
Get-Process | Get-Member -MemberType Property
```

### Finne Skjulte Egenskaper

Noen objekter har skjulte eller "forlatte" egenskaper som ikke vises som standard:

```powershell
# Vis alle egenskaper, inkludert skjulte
Get-Process | Get-Member -Force
```

### Utforske Statiske Medlemmer

For å se statiske medlemmer av en klasse, kan du bruke -Static flagget:

```powershell
# Vis statiske medlemmer av [DateTime] klassen
[DateTime] | Get-Member -Static
```

## Arbeide med Select-Object og Expand-Property

Select-Object og dens Expand-Property funksjonalitet er kraftige verktøy for å manipulere objektutdata.

### Grunnleggende Bruk av Select-Object

```powershell
# Velg spesifikke egenskaper fra prosessobjekter
Get-Process | Select-Object Name, Id, CPU
```

### Bruk av Expand-Property

Expand-Property er nyttig når du jobber med nestede objekter:

```powershell
# Ekspander Thread-egenskapen for hvert prosessobjekt
Get-Process | Select-Object Name, @{Name='Threads'; Expression={$_.Threads | Select-Object -ExpandProperty Id}}
```

### Beregne Nye Egenskaper

Du kan bruke Select-Object til å beregne nye egenskaper:

```powershell
# Beregn minnebruk i MB
Get-Process | Select-Object Name, @{Name='MemoryMB'; Expression={$_.WorkingSet / 1MB -as [int]}}
```

## Avansert Pipelining og Objektmanipulering

PowerShell's pipelining-funksjonalitet er kraftig, spesielt når den kombineres med objektmanipulering:

### Bruk av ForEach-Object for Kompleks Logikk

```powershell
Get-ChildItem -Recurse |
    Where-Object { $_.Extension -eq '.log' } |
    ForEach-Object {
        $content = Get-Content $_.FullName
        $errorCount = ($content | Select-String -Pattern 'ERROR' -AllMatches).Matches.Count
        [PSCustomObject]@{
            File = $_.Name
            ErrorCount = $errorCount
        }
    } |
    Sort-Object ErrorCount -Descending
```

Dette skriptet søker rekursivt etter .log-filer, teller antall ganger 'ERROR' forekommer i hver fil, og returnerer en sortert liste over filer og deres feiltellinger.

### Bruk av Group-Object for Dataanalyse

```powershell
Get-Process |
    Group-Object -Property Company |
    Sort-Object -Property Count -Descending |
    Select-Object -First 10 |
    Format-Table -Property Name, Count -AutoSize
```

Dette kommandosettet grupperer alle kjørende prosesser etter selskapet som laget dem, sorterer gruppene etter antall prosesser, og viser de topp 10 selskapene.

