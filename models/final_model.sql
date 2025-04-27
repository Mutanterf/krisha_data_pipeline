-- models/final_model.sql

select
    id,
    rounded_price,
    address,
    standardized_date,
    area,
    rooms
from {{ ref('transform_data') }}
where rounded_price is not null
  and address is not null
  and standardized_date is not null
  and area is not null
  and rooms is not null
