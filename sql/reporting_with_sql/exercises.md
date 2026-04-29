# Reporting with SQL — Exerciții propuse

Folosește baza `sales_db` (vezi `init.sql` + `seed.sql`). O singură tabelă: `sales` cu 25 de tranzacții repartizate pe 12 luni.

> 💡 În MySQL coloana `sold_at` e `DATETIME` — folosește funcții de dată ca `DATE_FORMAT()`, `DATE_ADD()`, `DATEDIFF()`, `MONTH()`, `YEAR()`.

---

## ORDER BY & LIMIT

- [ ] **EX-1.** Afișează toate vânzările sortate descrescător după `unit_price`.
- [ ] **EX-2.** Top 5 cele mai recente vânzări (după `sold_at`).
- [ ] **EX-3.** Afișează vânzările sortate după `region` ascendent, apoi după `unit_price` descendent.
- [ ] **EX-4.** Paginare: afișează rândurile 11–20 ordonate după `id`.

## Funcții agregate (fără GROUP BY)

- [ ] **EX-5.** Numărul total de vânzări. *(Așteptat: 25)*
- [ ] **EX-6.** Suma totală încasată: `SUM(quantity * unit_price)`.
- [ ] **EX-7.** Prețul mediu unitar al unui produs vândut, rotunjit la 2 zecimale.
- [ ] **EX-8.** Cea mai mare valoare a unei singure tranzacții (`MAX(quantity * unit_price)`).
- [ ] **EX-9.** Numărul de produse distincte vândute. *Hint:* `COUNT(DISTINCT product)`.

## GROUP BY

- [ ] **EX-10.** Suma totală vândută pe regiune.
- [ ] **EX-11.** Numărul de tranzacții per `salesperson`.
- [ ] **EX-12.** Cantitatea totală vândută per produs, ordonată descrescător.
- [ ] **EX-13.** Prețul mediu pentru fiecare produs.

## HAVING

- [ ] **EX-14.** Salesperson-i cu peste 5 tranzacții. *Hint:* `HAVING COUNT(*) > 5`.
- [ ] **EX-15.** Produse cu vânzări totale (suma `quantity * unit_price`) mai mari de 30 000 RON.

## Funcții de string

- [ ] **EX-16.** Afișează `salesperson` cu litere mari și `region` cu litere mici.
- [ ] **EX-17.** Afișează prima literă a numelui de familie pentru fiecare salesperson. *Hint:* `SUBSTRING(salesperson, ...)` sau `SUBSTRING_INDEX`.
- [ ] **EX-18.** Concatenează salesperson-ul și regiunea: `'Andrei Popescu — North'`.

## Funcții de dată

- [ ] **EX-19.** Vânzările din anul 2025. *Hint:* `YEAR(sold_at) = 2025`.
- [ ] **EX-20.** Numărul de vânzări per lună (`YYYY-MM`). *Hint:* `DATE_FORMAT(sold_at, '%Y-%m')`.
- [ ] **EX-21.** Vânzările din ultimele 60 de zile relativ la `NOW()`.
- [ ] **EX-22.** Pentru fiecare vânzare, afișează `id` și diferența în zile între `sold_at` și data curentă. *Hint:* `DATEDIFF(NOW(), sold_at)`.
- [ ] **EX-23.** Formatează `sold_at` ca `'15 May 2025, 10:30'` pentru toate vânzările. *Hint:* `DATE_FORMAT(sold_at, '%d %M %Y, %H:%i')`.

## Provocări

- [ ] **CH-1.** Raport lunar: pentru fiecare lună (`YYYY-MM`) afișează numărul de vânzări, cantitatea totală vândută și venitul total. Sortare descrescătoare după lună.
- [ ] **CH-2.** Top 3 salesperson-i după venit total, cu venitul afișat formatat (ex: `'45,200.00 RON'`). *Hint:* `FORMAT()` sau `CONCAT(FORMAT(...), ' RON')`.
- [ ] **CH-3.** Pentru fiecare regiune afișează produsul cel mai vândut (după cantitate). *Hint:* mai multă bătaie de cap — folosește subquery sau `ROW_NUMBER() OVER (PARTITION BY ...)`.

---

## Scenarii frecvente în producție

- [ ] **PR-1.** KPI zilnic: pentru fiecare zi afișează numărul de tranzacții și venitul total din ziua respectivă.
- [ ] **PR-2.** KPI per produs: pentru fiecare `product` afișează venitul total, cantitatea totală și prețul mediu ponderat (`SUM(quantity * unit_price) / SUM(quantity)`).
- [ ] **PR-3.** Last activity report: pentru fiecare salesperson afișează data ultimei vânzări.
- [ ] **PR-4.** Leaderboard regional: pentru fiecare `region` afișează salesperson-ul cu cel mai mare venit total. *Hint:* subquery sau `ROW_NUMBER()`.
- [ ] **PR-5.** Analiză de mix: pentru fiecare lună afișează câte produse distincte s-au vândut.
- [ ] **PR-6.** Alertă operațională: tranzacțiile cu valoare peste 15 000 RON, ordonate descrescător după valoare.
- [ ] **PR-7.** Forecast de stoc simplificat: pentru fiecare produs afișează cantitatea totală vândută în ultimele 90 de zile relativ la `NOW()`.
- [ ] **PR-8.** Quality check: identifică salesperson-ii care au vândut același produs la prețuri unitare diferite.
- [ ] **PR-9.** Raport de eficiență: pentru fiecare salesperson afișează venitul mediu per tranzacție.
- [ ] **PR-10.** Month-over-month: pentru fiecare lună afișează venitul total și diferența față de luna precedentă. *Hint:* `LAG()` sau self-join pe agregarea lunară.
- [ ] **PR-11.** Distribuție regională: pentru fiecare regiune afișează ponderea din venitul total al companiei, în procente.
- [ ] **PR-12.** Product concentration: afișează produsul care a generat cel mai mare venit în fiecare trimestru calendaristic.
