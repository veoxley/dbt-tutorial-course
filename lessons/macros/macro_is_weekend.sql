{%- macro is_weekend(date_column) -%}
    EXTRACT(DAYOFWEEK FROM DATE({{ date_column }})) IN (1,7)
{%- endmacro -%}

{# used in inline SQL, like scalar function #}
{# example: {{ is_weekend( 'od.created_at') }} AS order_was_created_on_weekend, #}