WITH src_addresses AS (
    SELECT * 
    FROM {{ source('postgres_public', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
        address_id
        , address
        , zipcode
        , state
        , country
    FROM src_addresses
    )

SELECT * FROM renamed_casted