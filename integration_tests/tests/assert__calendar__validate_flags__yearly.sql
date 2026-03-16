with calcs as (
    select
        year_number,
        count(*) as total_dates,
        sum(is_year_start) as number_of_year_starts,
        sum(is_year_end) as number_of_year_ends
    from {{ ref("calendar") }}
    group by year_number
)

select *
from calcs
where number_of_year_starts != 1
   or number_of_year_ends != 1
   or not (total_dates between 365 and 366)
