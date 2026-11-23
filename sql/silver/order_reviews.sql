-- Regra #1: uma avaliação por pedido, a mais recente.
-- O review_id no ORDER BY desempata respostas no mesmo horário, garantindo resultado determinístico.
-- Os textos dos comentários não são usados nas análises e ficaram fora da silver.
CREATE OR REPLACE TABLE silver.order_reviews AS
SELECT
    order_id,
    review_id,
    CAST(review_score AS INTEGER)              AS review_score,
    CAST(review_creation_date AS TIMESTAMP)    AS review_creation_date,
    CAST(review_answer_timestamp AS TIMESTAMP) AS review_answer_timestamp
FROM bronze.order_reviews
QUALIFY row_number() OVER (
    PARTITION BY order_id
    ORDER BY CAST(review_answer_timestamp AS TIMESTAMP) DESC, review_id
) = 1;