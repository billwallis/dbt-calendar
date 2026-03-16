with calcs as (
    select
        min(date_nk) as min_date,
        max(date_nk) as max_date,
        1 + date_diff('days', min_date, max_date) as days_diff,
        count(*) as total_dates,
        count(distinct date_nk) as distinct_dates
    from {{ ref("calendar") }}
)

    select 'total_counts' as metric, *
    from calcs
    where total_dates != days_diff
       or total_dates != distinct_dates
union all
    select 'expected_dates' as metric, *
    from calcs
    where min_date != '1980-01-01'
       or max_date != '2079-12-31'
