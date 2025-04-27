{% macro convert_currency(amount_column, rate) %}
    ({{ amount_column }} * {{ rate }})
{% endmacro %}
