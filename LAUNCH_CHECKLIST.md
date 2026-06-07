# TradeFlow — Pre-Launch QA Checkliste

> Hver punkt skal være "✅ verificeret af menneske" inden public launch. Ikke bare "implementeret".

## 1. Funktionel test — golden path

### Onboarding
- [ ] Ny bruger kan oprette konto via email
- [ ] Sign in with Apple virker på iOS
- [ ] Email-bekræftelse modtages inden 60 sek
- [ ] Glemt-password flow virker (link udløber efter 24t)
- [ ] CVR-opslag auto-udfylder firmainfo
- [ ] Onboarding-tur (4 trin) afsluttes uden bugs

### Sager
- [ ] Opret ny sag med kunde, adresse, timepris
- [ ] Rediger eksisterende sag
- [ ] Slet sag (med bekræftelses-dialog)
- [ ] Søg/filtrér virker (I gang / Planlagt / Færdig / Ufaktureret)
- [ ] Sortering bevares ved navigation

### Tid
- [ ] Start timer fra forside + fra sag-detalje
- [ ] Pause/genoptag fungerer
- [ ] Stop gemmer entry korrekt med GPS
- [ ] Manuel tilføjelse af tid for tilbageblevne dage
- [ ] Total pr. dag/uge stemmer matematisk
- [ ] Kørselstid trækkes fra automatisk når GPS detekterer bevægelse > 15 km/t

### Foto
- [ ] Kamera-permission spørgsmål vises korrekt på iOS + Android
- [ ] GPS-permission spørgsmål med rigtig forklaring
- [ ] Foto auto-tagges med sag, GPS, timestamp
- [ ] Foto vises i sag og pin
- [ ] Slet foto fra galleri
- [ ] Upload genoptages efter netværksafbrydelse

### Tegninger & Pins
- [ ] Upload PDF → renderes som side med pinch-zoom
- [ ] Upload .ifc → 3D-viewer loader inden 5 sek for fil < 20 MB
- [ ] Upload .rvt → konvertering køres + status vises
- [ ] Drop pin ved tap virker præcist
- [ ] Pin-detail-sheet med foto + note gemmes
- [ ] GPS "Du er her"-prik opdateres hver 5 sek
- [ ] Pin-status (Åben/Afventer/Lukket) skifter korrekt
- [ ] BCF-eksport (kun Business) downloader gyldig .bcfzip

### Faktura
- [ ] Auto-generer fra tid + materialer giver korrekt sum
- [ ] Moms 25% beregnes korrekt
- [ ] Send via mail → kunde modtager PDF
- [ ] Send via e-Boks → leveringsbekræftelse
- [ ] Status opdateres (Kladde → Sendt → Betalt)
- [ ] Påmindelse efter 14 dage hvis ubetalt
- [ ] Kreditnota kan oprettes fra eksisterende faktura

### PDF-rapport
- [ ] Generér rapport med tegning + pins + fotos
- [ ] GPS-koordinater pr. pin synlige
- [ ] Logo og letterhead matcher org-branding
- [ ] PDF kan downloades
- [ ] PDF kan sendes direkte til kunde

## 2. Edge cases

- [ ] Hvad sker hvis brugeren er offline i 8 timer? (skal queues local, syncs op)
- [ ] Stort foto (50 MB) — uploads i baggrund, kompresseres
- [ ] 500+ sager i listen — virtualization, scrolling jævn
- [ ] Bruger forlader org → mister adgang, data bevares hos org
- [ ] Org slettes → 30 dages grace period med data-export
- [ ] Stripe-betaling fejler → grace period 7 dage før read-only mode
- [ ] Dobbelt-tap på "Send faktura" → idempotency, sendes kun én gang

## 3. Performance

- [ ] Initial load < 2 sek på 3G
- [ ] Sag-liste med 100 elementer scrollere ved 60 fps
- [ ] IFC-fil 20 MB åbner < 5 sek
- [ ] PDF 10 sider åbner < 2 sek
- [ ] Foto-upload starter < 1 sek efter capture
- [ ] Cold start på iOS < 2.5 sek

## 4. Cross-device

- [ ] iPhone SE (lille skærm) — alt læseligt, ingen overflow
- [ ] iPhone 15 Pro Max — udnytter plads
- [ ] iPad — sidebar-layout
- [ ] Android Pixel 7 — kamera + GPS virker
- [ ] Web Chrome/Safari/Firefox — alle skærme fungerer
- [ ] Dark mode kun (lys mode skubbes til v1.1)

## 5. Sikkerhed

- [ ] HTTPS overalt (HSTS preload)
- [ ] CSP-header konfigureret
- [ ] Ingen secrets i bundle (`.env` ikke committed)
- [ ] RLS-policies dækker alle tabeller
- [ ] Penetrationstest af auth-flow (kør OWASP ZAP)
- [ ] Rate limiting på login (5 forsøg / 15 min)
- [ ] 2FA virker for admins
- [ ] Audit log fanger alle kritiske handlinger
- [ ] DPA klar at sende til kunder

## 6. Juridisk

- [ ] Vilkår tjekket af jurist
- [ ] Privatlivspolitik tjekket af jurist
- [ ] Cookie-banner kun ved tracking (PostHog)
- [ ] CVR + adresse synlig i footer
- [ ] App Store: privacy nutrition label udfyldt
- [ ] Google Play: data safety form udfyldt

## 7. Marketing & support

- [ ] Landing.html live på `tradeflow.dk`
- [ ] Google Analytics 4 + PostHog installeret
- [ ] App Store + Play Store screenshots klar (alle screen sizes)
- [ ] App Store keywords + beskrivelse på dansk + engelsk
- [ ] Demo-video 60 sek til hero
- [ ] FAQ-sektion dækker top 10 support-spørgsmål
- [ ] `hej@tradeflow.dk` videresendes
- [ ] Crisp chat opsætning på siden
- [ ] Status-side på `status.tradeflow.dk` (UptimeRobot)
- [ ] Slack-kanal til support-tickets

## 8. Beta-fase (uge 1-2 efter launch)

- [ ] Inviter 20 håndværkere fra netværk
- [ ] Daglig Crisp-monitorering
- [ ] Sentry-error gennemgang hver morgen
- [ ] Uge 2: NPS-survey via in-app modal
- [ ] Indsaml feedback i Linear
- [ ] Hurtig-fix cyklus 24-48t på P0-bugs

## 9. Go-live kriterier (alle skal være ✅)

- [ ] 0 åbne P0-bugs
- [ ] < 5 åbne P1-bugs
- [ ] 95% af test ovenfor verificeret
- [ ] Stripe i live mode (test transaktion gennemført)
- [ ] Backup verificeret (faktisk restore testet)
- [ ] Incident response-plan dokumenteret (hvem ringes hvornår)

## 10. Post-launch — uge 1 daily check

- [ ] Sentry error rate < 0.5%
- [ ] Stripe successful checkout > 70%
- [ ] Trial → paid conversion tracked
- [ ] Server response time p95 < 400ms
- [ ] Mindst 1 supportbesked besvaret inden 4 timer
