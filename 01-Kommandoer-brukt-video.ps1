# Hva er Choco: https://chocolatey.org/
# Installere Choco:
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Om en allrede har installert Choco, kan det være lurt å sjekke om det har kommet oppdatering til selve Choco også:
choco upgrade chocolatey
# Installere programvare med Choco. -y betyr at en aksepterer alle spørsmål underveis i installasjonen med Y (Yes).
choco install -y powershell-core
choco install -y git
choco install -y vscode

# Sjekke git versjon etter installasjon
git --version

# Konfigurer Git
git config --global user.name "NAVN"
git config --global user.email "EPOST@EPOST.EPOST"
git config --list


# -- PowerShell kommandoer brukt i video -- #

$filePath = "testfile.txt"
"Hello, world!" | Out-File $filePath
Get-Content $filePath

$path = "/Users/melling/git-projects/demo-repo"
$path
Get-ChildItem $path -Filter *.txt | Rename-Item -NewName { "new_" + $_.Name }
Remove-Item ./new_testfile.txt

1..10 | ForEach-Object { 
    New-Item -ItemType File -Path $path -Name "testfile$_" -Value "This is test file $_"
}

Get-ChildItem -Path $path | Where-Object { $_.Name -like "testfile*" } | ForEach-Object {
    Remove-Item $_.Fullname
}

$courseArray = @(
    "DCST1001 - Infrastruktur grunnleggende ferdigheter",
    "DCST1002 - Cybersikkerhet og teamarbeid",
    "DCST1003 - Grunnleggende programmering",
    "DCST1004 - Matematikk for informatikk",
    "HMS0002 - HMS-kurs for 1årsstudenter",
    "DCST1005 - Infrastruktur sikre grunntjenester",
    "DCST1006 - Datakommunikasjon og nettverk",
    "DCST1007 - Objektorientert programmering",
    "IDATT2002 - Databaser",
    "DCST2001 - Sammenkoblede nettverk og nettverkssikkerhet",
    "DCST2002 - Webutvikling",
    "EXPH0300 - Examen philosophicum for naturvitenskap og teknologi",
    "IDATT2202 - Operativsystemer",
    "DCST2003 - Robuste og skalerbare tjenester",
    "DCST2005 - Risikostyring",
    "IDATT1005 - Systemutvikling"
)
$path = "/Users/melling/git-projects/demo-repo"
$courseArray | ForEach-Object {
    $folder = Join-Path -Path $path -ChildPath $_
    New-Item -ItemType Directory -Path $folder
    New-Item -ItemType File -Path $folder -Name "testfile.txt" -Value "This is test file $_"
    # Remove-Item -Path $folder -Recurse -Force
}
