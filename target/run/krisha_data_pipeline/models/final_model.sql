
  
    

  create  table "krisha_data"."public"."final_model__dbt_tmp"
  
  
    as
  
  (
    -- models/final_model.sql

select *
from "krisha_data"."public"."transform_data"
  );
  