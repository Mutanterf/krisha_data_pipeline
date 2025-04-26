-- models/raw_data.sql

select *
from {{ source('raw_data','raw_flats') }}
where price is not null
