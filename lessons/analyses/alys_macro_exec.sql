--run-operation is how you call a macro of functionality by itself

--generate_base_model uses a defined Source and Table to genenerate the SQL for the table specified
    --in this example generate_base_model is being reformated by macro_generate_base_table
    --dbt_packages/codgen/macros/generate_base_model
dbt run-operation generate_base_model --args '{"source_name": "thelook_ecommerce", "table_name": "orders"}'



--generatgenerate_model_yaml is going to check what columns exist and create a template yaml file
    --dbt_packages/codgen/macros/generate_model_yaml
dbt run-operation generate_model_yaml --args '{"model_names": ["stg_ecommerce__orders"]}'