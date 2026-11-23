-- Pagamentos tipados (regra #12).
-- Regra #8: os 3 registros 'not_defined' (todos com valor zero) são removidos.
-- Regra #9: os vouchers com valor zero são mantidos.
CREATE OR REPLACE TABLE silver.order_payments AS
SELECT
    order_id,
    CAST(payment_sequential AS INTEGER)   AS payment_sequential,
    payment_type,
    CAST(payment_installments AS INTEGER) AS payment_installments,
    CAST(payment_value AS DECIMAL(10, 2)) AS payment_value
FROM bronze.order_payments
WHERE payment_type <> 'not_defined';