# TradeFlow — Sådan tester du appen fuldt ud

Test sker i **tre lag**. Du skal igennem alle tre før public launch.

---

## LAG 1: Test prototypen NU (det du har i preview-panelet)

Det her er **klikbar test af UI/UX**. Du klikker dig igennem og ser om alt giver mening, ser pænt ud, og om interaktioner fungerer.

### Sådan gør du
1. Sørg for at preview-panelet viser `index.html` (TradeFlow-appen i telefonrammen)
2. Brug listen herunder som tjekliste — klik på alt og skriv ✅/❌ ved hver linje
3. Tag screenshots af det der ikke virker (Cmd/Ctrl+Shift+S)

### Tjekliste — 47 ting at klikke på

**Oversigt-skærm**
- [ ] App åbner uden fejl
- [ ] Hilsen passer til tidspunkt (morgen/dag/aften)
- [ ] Notifikations-klokken har rød prik
- [ ] Profil-bobblen viser "MS"
- [ ] Hero-kort viser "Nyt badeværelse"
- [ ] Klik "Åbn sag" → reagerer (skal lede til sag-detalje i fuld version)
- [ ] Klik pin-ikonet → går til Tegning
- [ ] 3 stat-bokse viser tal: 3 / 3 / 42k
- [ ] Klik "Ny sag" → reagerer
- [ ] Klik "Tag foto" → går til Foto-skærm
- [ ] Klik "Ny faktura" → går til Faktura-skærm
- [ ] Klik "Se alle →" → går til Sager
- [ ] Klik på Hansens Vej 12 i listen → reagerer

**Sager-skærm**
- [ ] Søgefelt er synligt
- [ ] Filter-chips: Alle / I gang / Planlagt / Klar
- [ ] Klik på hver filter-chip → den valgte highlightes
- [ ] Tre sag-kort vises med korrekt info
- [ ] Progress-bar på sag #2034 viser 66%
- [ ] Klik "Send faktura nu →" på sag #2028 → går til Faktura
- [ ] Klik "+" → reagerer (ny sag dialog)

**Tegning-skærm**
- [ ] Topbar viser "Hansens Vej 12 · IFC + 2 PDF"
- [ ] Klik download-ikon → åbner PDF-rapport modal
- [ ] Luk PDF-modal med X
- [ ] Klik upload-ikon → reagerer (filvælger)
- [ ] Klik "3D (IFC / Revit)" tab → skifter til 3D-view
- [ ] Klik "2D plan" tab → skifter tilbage
- [ ] GPS-banner viser "Badeværelse · ved vask"
- [ ] Klik "Centrér" → reagerer
- [ ] Plantegning rendererr med rum-navne (Badeværelse, Køkken, Stue, Soveværelse, Bad 2)
- [ ] Lime/orange pulserende prik viser GPS-position
- [ ] 4 pins synlige (3 orange, 1 amber)
- [ ] Klik "Forespørgsel"-knap → åbner pin-sheet
- [ ] Klik "Nyt tilsyn"-knap → åbner pin-sheet med anden tekst
- [ ] Filer-liste viser .ifc, .rvt, .pdf
- [ ] Klik "Eksportér tilsynsrapport (PDF)" → åbner PDF-modal

**3D-view (klik 3D-tab)**
- [ ] IFC-filinfo vises øverst med "Live"-badge
- [ ] Discipline-chips (Alle / Arkitektur / VVS / El)
- [ ] Isometrisk bygning rendererr med 2 etager
- [ ] Pins synlige på 3D-modellen
- [ ] GPS-halo synlig

**Faktura-skærm**
- [ ] "Kladde"-badge synligt i hjørne
- [ ] Kunde-kort viser Familien Hansen
- [ ] 3 linjer: Arbejde / Materialer / Kørsel
- [ ] Matematik korrekt: 14.400 + 3.220 + 182 = 17.802
- [ ] Moms 25% = 4.450,50 (rigtigt)
- [ ] I alt = 22.252,50 kr (rigtigt)
- [ ] Klik "+ Tilføj linje" → reagerer
- [ ] Klik "Gem kladde" → reagerer
- [ ] Klik "Send til kunde" → reagerer

**Foto-skærm (kun via Tag foto-knap)**
- [ ] Galleri viser 8 mock-fotos + 1 tom plads
- [ ] Klik kamera-knap → reagerer

**Pin-sheet (modal)**
- [ ] Glider op fra bund
- [ ] Tre foto-thumbnails synlige
- [ ] Note med tekst synlig
- [ ] "Send forespørgsel" + "Marker udført" knapper synlige
- [ ] X-knap lukker
- [ ] Klik udenfor modal lukker også

**PDF-modal**
- [ ] A4-rapport-preview rendererr som hvidt papir
- [ ] Brevhoved med TradeFlow-logo
- [ ] Mini-plantegning med 3 nummererede pins
- [ ] 3 punktnoter med korrekt info
- [ ] Download + Send-knapper i bunden

