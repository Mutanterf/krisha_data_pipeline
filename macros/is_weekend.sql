{% macro is_weekend(date_column) %}
    case
        when extract(dow from to_date({{ date_column }}, 'YYYY-MM-DD')) in (0, 6) then true
        else false
end
{% endmacro %}
