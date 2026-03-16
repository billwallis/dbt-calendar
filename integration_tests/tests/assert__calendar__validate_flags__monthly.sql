with calcs as (
    select
        year_month,
        count(*) as total_dates,
        sum(is_month_start) as number_of_month_starts,
        sum(is_month_end) as number_of_month_ends,
        max(day_of_month_number) as max_day_of_month_number
    from {{ ref("calendar") }}
    group by year_month
)

select *
from calcs
where number_of_month_starts != 1
   or number_of_month_ends != 1
   or not (total_dates between 28 and 31)
   or not (max_day_of_month_number between 28 and 31)
