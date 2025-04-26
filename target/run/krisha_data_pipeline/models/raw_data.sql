
  
    

  create  table "krisha_data"."public"."raw_data__dbt_tmp"
  
  
    as
  
  (
    -- models/raw_data.sql

select *
from "krisha_data"."public"."raw_flats"
where price is not null
  );
  