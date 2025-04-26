-- models/transform_data.sql

select *
from {{ ref('raw_data') }}
where price > 0
