-- Dimensão de clientes. Grão: um customer_id (gerado a cada pedido)
-- customer_unique_id identifica a pessoa e é usada na análise de recompra (regra #7)

CREATE OR REPLACE TABLE gold.dim_customers AS
SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM silver.customers;