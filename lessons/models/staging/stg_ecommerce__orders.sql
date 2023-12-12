WITH source AS (
    SELECT *

    FROM {{ source('thelook_ecommerce', 'orders') }}
)

SELECT
    --IDs
    order_id,
    user_id,

    -- Timestamp
    created_at,
    returned_at,
    shipped_at,
    delivered_at,

    --Other Columns
    status,
    num_of_item AS num_of_items_ordered

    --Unused Columns
        --gender,

FROM source