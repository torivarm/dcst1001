# Kahoot Poeng-sammeslåing

Dette er PowerShell-script for å slå sammen poeng fra flere Kahoot-spill for spillere med like navn.

## Problem som løses
Når du har kjørt flere Kahoot-spill og eksportert resultatene, kan samme spiller ha variasjoner i navnet sitt:
- Store/små bokstaver (f.eks. "Adele" vs "adele")
- Ekstra mellomrom (f.eks. "adele " vs "adele")

Scriptet håndterer disse variasjonene og slår sammen poengene automatisk.

## Filer

### 1. `merge_kahoot_simple.ps1` (Enkel versjon)
Den enkle versjonen som bare slår sammen poeng og lager en ny CSV-fil.

**Bruk:**
```powershell
.\merge_kahoot_simple.ps1 -InputFile "kahoot_results.csv" -OutputFile "merged_results.csv"
```

### 2. `merge_kahoot_points.ps1` (Avansert versjon)
Full versjon med ekstra funksjoner:
- Viser antall spill per spiller
- Beregner gjennomsnittspoeng
- Viser detaljert statistikk
- Kan vise alle poeng per spill

**Bruk:**
```powershell
# Standard bruk
.\merge_kahoot_points.ps1 -InputFile "kahoot_results.csv"

# Med egendefinert output-fil
.\merge_kahoot_points.ps1 -InputFile "kahoot_results.csv" -OutputFile "final_results.csv"

# Vis også detaljert info i konsollen
.\merge_kahoot_points.ps1 -InputFile "kahoot_results.csv" -ShowConsole
```

## CSV-format
Input-filen må være i følgende format med semikolon som separator:
```
Player;Points
Adele;7757
adrian;4511
```

## Output
Scriptet genererer en ny CSV-fil med sammenslåtte resultater, sortert etter totalpoeng (høyest først):
```
Player;TotalPoints;GamesPlayed;AveragePoints
albert;47134;6;7856
Adrian;45864;6;7644
```

## Eksempel på kjøring

```powershell
PS> .\merge_kahoot_points.ps1 -InputFile kahoot_results.csv -ShowConsole

Leser data fra: kahoot_results.csv

Sammenslåtte resultater:
================================================================================
albert               Total:  47134  Snitt:  7856  Antall spill: 6
Adrian               Total:  45864  Snitt:  7644  Antall spill: 6
Aleks                Total:  41695  Snitt:  6949  Antall spill: 6
================================================================================
Totalt antall unike spillere: 11

Resultater lagret til: merged_results.csv

Topp 10 spillere:
Player      TotalPoints GamesPlayed AveragePoints
------      ----------- ----------- -------------
albert            47134           6          7856
Adrian            45864           6          7644
Aleks             41695           6          6949
...

Statistikk:
- Totalt antall unike spillere: 11
- Høyeste poengsum: 47134 (albert)
- Gjennomsnittlig totalpoeng: 26704
- Totalt antall spill registrert: 50
```

## Tips
- Sjekk at CSV-filen bruker UTF-8 encoding hvis du har norske tegn
- Scriptet ignorerer forskjeller i store/små bokstaver
- Ekstra mellomrom før/etter navn fjernes automatisk
- Den første forekomsten av et navn brukes som visningsnavn i output
