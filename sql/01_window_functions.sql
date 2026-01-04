-- ROW_NUMBER: latest record per customer (from staging)
WITH x AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY updated_ts DESC) AS rn
  FROM dw.stg_customers
)
SELECT customer_id, full_name, email, country, updated_ts
FROM x
WHERE rn = 1;

-- LAG: detect country change over time
WITH y AS (
  SELECT customer_id, country, updated_ts,
         LAG(country) OVER (PARTITION BY customer_id ORDER BY updated_ts) AS prev_country
  FROM dw.stg_customers
)
SELECT *
FROM y
WHERE prev_country IS NOT NULL AND country <> prev_country;
