{{ config(enabled=false) }}
{# Still deciding how to repesent some week details #}

with calcs as (
    select
        year_week,
        count(*) as total_dates,
        /* These flags don't exist yet, especially since week could start on Sun or Mon */
        sum(is_week_start) as number_of_week_starts,
        sum(is_week_end) as number_of_week_ends
    from {{ ref("calendar") }}
    group by year_week
)

select *
from calcs
where number_of_week_starts != 1
   or number_of_week_ends != 1
   or total_dates != 7
