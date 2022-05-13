{% macro clone_stage(stages=None) %}

  -- If stage parameter not set, infer current target. Will not run on prod
  {% if stages == None %}
    {% if target.name == "DBT_PROD" %}
      {{ exceptions.raise_compiler_error("Cannot clone using the rod profile") }}
    {% endif %}

    {% set stages = [target.name] %}

  {% endif %}

  {% for stage in stages %}
    {{ log("Cloning prod to " ~ stage, info=True) }}
    {{ log("Clone in progress...", info=True) }}

    {% call statement('clone', fetch_result=False) %}
      CREATE OR REPLACE DATABASE {{ stage }} CLONE DBT_PROD;
      GRANT USAGE ON DATABASE {{ stage }} TO ROLE DBT_ROLE;
    {%- endcall %}

  {% endfor %}

{% endmacro %}