<# Legg til Extentions i VS Code
PowerShell må legges til som Extention i VS Code selv om det er installert på maskina (auto fullfør etc)
Rainbow CSV - Veldig praktisk når en jobber med CSV-filer i VS Code (finnes flere forskjellige extentions som gjør det samme)

Opprett git-repo
# Konfigurer Git
git config --global user.name "NAVN"
git config --global user.email "EPOST@EPOST.EPOST"
GIT Cheat Sheet: https://education.github.com/git-cheat-sheet-education.pdf

VS Code: Extentions
- PowerShell (The PowerShell extension includes PSScriptAnalyzer by default)
- Git

New Repo
Clone - HTTPS (no need for SSH)
Authenticate


This is my first PowerShell file (.ps1)
#>


[array]$firstvariabel = @('text','text2','text3')

foreach ($text in $firstvariabel) {
    $text
    "-"
}

<#
Every commit its a point on the "main"
Sporbart, hvem har gjort commit, egen ID
#>

#>


# Finne verb
Get-Verb
# Finne kommandoer og hva de gjør:
Get-Command # viser alle tilgjengelige cmdlets. Filtrer listen for raskt å finne kommandoen en trenger.
# Finne ved bruk av Get-Command
Get-Command -Verb Get # kan være set, new etc etc.
Get-Command -Noun File* # kan være hva som helst egentlig f.eks: *ip*
Get-Command -Verb Get -Noun File*

Get-Command -Noun *IP*
Get-Command -Noun *ipaddress*
Get-Command -Noun *IPConfiguration*

Get-NetIPConfiguration

Get-help New-NetIPAddress
# om en ikke har hjelp installert for modulen
Update-help

Get-help New-NetIPAddress -Examples
<#  ---------------- Example 1: Add an IPv4 address ----------------

    PS C:\>New-NetIPAddress -InterfaceIndex 12 -IPAddress 192.168.0.1 -PrefixLength 24 -DefaultGateway 192.168.0.5

Hva er Interface Index? En maskin kan så klart ha flere nettverkskort og en må derfor spesifisere hvilket nettkort en ønsker å utføre konfigurasjonen på.
#>

Get-Command -verb get -noun *netadapter*

Get-Netadapter
<#

Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
----                      --------------------                    ------- ------       ----------             ---------
Ethernet0                 Intel(R) 82574L Gigabit Network Connec…       7 Up           00-0C-29-F3-23-1F         1 Gbps

#>

<#
Sjekke OpenStack for DHCP-adresser og statiske adresser
#>


# New-NetIPAddress -InterfaceIndex 12 -IPAddress 192.168.111.xx -PrefixLength 24 -DefaultGateway 192.168.111.1
# DHCP: Set-NetIPInterface -InterfaceIndex <nr> -Dhcp Enabled


# Finne innformasjon om maskinen
Get-Command -noun *info*

Get-ComputerInfo
Get-ComputerInfo | Select-Object CsDNSHostName,TimeZone,OsLanguage,KeyboardLayout | fl


# Sjekke om VM har nødvendig Remote Desktop konfig på plass:
Test-NetConnection $ipaddress -Port 3389
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"


<# 
Local user management (user / groups)
#>
Get-Command -Module Microsoft.PowerShell.LocalAccounts

Get-LocalUser
# Hvilke brukere har vi?
# Noen fra OpenStack
Get-LocalUser | Get-Member
Get-LocalUser -name Admin
Get-LocalUser -name Admin | fl
# Spesifik info vi ønsker?

$Password = Read-Host -AsSecureString
New-LocalUser "melling" -Password $Password -FullName "Tor Ivar Melling" -Description "Info"

get-localUser -Name melling | fl

Set-LocalUser -name "melling" -PasswordNeverExpires $true

Get-LocalGroup

Add-localgroupmember -Group "administrators" -member "melling"
Get-localgroupmember -Group "administrators"

# Logg inn på VM OpenStack for å teste


# Legger ved kodesnutt som konverterer passord fra csv til secure string.

Import-csv -Path "" -Delimiter ";" -Header


$users = Import-Csv -Path ".\users.csv" -Delimiter ","
 
foreach ($user in $users) {
    Write-Host "Bruker ved navn: "$user.name" blir opprettet"
    $password = ConvertTo-SecureString $user.password -AsPlainText -Force # Denne linjen oppretter variablen $password og legger til passordinformasjonen fra .csv-fila og lager den som securestring.
 
    New-LocalUser -Name $user.name `
                -Password $password `
                -Fullname $user.fullname `
                -Description $user.description
 
}

