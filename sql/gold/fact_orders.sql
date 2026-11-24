-- Fato de pedidos com métricas de entrega. Grão: um pedido.
-- É a tabela derivada pedida no desafio: prazo de entrega e atraso em dias.
-- Regra #5: as métricas de entrega só são calculadas para pedidos 'delivered' com data de entrega.
-- delay_days positivo = dias de atraso; negativo = entregue antes do prazo estimado.

CREATE OR REPLACE TABLE gold.fact_orders AS
WITH items AS (
    SELECT
        order_id,
        count(*)           AS items_qty,
        sum(price)         AS order_value,
        sum(freight_value) AS freight_value
    FROM silver.order_items
    GROUP BY order_id
),

deliveries AS (
    SELECT
        order_id,
        CASE
            WHEN order_status = 'delivered'
                THEN CAST(order_delivered_customer_date AS DATE)
        END AS delivered_date
    FROM silver.orders
)

SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_status,
    o.order_status NOT IN ('canceled', 'unavailable') AS is_valid_sale,
    o.order_purchase_timestamp,
    d.delivered_date,
    o.order_estimated_delivery_date,
    coalesce(i.items_qty, 0) AS items_qty,
    i.order_value,
    i.freight_value,
    r.review_score,
    date_diff('day', CAST(o.order_purchase_timestamp AS DATE), d.delivered_date) AS delivery_days,
    date_diff('day', o.order_estimated_delivery_date, d.delivered_date)          AS delay_days,
    d.delivered_date > o.order_estimated_delivery_date                           AS is_late
FROM silver.orders AS o
INNER JOIN silver.customers AS c
    ON o.customer_id = c.customer_id
INNER JOIN deliveries AS d
    ON o.order_id = d.order_id
LEFT JOIN items AS i
    ON o.order_id = i.order_id
LEFT JOIN silver.order_reviews AS r
    ON o.order_id = r.order_id;