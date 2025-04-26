
  
    

  create  table "krisha_data"."public"."transform_data__dbt_tmp"
  
  
    as
  
  (
    -- models/transform_data.sql

select *
from "krisha_data"."public"."raw_data"
where price > 0
  );
  