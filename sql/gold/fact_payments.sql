-- Fato de pagamentos. Grão: um pagamento (um pedido pode ter vários).
-- Regra #4: is_valid_sale permite filtrar pedidos cancelados ou indisponíveis.

CREATE OR REPLACE TABLE gold.fact_payments AS
SELECT
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    o.order_status NOT IN ('canceled', 'unavailable') AS is_valid_sale
FROM silver.order_payments AS p
INNER JOIN silver.orders AS o
    ON p.order_id = o.order_id;