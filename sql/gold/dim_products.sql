-- Dimensão de produtos, com a categoria em português e a tradução em inglês.

CREATE OR REPLACE TABLE gold.dim_products AS
SELECT
    product_id,
    product_category_name         AS category_pt,
    product_category_name_english AS category_en
FROM silver.products;