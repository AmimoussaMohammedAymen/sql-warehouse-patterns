-- Type 1 dimension example (overwrite current values)
DROP TABLE IF EXISTS dw.dim_customers_type1;
CREATE TABLE dw.dim_customers_type1 (
  customer_id BIGINT PRIMARY KEY,
  full_name   VARCHAR(200),
  email       VARCHAR(200),
  country     VARCHAR(100),
  updated_ts  DATETIME2
);

MERGE dw.dim_customers_type1 AS tgt
USING dw.stg_customers_latest AS src
ON tgt.customer_id = src.customer_id
WHEN MATCHED THEN UPDATE SET
  full_name = src.full_name,
  email     = src.email,
  country   = src.country,
  updated_ts= src.updated_ts
WHEN NOT MATCHED THEN INSERT (customer_id, full_name, email, country, updated_ts)
VALUES (src.customer_id, src.full_name, src.email, src.country, src.updated_ts);

SELECT * FROM dw.dim_customers_type1 ORDER BY customer_id;
