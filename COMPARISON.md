# TradeFlow vs. Dalux Field — feature sammenligning

> Ærlig sammenligning. Hvor vi er foran, hvor vi er bagud, og hvad der MÅ være på plads før vi kan konkurrere seriøst.

---

## 1) Side-om-side

| Område | TradeFlow (nu) | Dalux Field | Vurdering |
|---|---|---|---|
| **Tegning-upload (PDF/billede)** | ✅ Billede virker, PDF mangler | ✅ Begge + DWG, IFC | 🟡 Bagud |
| **Pin på tegning** | ✅ Tap → koordinat gemmes | ✅ Tap → koordinat | ✅ På niveau |
| **Foto med kamera** | ✅ Native iOS-kamera via input | ✅ Native + GPS-stempel | ✅ På niveau |
| **GPS-koordinater** | ✅ navigator.geolocation | ✅ Plus matchet på tegning | 🟡 Bagud (de matcher GPS til model) |
| **Multi-tegninger per sag** | ❌ Kun én | ✅ Ubegrænset | 🔴 Bagud |
| **3D IFC viewer** | 🟡 UI-mockup, ingen rigtig render | ✅ Verdens hurtigste IFC viewer | 🔴 Langt bagud |
| **Revit-import (.rvt)** | 🟡 Annonceret, ikke implementeret | ✅ Via cloud-konvertering | 🔴 Bagud |
| **BCF-eksport** | ❌ | ✅ Standard | 🔴 Bagud |
| **PDF tilsynsrapport** | 🟡 UI-preview, ikke ægte PDF | ✅ Professionel branded PDF | 🟡 Tæt på |
| **Offline-mode** | ✅ Alt i IndexedDB | ✅ Cache + sync | ✅ På niveau |
| **Multi-user (samme projekt)** | ❌ Kun lokal data | ✅ Realtid + sync | 🔴 Kritisk gap |
| **Admin + roller** | ❌ | ✅ Owner/Manager/Worker/Viewer | 🔴 Kritisk gap |
| **Tildeling af tilsyn** | ❌ | ✅ "Send til VVS Holm" | 🔴 Kritisk gap |
| **Notifikationer** | ❌ | ✅ Push + email | 🔴 Kritisk gap |
| **Status-workflow** | 🟡 Åben/Lukket binær | ✅ Åben→Tildelt→Udført→Verificeret→Lukket | 🟡 Bagud |
| **Søg + filtrer pins** | ❌ | ✅ Avanceret filter | 🟡 Bagud |
| **Aktivitetshistorik** | ❌ | ✅ Audit trail | 🟡 Bagud |
| **Kommentarer på pin** | ❌ | ✅ Chat-tråd per pin | 🟡 Bagud |
| **Eksterne brugere (bygherre)** | ❌ | ✅ Read-only invitation | 🟡 Bagud |
| **Cross-discipline filter** (skjul VVS, vis Ark) | ❌ | ✅ | 🟡 Bagud |
| **Fakturering** | 🟡 UI-stub | ❌ De har det IKKE | ✅ **Vores kant** |
| **Tidsregistrering på sag** | ❌ (vi fjernede det) | ❌ | Lige |
| **Prisen** | Vi sigter 199-699 kr/md | Dalux Field ~700-1.500 kr/md/bruger | ✅ **Billigere** |
| **Dansk fokus** | ✅ Dansk UI, e-Boks-tankegang | 🟡 International, dansk firma men generisk | ✅ **Lokal kant** |

---

## 2) Hvor TradeFlow VINDER

### 🏆 Faktura + tilsyn i samme app
Dalux har INTET fakturerings-modul. Håndværkere bruger Dalux **plus** Minuba/Ordrestyring **plus** Excel. Vi kan samle det i én app — det er **det stærkeste salgsargument** vi har.

### 🏆 Billigere
Dalux Field koster typisk 700-1.500 kr/md per bruger. Vi rammer halv pris.

### 🏆 Dansk fra dag 1
Dalux er dansk firma men UI'et er engelsk-først (mange europæiske kunder). Vi er på dansk fra start: kommerciel sprog, e-Boks-flow, SKAT-godkendt faktura-format, CVR-opslag.

### 🏆 Enklere onboarding
Dalux er overvældende — 8 moduler, mange tabs, "BIM-language". Vores app er **én håndværker, én sag, ét tilsyn** — minimal læringskurve.

---

## 3) Hvor Dalux VINDER (det vi MÅ adressere)

### 🔴 Multi-user med samme projekt (KRITISK)
Lige nu har TradeFlow lokal-only data. Ingen kan se andres sager. **Dette er den vigtigste mangel** — uden det er vi en notes-app, ikke en samarbejds-app.

Løsning: **Supabase backend + login**. Kompleksitet: 3-4 timer at sætte op grundlæggende, 1-2 dage for at få det production-ready.

