-- Produtos com categoria traduzida.
-- Regra #2: categoria nula vira 'sem_categoria'.
-- Regra #3: duas categorias sem tradução na origem são traduzidas manualmente.
-- Regra #11: correção do erro de digitação 'lenght' nos nomes das colunas.


CREATE OR REPLACE TABLE silver.products AS
SELECT
    p.product_id,
    coalesce(p.product_category_name, 'sem_categoria') AS product_category_name,
    coalesce(
        t.product_category_name_english,
        CASE p.product_category_name
            WHEN 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'portable_kitchen_and_food_preparers'
            WHEN 'pc_gamer' THEN 'pc_gamer'
        END,
        'uncategorized'
    ) AS product_category_name_english,
    CAST(p.product_name_lenght AS INTEGER)        AS product_name_length,
    CAST(p.product_description_lenght AS INTEGER) AS product_description_length,
    CAST(p.product_photos_qty AS INTEGER)         AS product_photos_qty,
    CAST(p.product_weight_g AS INTEGER)           AS product_weight_g,
    CAST(p.product_length_cm AS INTEGER)          AS product_length_cm,
    CAST(p.product_height_cm AS INTEGER)          AS product_height_cm,
    CAST(p.product_width_cm AS INTEGER)           AS product_width_cm
FROM bronze.products AS p
LEFT JOIN bronze.category_translation AS t
    ON p.product_category_name = t.product_category_name;