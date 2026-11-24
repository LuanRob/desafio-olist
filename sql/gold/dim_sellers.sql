-- Dimensão de vendedores.

CREATE OR REPLACE TABLE gold.dim_sellers AS
SELECT
    seller_id,
    seller_city,
    seller_state
FROM silver.sellers