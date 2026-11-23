-- Pedidos com datas tipadas (regra #12).
-- Cancelados e pedidos sem data de entrega são mantidos: o filtro de negócio é feito na gold.
CREATE OR REPLACE TABLE silver.orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    CAST(order_purchase_timestamp AS TIMESTAMP)      AS order_purchase_timestamp,
    CAST(order_approved_at AS TIMESTAMP)             AS order_approved_at,
    CAST(order_delivered_carrier_date AS TIMESTAMP)  AS order_delivered_carrier_date,
    CAST(order_delivered_customer_date AS TIMESTAMP) AS order_delivered_customer_date,
    CAST(order_estimated_delivery_date AS DATE)      AS order_estimated_delivery_date
FROM bronze.orders;