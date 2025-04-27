-- macros/detect_property_type.sql

{% macro detect_property_type(city_column) %}
    case
        when lower({{ city_column }}) like '%дом%' then 'house'
        when lower({{ city_column }}) like '%квартира%' then 'flat'
        else 'unknown'
end
{% endmacro %}
