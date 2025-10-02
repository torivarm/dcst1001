# Opprette en virtuell maskin i Azure med tilhørende nettverk

I denne guiden lærer du å opprette en virtuell maskin (VM) i Azure.  
I stedet for å la Azure opprette alt automatisk, bygger vi infrastrukturen steg for steg: først nettverket, deretter VM-en.  

Dette gir deg bedre forståelse for hvordan Azure er strukturert, og hvordan ressursene henger sammen.

---

## 1. Logg inn i Azure-portalen
1. Gå til [https://portal.azure.com](https://portal.azure.com).  
2. Logg inn med din studentkonto
![alt text](img/azureportal.png)

---

## 2. Opprett en ressursgruppe
En ressursgruppe samler alle ressursene dine.  
![alt text](img/resourcegroup.png)
1. Klikk på **Resource groups**  
2. Trykk **Create**.
   1. ![alt text](img/createRG.png)
3. Fyll inn: MERK! Noen av bildene viser Sweden Central, men Azure for students subscription har fått en del nye begresninger om hvor en kan opprette VM-er. Velg derfor **Switzerland North**  
   - **Subscription**: `Azure for students` (om ikke Azure for students Subscription vises, forsøk å oppdatere MAC: command + r, Windows: CTRL + R)
   - **Resource group name**: Skriv inn et passende navn `rg-myfirstIaaS-test` 
   - **Region**: `Switzerland North` (MERK!! IKKE Sweden Central som bildet viser)  
4. Trykk **Review + Create**, og deretter **Create**.
![alt text](img/rgSweden.png)

---

## 3. Opprett et virtuelt nettverk (VNet)
Et VNet er et privat nettverk i Azure hvor du plasserer ressursene dine.  

1. Søk etter **Virtual Network**.
   1. ![alt text](img/vnet.png)
2. Velg **Create**.
   1. ![alt text](img/createVNET.png)
3. Fyll inn:  
   - **Resource group**: Om den ikke er automatisk valgt, velg Resource Group som nettopp ble opprettet
   - **Name**: `vnet-myfirstVNET-test`  
   - **Region**: Samme som ressursgruppen
![alt text](img/vnetSwedenBasics.png)
4. Ikke velg noe under security, koster veldig mye!! - Gå til: **IP addresses**, konfigurer et **subnet**:
![alt text](img/editSubnet.png)
   - **Subnet name**: `snet-myfirstSubnet-test`  
   - **Subnet address range**: behold standardforslaget, f.eks. `10.0.0.0/24`.
![alt text](img/saveSubnet.png)
5. Trykk **Review + Create**, og deretter **Create**.
![alt text](img/ReviewCreateVNET.png)
-
![alt text](img/validationPasedSewdenVNET.png)
6. Etter en stund vil en se at ressursen er ferdig opprettet:
![alt text](img/vnet-done.png)
---

## 4. Opprett en Network Security Group (NSG)
En NSG fungerer som en brannmur. Den bestemmer hvilken trafikk som slipper inn og ut av subnettet.  

1. Søk etter **Network Security Group**.
![alt text](img/searchNSG.png)
2. Velg **Create**.
![alt text](img/createNSG.png)  
3. Fyll inn:  
   - **Resource group**: `rg-myfirstIaaS-test` - Samme som opprettet tidligere
   - **Name**: `nsg-myfirstNSG-test`  
   - **Region**: samme som VNet
4. Trykk **Review + Create**, og deretter **Create**.  
![alt text](img/reviewAndCreateNSG.png)

Når NSG-en er opprettet:
- Gå inn på `nsg-myfirstNSG-test`.
- ![alt text](img/NSG-EditNSG.png)
- Velg **Inbound security rules**.
- ![alt text](img/NSGInbound.png)  
- Legg til en regel for å åpne riktig port: Skriv inn et ønsket navn: F.eks. RDP og SSH for hver av reglene.
  - **Windows VM**: RDP (TCP/3389)
    - ![alt text](img/NSGRDP.png) 
  - **Linux VM**: SSH (TCP/22) 
    - ![alt text](img/NSGSSH.png)
- Når en er ferdig vil en se følgende regler:
  - ![alt text](img/NSGInboundWithSSHRDP.png)
---

## 5. Knytt NSG til subnettet
1. Gå til opprettet **VNET** og deretter → **Subnets**.
![alt text](img/SNET-findSubnet.png)
1. Velg `snet-myfirstSubnet-test` (eller det navnet du har valgt på ditt subnet)
2. Knytt til **nsg-myfirstNSG-test**.  
![alt text](img/nsg-attach-subnet.png)
3. Lagre endringene.

Nå har du et nettverk klart med sikkerhetsregler.

---

## 6. Opprett en virtuell maskin
Nå kan du lage selve VM-en og koble den til nettverket du har satt opp.

1. Søk etter **Virtual Machine**.
   1. ![alt text](img/SearchVM.png)
2. Velg **Create** → **Virtual Machine**
   1. ![alt text](img/CreateVM.png)  
3. Under **Basics**: MERK! Her er det mange valg.. Det er ikke meningen vi skal forstå alt sammen nå, det blir mer Azure i senere semester.
   ![alt text](img/VM01.png)
   - **Resource group**: `rg-myfirstIaaS-sn-test`  
   - **Virtual machine name**: `vm-myfirstVM-sn-test`
   - **Region**: samme som ressursgruppen (Switzerland North)
   - **Image**: velg operativsystem (f.eks. *Ubuntu 24.04 LTS*)  
- Velg å bytte SIZE på VM-en (SKU - Stock keeping unit)
- ![alt text](img/SizeVM.png)
- Velg deretter det samme som bildet viser.
- ![alt text](img/VMsizeB2ats.png)
   - **Authentication type**: For å gjøre det enklet, velg passord. Skriv inn et ønsket brukernavn og følg veiledningen på passordlengde og kompleksitet.
   - ![alt text](img/VMpassword.png)
 - Velg å tillate port 22 inn til maskinen. MERK! Bare for testing, ikke god produksjonspraksis.
 - ![alt text](img/VMport22.png)
4. Trykk **Next: Networking** i toppen.

---

## 7. Koble VM til nettverket
1. Under **Virtual network**, velg det virtuelle nettverkt som du akkurat har opprettet
2. Under **Subnet**, velg subnet opprettet sammen med det virtuelle nettverket.
3. MERK: Public IP blir opprettet sammen med VM (New)
   ![alt text](img/VMNetwork.png)
4. Under **NIC network security group**, velg **Advanced** og velg tidligere opprettet NSG
![alt text](img/VM-NSG-Create.png)
5. Trykk **Review + Create**, og deretter **Create**.
![alt text](img/CreateVM-ValidationPassed.png)
6. VM-en er ferdig opprettet når en ser følgende visning i nettleseren:
   - ![alt text](img/VM-DONE.png)
---

## 8. Koble til den virtuelle maskinen
Når opprettelsen er ferdig, kobler du deg til VM-en:

- **Linux**:  
  1. Finn frem til VM-en sin offentlige adresse ved å gå til Virtual Machines. En kan også klikke seg inn på VM-en om en ønsker enda mer informasjon om VM-en.
     1. ![alt text](img/VM-publicIP.png)  
  2. For å koble seg til maskinen kan en nå SSH inn til maskinen (terminal for macOS (command + spacebar -> skriv inn terminal) eller PowerShell for Windows (Trykk windowstast og skriv inn PowerShell)):  
     ```bash
     ssh <brukernavnetvedopprettelse av VM>@<offentlig-ip>
     ```
![alt text](img/SSH-VM-COmpleted.png)
- Nå kan jeg skrive kommandoer direkte til VM-en som befinner seg i Microsoft Azure sitt datasenter.
![alt text](img/VM-pormpt.png)
- **Windows**:  
  1. Klikk på **Connect** → **RDP**.  
  2. Last ned `.rdp`-filen og logg inn med brukernavn og passord.

---

## 9. Rydd opp (Viktig!)
Når du er ferdig med øvelsen, slett ressursgruppen for å unngå kostnader:  

1. Gå til **Resource groups**.  
2. Klikk **Delete resource group** i toppen og skriv inn navnet på Resource Groupen for å bekrefte..  
![alt text](img/DeleteRG.png)
- Bekreft ved å skrive inn navn og huk av for å ta med alle ressursene.
- ![alt text](img/BekreftSletting.png)

---

## Oppsummering
I denne øvelsen har du:
- Opprettet en ressursgruppe.  
- Bygget et virtuelt nettverk med subnet.  
- Konfigurert en Network Security Group og koblet den til subnettet.  
- Opprettet en VM og koblet den til det eksisterende nettverket.  
- Lært hvordan du kobler deg til VM-en og hvordan du rydder opp ressursene etterpå.  

---
