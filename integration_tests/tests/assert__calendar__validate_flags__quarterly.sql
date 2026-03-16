with calcs as (
    select
        year_quarter,
        count(*) as total_dates,
        sum(is_quarter_start) as number_of_quarter_starts,
        sum(is_quarter_end) as number_of_quarter_ends
    from {{ ref("calendar") }}
    group by year_quarter
)

select *
from calcs
where number_of_quarter_starts != 1
   or number_of_quarter_ends != 1
   or not (total_dates between 89 and 92)
