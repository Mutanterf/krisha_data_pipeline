-- macros/round_price.sql

{% macro round_price(price_column) %}
    round(cast({{ price_column }} as numeric), -3)
{% endmacro %}
