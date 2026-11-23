-- Itens de pedido com valores e datas tipados (regra #12).
CREATE OR REPLACE TABLE silver.order_items AS
SELECT
    order_id,
    CAST(order_item_id AS INTEGER)         AS order_item_id,
    product_id,
    seller_id,
    CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_date,
    CAST(price AS DECIMAL(10, 2))          AS price,
    CAST(freight_value AS DECIMAL(10, 2))  AS freight_value
FROM bronze.order_items;