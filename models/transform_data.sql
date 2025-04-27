-- models/transform_data.sql

with raw as (
    select *
    from {{ source('raw_data', 'raw_flats') }}
    where price > 0
)

select
    row_number() over () as id,
    {{ round_price('price') }} as rounded_price,
    city as address,  -- Заменил 'address' на 'city'
    {{ detect_property_type('city') }} as property_type,  -- Здесь исправил: передаю 'city', а не 'address'
    date as standardized_date,  -- Просто оставляем как есть, без обработки
    sqm as area,  -- Заменил 'area' на 'sqm'
    rooms
from raw
