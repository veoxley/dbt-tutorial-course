--run-operation is how you call a macro of functionality by itself

--generate_base_model uses a defined Source and Table to genenerate the SQL for the table specified
    --in this example generate_base_model is being reformated by macro_generate_base_table
    --dbt_packages/codgen/macros/generate_base_model
dbt run-operation generate_base_model --args '{"source_name": "thelook_ecommerce", "table_name": "orders"}'



--generatgenerate_model_yaml is going to check what columns exist and create a template yaml file
    --dbt_packages/codgen/macros/generate_model_yaml
dbt run-operation generate_model_yaml --args '{"model_names": ["stg_ecommerce__orders"]}'


--***************
-- the "|" character allows for more than one dbt command to be run
-- example: dbt docs generate | dbt docs serve
--***************


--https://docs.getdbt.com/docs/core/connect-data-platform/connection-profiles

--run dbt based on a non-default profile
dbt run --project-dir . --profiles-dir ./dbt_cloud_profiles -s stg_ecommerce__products --full-refresh

--=======================================================================
--+++++++++++ These can be used with dbt run / test / build ++++++++++++
--=======================================================================
--https://docs.getdbt.com/reference/node-selection/graph-operators


--runs everything downstream for stg_ecommerce__order_items
dbt run -s stg_ecommerce__order_items+

--runs everything downstream for stg_ecommerce__order_items and explicitly running stg_ecommerce__products
dbt run -s stg_ecommerce__order_items+ stg_ecommerce__products

--runs everything for stg_ecommerce__order_items, all parents, all children, and all parents of children
dbt run -s "@stg_ecommerce__order_items"

--runs everything for stg_ecommerce__order_items, all parents, all children
dbt run -s +stg_ecommerce__order_items+

-- This will test everything in the staging folder
dbt test -s path:models/staging

-- This will test everything in the staging folder and everthing downstream
dbt test -s path:models/staging+


--=======================================================================
--=======================================================================
--https://docs.getdbt.com/reference/resource-configs/tags

--run models based on thier tags
dbt run -s tag:my_other_tag


--https://docs.getdbt.com/reference/node-selection/test-selection-examples

-- runs all tests on stg_ecommerce__order_items but will not refresh data in other models if refernced in test
dbt test -s stg_ecommerce__order_items

-- runs all tests on stg_ecommerce__order_items that do not depend on other models
dbt test -s stg_ecommerce__order_items --indirect-selection=cautious


--runs a test and overrides all warnings with error, this works with dbt build as well
-- use case: run once a week to catch and correct all errors
dbt --warn-error test -s stg_ecommerce__order_items


--=Documentation==

--creates docs based on descriptions and makes it availaile via web
    --process "generate" takes the target/manifest.json to build target\catalog.json file which is our documentation in json form
    --process "serve" is going to host those documents locally. http://localhost:8080
        --target/index.html is created using target\catalog.json for us (to be hosted)
dbt docs generate | dbt docs serve