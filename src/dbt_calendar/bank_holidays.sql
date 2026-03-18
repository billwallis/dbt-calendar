/* DuckDB */
with

latest_bank_holidays as (
    from (
        select
            division,
            unnest(events.events, recursive:=true)
        from (
            unpivot 'https://www.gov.uk/bank-holidays.json'
            on "england-and-wales", "scotland", "northern-ireland"
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

    select date_nk, region, title, notes from 'seeds/tmp_bank_holidays.csv'
union
    select date_nk, region, title, notes from latest_bank_holidays
order by date_nk, region
