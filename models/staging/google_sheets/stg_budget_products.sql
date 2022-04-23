WITH src_budget_products AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
        _row
        , product_id
        , quantity
        , month
    FROM src_budget_products
    )

SELECT * FROM renamed_casted