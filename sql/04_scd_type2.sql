-- SCD2 using hash diff to detect changes
-- Hash = SHA2_256(full_name|email|country)

-- Step 1: Create latest snapshot
IF OBJECT_ID('dw.stg_customers_latest') IS NULL
BEGIN
  RAISERROR('Run 02_dedup_latest_record.sql first', 16, 1);
END

-- Step 2: Add hash to staging
DROP TABLE IF EXISTS dw.stg_customers_latest_h;
SELECT *,
  HASHBYTES('SHA2_256', CONCAT(full_name,'|',email,'|',country)) AS hash_diff
INTO dw.stg_customers_latest_h
FROM dw.stg_customers_latest;

-- Step 3: Expire current rows when changed
UPDATE d
SET effective_to = s.updated_ts,
    is_current = 0
FROM dw.dim_customers_scd2 d
JOIN dw.stg_customers_latest_h s
  ON d.customer_id = s.customer_id
WHERE d.is_current = 1
  AND (d.hash_diff <> s.hash_diff OR d.hash_diff IS NULL);

-- Step 4: Insert new rows (new customers OR changed customers)
INSERT INTO dw.dim_customers_scd2
(customer_id, full_name, email, country, effective_from, effective_to, is_current, hash_diff)
SELECT
  s.customer_id, s.full_name, s.email, s.country,
  s.updated_ts AS effective_from,
  CAST('9999-12-31' AS DATETIME2) AS effective_to,
  1 AS is_current,
  s.hash_diff
FROM dw.stg_customers_latest_h s
LEFT JOIN dw.dim_customers_scd2 d
  ON d.customer_id = s.customer_id AND d.is_current = 1
WHERE d.customer_id IS NULL
   OR d.hash_diff <> s.hash_diff
   OR d.hash_diff IS NULL;

SELECT * FROM dw.dim_customers_scd2 ORDER BY customer_id, effective_from;
