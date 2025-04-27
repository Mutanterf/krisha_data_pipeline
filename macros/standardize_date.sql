{% macro standardize_date(date_column) %}
    case
        when {{ date_column }} ~ '^\d{4}-\d{2}-\d{2}$' then to_date({{ date_column }}, 'YYYY-MM-DD')
        else null
end
{% endmacro %}
