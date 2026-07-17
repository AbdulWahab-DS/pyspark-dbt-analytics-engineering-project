{{
    config(
        materialized = 'incremental',
        unique_key = 'trip_id'
    )
}}

{% set cols = ['trip_id', 'vehicle_id', 'customer_id','driver_id', 'trip_start_time','trip_end_time','start_location', 'end_location','distance_km', 'fare_amount', 'last_updated_timestamp']%}
select
    {% for col in cols %}

        {{col}}
        {% if not loop.last %}
            ,
        {% endif %}
    {% endfor %}

from
{{source("source_bronze", "trips")}}

{% if is_incremental() %}
    
where last_updated_timestamp > (select coalesce(max(last_updated_timestamp),'1900') from {{this}} )

{% endif %}