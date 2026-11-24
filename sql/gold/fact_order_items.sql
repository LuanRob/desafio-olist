-- fato de item vendidos. Grão: um item de pedidos (order_id + order_item_id)
-- Regra #4: is_valid_sale é falso para pedidos cancelados ou indisponiveis.
-- Receita = price (valor do produro) . O frete fica em coluna separada.

CREATE OR REPLACE TABLE gold.fact_order_items AS
SELECT
    i.order_id,
    i.order_item_id,
    i.product_id,
    i.seller_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    CAST(date_trunc('month', o.order_purchase_timestamp) AS DATE) AS order_month,
    o.order_status NOT IN ('canceled', 'unavailable')             AS is_valid_sale,
    i.price,
    i.freight_value
FROM silver.order_items AS i
INNER JOIN silver.orders AS o
    ON i.order_id = o.order_id;