/* DuckDB */
with

latest_daylight_savings as (
    from (
        select
            division,
            unnest(events.events, recursive:=true)
        from (
            unpivot 'https://www.gov.uk/when-do-the-clocks-change.json'
            on "united-kingdom"
            into
                name division
                value events
        )
    )
    select
        "date" as date_nk,
        division as region,
        title,
        nullif(notes, '') as notes,
)

    select date_nk, region, title, notes from 'seeds/tmp_daylight_savings.csv'
union
    select date_nk, region, title, notes from latest_daylight_savings
order by date_nk, region
