-- models/final_model.sql

select *
from {{ ref('transform_data') }}
