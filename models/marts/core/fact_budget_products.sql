WITH stg_budget_prodcuts AS (
    SELECT * 
    FROM {{ ref('stg_budget_products') }}
    ),

renamed_casted AS (
    SELECT
        product_id
        , month
        , quantity
        , date_load
    FROM stg_budget_products
    )

SELECT * FROM renamed_casted