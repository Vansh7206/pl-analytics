--Instead of writing that CASE WHEN points logic every time you need it, you write it once as a macro and call it anywhere like a function. 

{% macro calculate_points(result_col) %}
    case
        when {{ result_col }} = 'W' then 3
        when {{ result_col }} = 'D' then 1
        else 0
    end
{% endmacro %}