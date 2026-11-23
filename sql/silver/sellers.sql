-- Vendedores, com a mesma padronização de cidade e estado dos clientes.
CREATE OR REPLACE TABLE silver.sellers AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    lower(trim(seller_city))  AS seller_city,
    upper(trim(seller_state)) AS seller_state
FROM bronze.sellers;