### Rapport-skabelon (kopier til en note)
```
Test af TradeFlow prototype — [DATO]
Tester: [DIT NAVN]
Device: [iPhone/Mac/Browser]

Ting der virker som forventet: __
Ting der IKKE virker: __
Ting der ser mærkeligt ud: __
Ting der mangler: __
Spørgsmål: __
```

---

## LAG 2: Test under bygning (når den rigtige app bliver kodet)

Det her sker når prototypen bliver til en rigtig app med backend. Her testes der **i kode** (automatisk) + **af et menneske** (manuelt).

### Automatisk testning — bygges sideløbende med koden
- **Unit tests** (Vitest/Jest) — tester enkelte funktioner: "kan beregne moms korrekt", "kan validere CVR-nummer"
- **Component tests** (React Testing Library) — tester en knap, et form, en liste isoleret
- **E2E tests** (Playwright) — automatisk klik-igennem af hele flows: login → opret sag → fakturér → log ud
- **Visual regression** (Chromatic eller Percy) — fanger uvilkårlige UI-ændringer
- **CI pipeline** kører alle tests automatisk ved hver git push

**Test-mål før første beta:** ~70% line coverage. Ikke 100% — det er overkill.

### Manuel testning under bygning
- **Daily smoke test** — 10-minutters quick walk-through af golden path hver morgen
- **Bugbash** — én gang om ugen sætter teamet 1 time af til at lede efter bugs
- **Cross-browser** — test i Chrome, Safari, Firefox, mobile Safari, Chrome Android

---

## LAG 3: Beta-test med rigtige håndværkere (4 uger før launch)

Det her er det **vigtigste**. Du tror appen er god — først rigtige brugere kan bekræfte det.

### 1) Find 5-10 venner-i-faget
- 2x solo-håndværker (test Solo-planen)
- 2x mindre firma 3-5 ansatte (test Pro-planen)
- 1x større entreprenør (test Business-planen + BIM)

### 2) Giv dem en konkret opgave
Ikke "leg lidt med appen". I stedet:

> **Opgave:**
> "I næste uge skal du bruge TradeFlow på alle dine sager. Tag foto med appen, opret fakturaer her, og brug plantegningen til mindst ét tilsyn. Jeg ringer på fredag og spørger til din oplevelse."

### 3) Spørgsmål til den ugentlige opfølgning
- Hvor mange minutter sparede du om dagen?
- Hvad var det mest irriterende?
- Hvad ville du betale 199 kr/md for at slippe at gøre?
- Ville du anbefale appen til en kollega? Hvorfor / hvorfor ikke?
- Hvilken anden app erstatter denne for dig?

### 4) Mål kvantitativt (sæt analytics op fra dag 1)
- **Activation rate**: hvor mange laver første faktura inden for 7 dage?
- **Retention**: hvor mange logger ind 4 uger senere?
- **Time to value**: hvor mange minutter fra signup til første sag oprettet?
- **NPS-score**: efter 30 dage, "ville du anbefale denne app til en kollega" 0–10

### 5) Pre-launch tjekliste (allerede skrevet i LAUNCH_CHECKLIST.md)
- 0 åbne P0-bugs
- Stripe i live mode (test køb gennemført)
- Backup testet (faktisk restore prøvet)
- App Store + Google Play godkendelse
- Domæner peger korrekt
- Cookie-banner + privatlivspolitik live

---

## Hvad JEG har testet lige nu

Jeg kørte automatisk gennem alle 4 hovedskærme + begge modaler:

| Skærm | Status | Bemærkning |
|---|---|---|
| Oversigt | ✅ | Hero, stats, quick actions, sagsliste renderer korrekt |
| Sager | ✅ | Søg, filter-chips, 3 sag-kort, "Send faktura"-CTA virker |
| Tegning (2D) | ✅ | Plantegning, GPS-prik, 4 pins, legend, "Din position"-kort |
| Tegning (3D) | ✅ | IFC-meta, discipliner, isometrisk bygning, pins |
| Faktura | ✅ | Matematik korrekt (17.802 + 4.450,50 = 22.252,50) |
| Foto | ✅ | Galleri renderer, kamera-knap synlig |
| Pin-sheet modal | ✅ | Åbner/lukker, fotos, note, knapper |
| PDF-modal | ✅ | A4-preview, mini-plan med pins, footer |

**0 visuelle eller funktionelle fejl i prototypen.** Klar til at vise håndværker-venner og samle feedback.

---

## TL;DR — gør det her som det første

1. **I dag:** Åbn preview, gå gennem tjeklisten i Lag 1 (~20 min)
2. **Næste uge:** Vis prototypen til 3 håndværkere du kender — spørg hvad de ville bruge den til
3. **Når du har feedback:** Beslut om vi går til Lag 2 (kode den) eller justere prototypen først
