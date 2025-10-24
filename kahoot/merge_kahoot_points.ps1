param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = "merged_results.csv",
    
    [Parameter(Mandatory=$false)]
    [switch]$ShowConsole
)

# Sjekk om input-filen finnes
if (-not (Test-Path $InputFile)) {
    Write-Error "Filen '$InputFile' ble ikke funnet!"
    exit 1
}

Write-Host "Leser data fra: $InputFile" -ForegroundColor Cyan

# Les CSV-filen med semikolon som separator
try {
    $data = Import-Csv -Path $InputFile -Delimiter ';' -Encoding UTF8
} catch {
    Write-Error "Kunne ikke lese CSV-filen. Sjekk at filen har riktig format."
    exit 1
}

# Grupper og summer poeng for like spillernavn
$mergedResults = @{}

foreach ($row in $data) {
    # Normaliser spillernavn: fjern ekstra mellomrom og konverter til lowercase
    $normalizedName = $row.Player.Trim().ToLower()
    
    # Finn det originale navnet (første forekomst) for visning
    if (-not $mergedResults.ContainsKey($normalizedName)) {
        $mergedResults[$normalizedName] = @{
            DisplayName = $row.Player.Trim()
            TotalPoints = 0
            GameCount = 0
            PointsList = @()
        }
    }
    
    # Legg til poengene
    $points = [int]$row.Points
    $mergedResults[$normalizedName].TotalPoints += $points
    $mergedResults[$normalizedName].GameCount++
    $mergedResults[$normalizedName].PointsList += $points
}

# Konverter til array og sorter etter total poengsum (høyest først)
$sortedResults = $mergedResults.GetEnumerator() | ForEach-Object {
    [PSCustomObject]@{
        Player = $_.Value.DisplayName
        TotalPoints = $_.Value.TotalPoints
        GamesPlayed = $_.Value.GameCount
        AveragePoints = [math]::Round($_.Value.TotalPoints / $_.Value.GameCount, 0)
        PointsPerGame = ($_.Value.PointsList -join ', ')
    }
} | Sort-Object -Property TotalPoints -Descending

# Vis resultat i konsollen hvis ønsket
if ($ShowConsole) {
    Write-Host "`nSammenslåtte resultater:" -ForegroundColor Green
    Write-Host ("=" * 80) -ForegroundColor Gray
    
    $sortedResults | ForEach-Object {
        Write-Host ("{0,-20} Total: {1,6}  Snitt: {2,5}  Antall spill: {3}" -f 
            $_.Player, 
            $_.TotalPoints, 
            $_.AveragePoints,
            $_.GamesPlayed) -ForegroundColor Yellow
    }
    
    Write-Host ("=" * 80) -ForegroundColor Gray
    Write-Host "Totalt antall unike spillere: $($sortedResults.Count)" -ForegroundColor Cyan
}

# Lagre til ny CSV-fil
$exportData = $sortedResults | Select-Object Player, TotalPoints, GamesPlayed, AveragePoints

try {
    $exportData | Export-Csv -Path $OutputFile -Delimiter ';' -NoTypeInformation -Encoding UTF8
    Write-Host "`nResultater lagret til: $OutputFile" -ForegroundColor Green
    
    # Vis topp 10
    Write-Host "`nTopp 10 spillere:" -ForegroundColor Cyan
    $exportData | Select-Object -First 10 | Format-Table -AutoSize
    
} catch {
    Write-Error "Kunne ikke lagre til fil: $OutputFile"
    exit 1
}

# Vis statistikk
Write-Host "`nStatistikk:" -ForegroundColor Cyan
Write-Host "- Totalt antall unike spillere: $($sortedResults.Count)"
Write-Host "- Høyeste poengsum: $($sortedResults[0].TotalPoints) ($($sortedResults[0].Player))"
Write-Host "- Gjennomsnittlig totalpoeng: $([math]::Round(($sortedResults.TotalPoints | Measure-Object -Sum).Sum / $sortedResults.Count, 0))"
Write-Host "- Totalt antall spill registrert: $(($sortedResults.GamesPlayed | Measure-Object -Sum).Sum)"
