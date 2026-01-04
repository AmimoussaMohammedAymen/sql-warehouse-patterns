-- Drop & create demo schema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name='dw')
EXEC('CREATE SCHEMA dw');
GO

DROP TABLE IF EXISTS dw.stg_customers;
DROP TABLE IF EXISTS dw.dim_customers_scd2;
DROP TABLE IF EXISTS dw.fact_orders;
GO

-- Staging customers (incoming snapshots)
CREATE TABLE dw.stg_customers (
  customer_id BIGINT,
  full_name   VARCHAR(200),
  email       VARCHAR(200),
  country     VARCHAR(100),
  updated_ts  DATETIME2
);

-- SCD2 dimension
CREATE TABLE dw.dim_customers_scd2 (
  customer_sk      BIGINT IDENTITY(1,1) PRIMARY KEY,
  customer_id      BIGINT NOT NULL,
  full_name        VARCHAR(200),
  email            VARCHAR(200),
  country          VARCHAR(100),
  effective_from   DATETIME2 NOT NULL,
  effective_to     DATETIME2 NOT NULL,
  is_current       BIT NOT NULL,
  hash_diff        VARBINARY(32) NULL
);

-- Fact orders
CREATE TABLE dw.fact_orders (
  order_id     BIGINT PRIMARY KEY,
  customer_id  BIGINT,
  amount       DECIMAL(18,2),
  order_ts     DATETIME2
);

-- Seed staging data (2 snapshots)
INSERT INTO dw.stg_customers VALUES
(1,'Sara Ali','sara@example.com','FR','2025-01-01'),
(2,'John Doe','john@example.com','DE','2025-01-01'),
(3,'Mina Chen','mina@example.com','NL','2025-01-01');

-- second snapshot: customer 2 moved country, customer 3 changed email
INSERT INTO dw.stg_customers VALUES
(2,'John Doe','john@example.com','NL','2025-02-01'),
(3,'Mina Chen','mina_new@example.com','NL','2025-02-01');
