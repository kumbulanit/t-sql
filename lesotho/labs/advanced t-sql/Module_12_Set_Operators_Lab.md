# Module 12: Set Operators
## Central Bank of Lesotho - Data Management Division
## For Economists and Statisticians

### Lab Overview
**Duration:** 75 minutes  
**Difficulty:** Intermediate  
**Prerequisites:** Modules 1-11 completed  
**Target Audience:** Analysts comparing datasets and reconciling submissions

---

## Learning Objectives
1. Use UNION vs UNION ALL appropriately
2. Apply INTERSECT to find overlapping populations
3. Use EXCEPT to identify gaps between systems
4. Harmonize column metadata for compatible set operations
5. Combine set operators with derived columns to keep context
6. Document reconciliation logic for audit teams

---

## BEGINNER SECTION (Required)

### Exercise 12.1: UNION and UNION ALL

**Task 1:** Stakeholder master list  
**Topic:** MS20761 Module 12 Lesson 1 – UNION ALL to retain duplicates  
**Beginner Explanation:** Merge research staff and dissemination recipients into one view while retaining duplicates for workload analysis.

```sql
-- Consolidate internal and external contacts
SELECT 
    StaffID AS EntityID,
    CONCAT(FirstName, ' ', LastName) AS EntityName,
    Division AS EntityType,
    Email,
    'ResearchStaff' AS SourceTable
FROM ResearchStaff
UNION ALL
SELECT 
    DisseminationID AS EntityID,
    RecipientName,
    RecipientType,
    RecipientContact,
    'DataDissemination' AS SourceTable
FROM DataDissemination;
```

**Detailed Explanation:** UNION ALL avoids costly duplicate elimination and preserves row counts for capacity planning.

---

**Task 2:** Unique dissemination parties  
**Topic:** MS20761 Module 12 Lesson 1 – UNION to remove duplicates  
**Beginner Explanation:** Produce a distinct list of organizations that either requested or received datasets.

```sql
-- Distinct engagement list
SELECT RecipientName
FROM DataDissemination
UNION
SELECT RequestedBy
FROM DataDissemination
WHERE RequestedBy IS NOT NULL;
```

**Detailed Explanation:** UNION removes duplicates across both lists, generating a concise engagement register.

---

### Exercise 12.2: INTERSECT and EXCEPT

**Task 3:** Banks with both submissions and dissemination  
**Topic:** MS20761 Module 12 Lesson 2 – INTERSECT usage  
**Beginner Explanation:** Find commercial banks that not only submit data but also receive official releases.

```sql
-- Overlap between submitters and recipients
SELECT BankName
FROM CommercialBanks
WHERE IsActive = 1
INTERSECT
SELECT RecipientName
FROM DataDissemination
WHERE RecipientType = 'Commercial Bank';
```

**Detailed Explanation:** INTERSECT only returns names appearing in both lists, highlighting reciprocal relationships.

---

**Task 4:** Missing dissemination confirmations  
**Topic:** MS20761 Module 12 Lesson 2 – EXCEPT gap report  
**Beginner Explanation:** Determine which banks reported statistics but never received a dissemination entry in 2024.

```sql
-- Banks submitting data without receiving outputs
SELECT DISTINCT cb.BankName
FROM BankingStatistics bs
JOIN CommercialBanks cb ON cb.BankID = bs.BankID
WHERE bs.ReportingYear = 2024
EXCEPT
SELECT RecipientName
FROM DataDissemination
WHERE RecipientType = 'Commercial Bank'
  AND YEAR(DisseminationDate) = 2024;
```

**Detailed Explanation:** `EXCEPT` subtracts recipients from reporters to identify relationship gaps.

---

### Exercise 12.3: Combining sets with context

**Task 5:** Unified macro series availability  
**Topic:** MS20761 Module 12 Lesson 3 – UNION ALL with metadata columns  
**Beginner Explanation:** Stack CPI and FX reserve summaries while retaining a label for each indicator grouping.

```sql
-- Combine CPI and reserve availability summaries
SELECT 
    'CPI' AS IndicatorGroup,
    COUNT(*) AS Observations,
    MIN(PeriodDate) AS FirstPeriod,
    MAX(PeriodDate) AS LastPeriod
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode LIKE 'CPI-%'
UNION ALL
SELECT 
    'FX_RESERVES' AS IndicatorGroup,
    COUNT(*),
    MIN(PeriodDate),
    MAX(PeriodDate)
FROM TimeSeriesData ts
JOIN EconomicIndicators ei ON ei.IndicatorID = ts.IndicatorID
WHERE ei.IndicatorCode = 'FX-RESERVES';
```

**Detailed Explanation:** Matching column datatypes allows stacked summaries that still identify which series each row represents.

---

## Testing Checklist
- [ ] Exercise 12.1 Task 1
- [ ] Exercise 12.1 Task 2
- [ ] Exercise 12.2 Task 3
- [ ] Exercise 12.2 Task 4
- [ ] Exercise 12.3 Task 5

Note any duplicate-handling observations inside `sql_validation_report.md`.
