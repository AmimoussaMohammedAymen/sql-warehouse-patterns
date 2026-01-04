# SQL DE Cheatsheet

## Latest record per key
ROW_NUMBER() OVER (PARTITION BY key ORDER BY updated_ts DESC)

## Change detection
LAG(col) OVER (PARTITION BY key ORDER BY updated_ts)

## Upsert
MERGE target USING source ON key

## SCD2
- expire current when hash changes
- insert new row with effective_to=9999-12-31, is_current=1
