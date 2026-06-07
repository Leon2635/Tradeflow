# TradeFlow — Cloud-arkitektur & Launch-plan

> Hvordan vi sætter TradeFlow i skyen, hvad det koster, og rækkefølgen vi bygger i.

## 1. Stack-anbefaling

| Lag | Valg | Hvorfor |
|---|---|---|
| **Frontend (web)** | Next.js 15 + Tailwind, hosted på **Vercel** | Samme codebase som landing.html, edge-deploy, gratis preview pr. PR |
| **Mobile app** | **React Native + Expo** (EAS Build) | 1 codebase → iOS + Android, OTA-updates uden App Store-review |
| **Backend** | **Supabase** (Postgres + Auth + Storage + Edge Functions) | EU-region (Frankfurt), billigt op til ~5000 brugere, GDPR-fri |
| **File storage** | Supabase Storage (S3-bagved) for fotos/PDF/IFC | RLS = bruger ser kun egne filer |
| **IFC/Revit konvertering** | **IFC.js + web-ifc-three** i browseren, .rvt via **Speckle**/**Autodesk Platform Services** server-side | IFC parses gratis; .rvt → IFC kræver ekstern API (APS = $0.10/credit) |
| **PDF-generering** | **react-pdf** server-side i Supabase Edge Function | Skarp typografi, embedder fotos + tegninger |
| **Email/e-Boks** | **Postmark** (transaktionel) + **e-Boks API** | Postmark $15/md for 10k mails, e-Boks via integrationspartner |
| **Payments** | **Stripe** (subscriptions + DK MobilePay som payment method) | Indbygget moms, fakturering, customer portal |
| **Push notifications** | **Expo Push** + APNs | Gratis for normal volumen |
| **Error tracking** | **Sentry** | $26/md hobbyplan, dækker frontend + backend |
| **Analytics** | **PostHog Cloud (EU)** | Product analytics + feature flags + session replay |
| **CI/CD** | **GitHub Actions** → Vercel + EAS | Auto-deploy on `main`, EAS submit til TestFlight |

## 2. Datamodel (Supabase Postgres)

```
organizations (id, name, cvr, plan, created_at)
users (id, org_id FK, email, role, ...)
customers (id, org_id, name, address, cvr, email, ...)
jobs (id, org_id, customer_id, title, status, hourly_rate, ...)
time_entries (id, job_id, user_id, started_at, ended_at, gps_lat, gps_lng, ...)
photos (id, job_id, pin_id?, storage_path, gps_lat, gps_lng, taken_at, ...)
drawings (id, job_id, name, type ENUM('pdf','ifc','rvt','dwg'), storage_path, ...)
pins (id, drawing_id, type ENUM('inspection','inquiry'), status, title, note, gps_lat, gps_lng, ifc_element_guid?, ...)
invoices (id, job_id, customer_id, lines JSONB, total, vat, status, sent_at, ...)
audit_log (id, org_id, user_id, action, entity, entity_id, payload JSONB, created_at)
```

**Row Level Security (RLS):** Hver tabel har policy `org_id = auth.jwt() -> org_id`. Ingen kan se andre firmaers data.

## 3. Realistisk månedlig drift-cost

| Brugere | Vercel | Supabase | Postmark | Sentry | APS (Revit) | I alt |
|---|---|---|---|---|---|---|
| 0–100 | $0 (Hobby) | $0 (Free) | $0 (100 mails) | $0 | $0 | **~0 kr** |
| 100–1.000 | $20 (Pro) | $25 | $15 | $26 | ~$50 | **~$140 ≈ 970 kr/md** |
| 1.000–5.000 | $20 | $200 (Pro + addons) | $50 | $80 | ~$200 | **~$550 ≈ 3.800 kr/md** |
| 5.000+ | $50 (Enterprise) | Custom (~$1.500) | Custom | Custom | Custom | Forhandl |

**Break-even:** Ved 30 betalende Solo-brugere á 199 kr = 5.970 kr/md → dækker drift på 0–1.000 brugere-tier.

## 4. Sikkerhed & GDPR

- [ ] **DPA** (databehandleraftale) klar til kunder — kan skrives på basis af Supabases DPA
- [ ] **Privatlivspolitik** + **vilkår** — typisk pris hos jurist: 8–15.000 kr engangs
- [ ] **2FA** for admin-brugere (Supabase Auth understøtter TOTP)
- [ ] **Audit log** for kritiske handlinger (faktura sendt, sag slettet, bruger inviteret)
- [ ] **Backup**: Supabase tager automatisk daglige backups, opbevares 7 dage (Pro: 30 dage)
- [ ] **PITR** (point-in-time recovery) — kræver Supabase Pro
- [ ] **Encryption at rest** — automatisk via Supabase
- [ ] **Sletning af konto** — alle data slettes inden for 30 dage (manuel cleanup-cron)

## 5. Udrulnings-rækkefølge (8 uger til public beta)

### Uge 1–2 — Foundation
- Konvertér prototype-HTML til Next.js + komponentbibliotek
- Supabase setup: schema, RLS, auth flow (email + Apple Sign In)
- Stripe products + checkout
- Landing.html → Vercel på `tradeflow.dk`

### Uge 3–4 — Core app (web først)
- Sager, tidsregistrering, foto-upload med GPS
- Fakturagenerering med PDF
- Email-udsendelse via Postmark

### Uge 5–6 — Mobile + Tegninger
- React Native shell + 4 hovedskærme
- 2D PDF-viewer med pins (pdf.js)
- IFC-viewer (web-ifc-three)
- Foto-capture med kamera + GPS
- Offline-cache (WatermelonDB)

### Uge 7 — Polish & test
- Pre-launch checklist (se LAUNCH_CHECKLIST.md)
- Bugbash med 5 venner-i-faget
- Performance: alle skærme < 200ms initial render
- Loading states + error boundaries overalt

### Uge 8 — Public beta
- TestFlight + Google Play Internal Testing
- 14-dages trial-flow live
- Stripe live mode
- Support-email + Crisp chat på siden
- LinkedIn + Facebook-grupper for håndværkere (annoncekampagne 5.000 kr/md)

## 6. Domæner & branding
- `tradeflow.dk` — primær (køb hos DK Hostmaster, ~50 kr/år)
- `tradeflow.app` — backup + app-deep-links
- `app.tradeflow.dk` — web-app (efter login)
- `api.tradeflow.dk` — Supabase custom domain

## 7. Risici & blocker-liste
- **Revit-konvertering**: APS er løbende cost. Overvej at starte med kun .ifc, og tag .rvt senere
- **App Store-review**: Forvent 1-2 ugers første godkendelse. Forbered marketing screenshots, privacy nutrition label
- **e-Boks-integration**: Kræver godkendelse hos Nets/MitID — kan tage 4-8 uger. Start uden, brug mail først
- **CVR-validering**: Brug `cvrapi.dk` (gratis op til 1000 kald/dag) til auto-udfyldning af kundeinfo
