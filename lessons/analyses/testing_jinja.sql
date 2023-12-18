
---may look here, before creating custom function to see if it exists
--https://docs.getdbt.com/reference/dbt-jinja-functions

{# jinja comment: won't appear in compiled SQL
    command: ctrl + /
#}

{# set variable #}
{%- set my_long_variable -%}
    SELECT 1 AS my_col
{%- endset -%}

{# Evaluate Expresstion #}
{{ my_long_variable }}

{# set inline variable #}
{% set my_list = ['user_id','created_at'] %}

{# minus "-" signs used throughout are for triming blank lines in output #}
SELECT
{# iterate through list #}
{%- for i in my_list -%}
            {# if statement, loop.last is as special operator
                this puts commas at the end of each line unless
                it is last in the list
             #}
    {{ i }}{%- if not loop.last %},{%- endif %}
{% endfor %}

{# Evaluate Expresstion #}
{{ my_list }}




{# ==================================================================== #}
                            {# useful functions #}
{# ==================================================================== #}

{# ============ adapter.get_columns_in_relation ================================#}
{# Get all columns in a table #}
{% set columns = adapter.get_columns_in_relation(ref('orders')) %}

{# Get all columns in a table, check they start with 'total' #}
SELECT
{% for column in columns -%}
    {#- column.name is BigQuery specific #}
    {#- .startswith and .upper are python methods #}
	{%- if column.name.startswith('total') %}
	{{ column.name.upper() }},
	{%- endif -%}
{%- endfor %}

{# ============ dbt_utils.get_column_values ================================#}
{# Get all distinct values from a column in a table and return them in a list #}
{% set values = dbt_utils.get_column_values(ref('orders'), 'order_status') %}

{{ values }}


{# ==================================================================== #}
                            {# useful functions #}
{# ==================================================================== #}