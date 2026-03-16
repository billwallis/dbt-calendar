/* DuckDB */
select
    date_::date as date_nk,
    strftime(date_nk, '%Y%m%d')::integer as date_id,
    strftime(date_nk, '%Y%j')::integer as ordinal_date,
    (strftime(date_nk, '%Y0') || extract('quarter' from date_nk))::integer as year_quarter,
    strftime(date_nk, '%Y%m')::integer as year_month,
    extract('yearweek' from date_nk)::integer as year_week,
    -- strftime(date_nk, '%j')::integer as year_day,  /* Same as `day_of_year_number` */
    extract('year' from date_nk)::integer as year_number,
    extract('quarter' from date_nk)::integer as quarter_number,
    extract('month' from date_nk)::integer as month_number,
    extract('week' from date_nk)::integer as week_number,

    /* Which of these should we use?  https://duckdb.org/docs/stable/sql/functions/dateformat#format-specifiers */
    -- strftime(date_nk, '%W')::integer,
    -- strftime(date_nk, '%U')::integer,

    extract('dayofyear' from date_nk)::integer as day_of_year_number,  /* AKA Julian day */
    extract('dayofmonth' from date_nk)::integer as day_of_month_number,
    extract('dayofweek' from date_nk)::integer as day_of_week_number,
    dayname(date_nk) as day_name,
    dayname(date_nk)[:3] as day_name_abbr,
    monthname(date_nk) as month_name,
    monthname(date_nk)[:3] as month_name_abbr,
    date_nk = date_trunc('month', date_nk) as is_month_start,
    date_nk = date_trunc('month', date_nk) + interval '1 month' - interval '1 day' as is_month_end,
    date_nk = date_trunc('quarter', date_nk) as is_quarter_start,
    date_nk = date_trunc('quarter', date_nk) + interval '3 months' - interval '1 day' as is_quarter_end,
    date_nk = date_trunc('year', date_nk) as is_year_start,
    date_nk = date_trunc('year', date_nk) + interval '1 year' - interval '1 day' as is_year_end,
    year_number % 4 = 0 as is_leap_year,
    extract('dow' from date_nk) between 1 and 5 as is_day_weekday,
from generate_series(
    '1980-01-01'::date,
    '2079-12-31'::date,
    interval '1 day'
) as gen(date_)
