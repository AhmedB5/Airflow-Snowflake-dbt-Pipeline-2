{% macro handle_blank_auto(column_name) %}

CASE
    WHEN {{ column_name }} IS NULL OR TRIM({{ column_name }}) = '' THEN
        CASE 
            WHEN TRY_CAST({{ column_name }} AS FLOAT) IS NOT NULL THEN 'N/A' 
            ELSE 'unknown'
        END
    ELSE {{ column_name }}
END

{% endmacro %}

