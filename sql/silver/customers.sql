-- Clientes. O CEP fica como texto para preservar zeros à esquerda (ex.: 01310).
-- customer_unique_id é a identificação real do cliente (regra #7).
CREATE OR REPLACE TABLE silver.customers AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    lower(trim(customer_city))  AS customer_city,
    upper(trim(customer_state)) AS customer_state
FROM bronze.customers;