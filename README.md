# SQL Warehouse Patterns (Windows • MERGE • SCD Type 2)

A practical SQL project demonstrating common **Data Engineering / Data Warehouse patterns**:
- Window functions (ROW_NUMBER, RANK, LAG/LEAD)
- Deduplicating latest record per key
- MERGE upserts (incremental loads)
- Slowly Changing Dimensions Type 2 (history tracking)
- Index basics and plan awareness

Tested on SQL Server syntax (works similarly on Azure SQL).

## Run
1) Execute: `sql/00_schema_and_sample_data.sql`
2) Run each script in order:
   - `01_window_functions.sql`
   - `02_dedup_latest_record.sql`
   - `03_merge_upsert.sql`
   - `04_scd_type2.sql`

## Why recruiters care
These are the exact patterns used in:
- building dimensions/facts
- incremental pipelines
- history tracking
- dedup + change detection

## Author
Aymen Amimoussa
