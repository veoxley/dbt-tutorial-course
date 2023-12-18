WITH

-- Aggregate measures
order_item_measures AS (
    SELECT
		order_id,
		SUM(item_sale_price) AS total_sale_price,
		SUM(product_cost) AS total_product_cost,
		SUM(item_profit) AS total_profit,
		SUM(item_discount) AS total_discount,


		{# inline pivot with Jinja #}
		{# {% set departments = ['Men','Women'] %} --setting department list
		   {% for department in departments %}
		#}

		--selecting column values to pivot. Much more flexible
		{% for department in dbt_utils.get_column_values(table=ref('int_ecommerce__order_items_products'),column='product_department') %}
		SUM(IF(product_department = '{{ department }}', item_sales_price, 0)) AS total_sold_{{ department.lower() }}swear{{ "," if not loop.last }}
		{% endfor %}

    FROM {{ ref('int_ecommerce__order_items_products')}}
    GROUP BY 1
)

SELECT
    -- Data from staging orders table
	od.order_id,
	od.created_at AS order_created_at,
	{{ is_weekend( 'od.created_at') }} AS order_was_created_on_weekend,
	od.shipped_at AS order_shipped_at,
	{{ is_weekend( 'od.order_shipped_at') }} AS order_was_shipped_on_weekend,
	od.delivered_at AS order_delivered_at,
	od.returned_at AS order_returned_at,
	od.status AS order_status,
	od.num_items_ordered,

    -- Metrics on order level
	om.total_sale_price,
	om.total_product_cost,
	om.total_profit,
	om.total_discount,

	{% for department in departments %}
	om.total_sold_{{ department.lower() }}swear,
	{% endfor %}

	-- In practise we'd calculate this column in the model itself, but it's
	-- a good way to demonstrate how to use an ephemeral materialisation
	TIMESTAMP_DIFF(od.created_at, user_data.first_order_created_at, DAY) AS days_since_first_order

FROM {{ ref('stg_ecommerce__orders') }} AS od
LEFT JOIN order_item_measures AS om
    ON od.order_id = om.order_id
LEFT JOIN {{ ref('int_ecommerce__first_order_created') }} AS user_data
	ON user_data.user_id = od.user_id