### 🔴 Admin + roller (KRITISK)
Du nævnte selv det her tidligere — det er Dalux's standard:

```
OWNER       — firma-ejer, ser alt, billing, kan invitere
PROJECT MGR — styrer ét projekt, tildeler opgaver
FIELD WORKER— svend/lærling, kun pins + fotos
VIEWER      — bygherre/arkitekt, kun læse-adgang til specifikt projekt
```

Uden dette kan vi ikke sælge til firmaer med 2+ ansatte.

### 🔴 3D IFC viewer (vigtigt, men ikke dag 1)
Vi har en flot mockup, men ikke ægte rendering. For seriøse BIM-kunder er det must-have. For 90% af danske håndværkere (solo + små firmaer) er det **nice-to-have**.

Beslutning: Skub til v1.5 og positionér Solo/Pro-planer uden BIM. Business-planen får IFC senere.

### 🔴 Tildelinger + notifikationer
"Send tilsyn til VVS Holm" → han får email + push-notifikation. Uden det er hver pin bare en note.

### 🔴 Multi-tegning per sag
Lige nu kun én. Et reelt projekt har 5-15 tegninger (stueplan, 1. sal, facader, snit, detaljer). Det her er en simpel UI-udvidelse + datamodel.

---

## 4) Must-have feature-roadmap for at konkurrere

### V1.0 (det vi har nu)
- ✅ Sag + tegning + pin + foto + GPS lokalt
- ✅ Cloudflare-deployed
- ✅ Mobile-first

### V1.1 — Multi-user foundation (uge 1-2)
- [ ] Login med Apple Sign In + email
- [ ] Supabase backend
- [ ] Organisationer (firmaer)
- [ ] Inviter brugere via email
- [ ] Sager deles inden for org
- [ ] Sync mellem enheder

### V1.2 — Roller + permissions (uge 2-3)
- [ ] 4 roller: Owner / Manager / Worker / Viewer
- [ ] Adgangskontrol per projekt
- [ ] Audit log
- [ ] Tildel pins til personer
- [ ] Email-notifikation når tildelt

### V1.3 — Multi-tegning + status (uge 3-4)
- [ ] Flere tegninger per sag
- [ ] Tegnings-vælger på Tegning-skærm
- [ ] Status: Åben → Tildelt → Udført → Verificeret → Lukket
- [ ] Foto-bevis krav ved "Udført"
- [ ] Kommentar-tråd per pin

### V1.4 — Faktura (uge 4-5)
- [ ] Auto-generér fra timer + materialer
- [ ] PDF-eksport (rigtig PDF, ikke mockup)
- [ ] e-Boks-integration via partner
- [ ] Sendes til kunde

### V1.5 — BIM (uge 6-8, kun Business-plan)
- [ ] Three.js + web-ifc viewer
- [ ] PDF tegnings-render (pdf.js)
- [ ] Disciplin-filter
- [ ] Revit (.rvt) via Speckle/APS

### V2.0 — Konkurrence-paritet
- [ ] BCF-eksport
- [ ] Dalux/BIM360-integration
- [ ] Tilbud-flow (mod Tender-modul)
- [ ] Service-aftaler / FM-light

---

## 5) Strategisk positionering

### Til dansk solo-håndværker (Solo-plan, 199 kr/md)
**Pitch:** *"Faktura, foto-doc og GPS-tilsyn — alt på din lomme. Ingen abonnement til Dropbox, e-conomic OG Dalux."*  
TradeFlow er **erstatning for Excel + Dropbox** for den enkelte håndværker.

### Til mindre firma (Pro-plan, 399 kr/md/bruger)
**Pitch:** *"Hold styr på 5 sager, 3 svende og 30 tilsyn — uden BIM-uddannelse."*  
TradeFlow er **simpler-than-Dalux** med faktura indbygget.

### Til entreprenør med BIM (Business-plan, 699 kr/md/bruger)
**Pitch:** *"Dalux-funktioner til halv pris, plus fakturering."*  
TradeFlow er **Dalux Field-light + faktura**.

---

## 6) Hvad vi IKKE skal gøre

- ❌ **Ikke konkurrere på BIM-depth** med Dalux — de har 8 års forspring
- ❌ **Ikke målrette store entreprenører** (Per Aarsleff, NCC) — de bruger Dalux/BIM360
- ❌ **Ikke bygge alle 8 moduler** — fokus på Field + Faktura
- ❌ **Ikke kopiere Dalux's komplekse UI** — vores kant er enkelheden

---

## TL;DR

**TradeFlow's vinder-position:** "Det Dalux er for store byggeprojekter, er TradeFlow for den danske håndværker — plus det fakturerer din kunde."

**Næste konkrete skridt:** Login + brugere + roller (Supabase). Det er det der gør TradeFlow fra "notes-app" til "samarbejds-app".
