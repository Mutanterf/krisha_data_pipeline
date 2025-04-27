
  
    

  create  table "krisha_data"."public"."final_model__dbt_tmp"
  
  
    as
  
  (
    -- models/final_model.sql

select
    id,
    rounded_price,
    address,
    standardized_date,
    area,
    rooms
from "krisha_data"."public"."transform_data"
where rounded_price is not null
  and address is not null
  and standardized_date is not null
  and area is not null
  and rooms is not null
  );
  