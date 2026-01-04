-- Keep latest customer record per customer_id (dedupe pattern)
DROP TABLE IF EXISTS dw.stg_customers_latest;

SELECT customer_id, full_name, email, country, updated_ts
INTO dw.stg_customers_latest
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY updated_ts DESC) AS rn
  FROM dw.stg_customers
) t
WHERE rn = 1;

SELECT * FROM dw.stg_customers_latest;
