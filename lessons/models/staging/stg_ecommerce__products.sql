--Tag example: can be done on a file level or project level (example in dbt_project.yml on intermediate)
{{ config(tags = ['my_tag']) }}

WITH source AS (
	SELECT *

	FROM {{ source('thelook_ecommerce', 'products') }}
)

SELECT
	-- IDs
	id AS product_id,

	-- Other columns
	cost,
	retail_price,
	department,
	brand -- new column added in v2

	{#- Unused columns:
		- inventory_item_id
		- distribution_center_id
		- category
		- sku
		- name
	#}

FROM source
