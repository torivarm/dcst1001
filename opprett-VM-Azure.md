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
3. Fyll inn:  
   - **Subscription**: `Azure for students` (om ikke Azure for students Subscription vises, forsøk å oppdatere MAC: command + r, Windows: CTRL + R)
   - **Resource group name**: Skriv inn et passende navn `rg-myfirstIaaS-test` 
   - **Region**: `Sweden Central` (eller nærmeste datasenter)  
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

---

## 5. Knytt NSG til subnettet
1. Gå til **vnet-demo** → **Subnets**.  
2. Velg `subnet-demo`.  
3. Knytt til **nsg-demo**.  
4. Lagre endringene.

Nå har du et nettverk klart med sikkerhetsregler.

---

## 6. Opprett en virtuell maskin
Nå kan du lage selve VM-en og koble den til nettverket du har satt opp.

1. Klikk på **Create a resource** → Søk etter **Virtual Machine**.  
2. Velg **Create**.  
3. Under **Basics**:  
   - **Resource group**: `rg-demo`  
   - **Virtual machine name**: `vm-demo01`  
   - **Region**: samme som ressursgruppen  
   - **Image**: velg operativsystem (f.eks. *Ubuntu 22.04 LTS* eller *Windows Server 2022*)  
   - **Size**: velg en liten maskin, f.eks. `Standard_B1s`  
   - **Authentication type**:  
     - SSH-nøkkel for Linux  
     - Brukernavn/passord for Windows  
   - Husk å velge et brukernavn som ikke er `admin` eller `root`.  
4. Trykk **Next: Networking**.  

---

## 7. Koble VM til nettverket
1. Under **Virtual network**, velg `vnet-demo`.  
2. Under **Subnet**, velg `subnet-demo`.  
3. Under **NIC network security group**, velg **None** (fordi vi bruker NSG knyttet til subnettet).  
4. Trykk **Review + Create**, og deretter **Create**.

---

## 8. Koble til den virtuelle maskinen
Når opprettelsen er ferdig, kobler du deg til VM-en:

- **Linux**:  
  1. Klikk på **Connect** → **SSH**.  
  2. Kopier kommandoen og lim den inn i terminalen.  
  3. Eksempel:  
     ```bash
     ssh brukernavn@offentlig-ip
     ```

- **Windows**:  
  1. Klikk på **Connect** → **RDP**.  
  2. Last ned `.rdp`-filen og logg inn med brukernavn og passord.

---

## 9. Rydd opp (Viktig!)
Når du er ferdig med øvelsen, slett ressursgruppen for å unngå kostnader:  

1. Gå til **Resource groups**.  
2. Velg `rg-demo`.  
3. Klikk **Delete resource group**.  

---

## Oppsummering
I denne øvelsen har du:
- Opprettet en ressursgruppe.  
- Bygget et virtuelt nettverk med subnet.  
- Konfigurert en Network Security Group og koblet den til subnettet.  
- Opprettet en VM og koblet den til det eksisterende nettverket.  
- Lært hvordan du kobler deg til VM-en og hvordan du rydder opp ressursene etterpå.  

---
