# Enkel versjon - Slå sammen Kahoot-poeng
param(
    [string]$InputFile = "kahoot_results.csv",
    [string]$OutputFile = "merged_results.csv"
)

# Les CSV-filen
$data = Import-Csv -Path $InputFile -Delimiter ';'

# Grupper og summer poeng
$results = @{}

foreach ($row in $data) {
    # Normaliser navn (fjern mellomrom og konverter til lowercase)
    $key = $row.Player.Trim().ToLower()
    
    if (-not $results.ContainsKey($key)) {
        $results[$key] = @{
            Name = $row.Player.Trim()  # Behold original formatering
            Points = 0
        }
    }
    
    $results[$key].Points += [int]$row.Points
}

# Konverter til sortert liste
$merged = $results.Values | 
    Select-Object @{Name='Player';Expression={$_.Name}}, @{Name='Points';Expression={$_.Points}} |
    Sort-Object Points -Descending

# Vis resultat
Write-Host "`nSammenslåtte resultater:" -ForegroundColor Green
$merged | Format-Table -AutoSize

# Lagre til fil
$merged | Export-Csv -Path $OutputFile -Delimiter ';' -NoTypeInformation

Write-Host "`nResultater lagret til: $OutputFile" -ForegroundColor Yellow
