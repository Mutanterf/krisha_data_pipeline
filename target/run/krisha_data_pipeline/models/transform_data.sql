
  
    

  create  table "krisha_data"."public"."transform_data__dbt_tmp"
  
  
    as
  
  (
    -- models/transform_data.sql

with raw as (
    select *
    from "krisha_data"."public"."raw_flats"
    where price > 0
)

select
    row_number() over () as id,
    
    round(cast(price as numeric), -3)
 as rounded_price,
    city as address,  -- Заменил 'address' на 'city'
    
    case
        when lower(city) like '%дом%' then 'house'
        when lower(city) like '%квартира%' then 'flat'
        else 'unknown'
end
 as property_type,  -- Здесь исправил: передаю 'city', а не 'address'
    date as standardized_date,  -- Просто оставляем как есть, без обработки
    sqm as area,  -- Заменил 'area' на 'sqm'
    rooms
from raw
  );
  