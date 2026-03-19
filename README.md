<span align="center">

[![Python](https://img.shields.io/badge/Python-3.13+-blue.svg)](https://www.python.org/downloads/)
[![uv](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json)](https://github.com/astral-sh/uv)
[![tests](https://github.com/billwallis/dbt-calendar/actions/workflows/tests.yaml/badge.svg)](https://github.com/billwallis/dbt-calendar/actions/workflows/tests.yaml)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/billwallis/dbt-calendar/main.svg)](https://results.pre-commit.ci/latest/github/billwallis/dbt-calendar/main)
[![GitHub last commit](https://img.shields.io/github/last-commit/billwallis/dbt-calendar)](https://shields.io/badges/git-hub-last-commit)

</span>

---

# dbt Calendar

A calendar data model for dbt projects.

This is similar to [godatadriven/dbt-date](https://github.com/godatadriven/dbt-date) (previously [calogica/dbt-date](https://github.com/calogica/dbt-date)), except the date attributes are primarily exposed as database objects rather than macros.

## Usage

Add to your `packages.yml`:

```yaml
packages:
  - git: "https://github.com/billwallis/dbt-calendar"
    revision: v0.0.1
```

Run `dbt seed` to load the models. By default, the models will go into the `dbt_calendar` schema (or whatever dev equivalent you have configured). You can change the schema using the `+schema` parameter in the `dbt_project.yml` file's `seeds` config:

```yaml
# dbt_project.yml
seeds:
  dbt_calendar:
    +schema: custom_schema
```

## Models

This package exposes the following models:

<div align="center">
  <a href="https://dbdiagram.io/home">
    <img
        src="docs/data-model.png"
        alt="data model for dbt-calendar"
        width=500
    />
  </a>
</div>

<details>
<summary>Expand for corresponding <a href="https://dbml.dbdiagram.io/home">DBML</a></summary>

```dbml
Table calendar {
  date_nk date [not null, primary key]
}

Table bank_holidays {
  date_nk date [not null, ref: > calendar.date_nk]
  region varchar [not null]

  indexes {
    (date_nk, region) [pk]
  }
}
```

</details>

### Example usage

The motivation behind this package is to avoid Jinja macros for date generation, and instead use "normal" tables.

The existing attributes can be found in the seeds' schema file:

- https://raw.githubusercontent.com/billwallis/dbt-calendar/refs/heads/main/seeds/_schema.yml

Additionally, you may want to define your own date dimension model(s) on top of this package augmented with date attributes that your business cares about.

#### Create a daily date spine for 2026

```sql
date_spine as (
    select date_nk
    from {{ ref("dbt_calendar", "calendar") }}
    where date_nk >= '2026-01-01' and date_nk < '2027-01-01'
)
```

#### Create a monthly date spine for 2020 to 2029

```sql
date_spine as (
    select
        date_nk as month_starting_date,
        month_name,
        month_name_abbr
    from {{ ref("dbt_calendar", "calendar") }}
    where date_nk >= '2020-01-01' and date_nk < '2030-01-01'
      and is_month_start
)
```

#### Add date attributes to an existing date spine

```sql
select
    date_spine.date_nk,
    calendar.day_of_year_number,  /* AKA Julian day */
    calendar.day_name,
    calendar.day_name_abbr,
    calendar.is_weekday,
from date_spine
    left join {{ ref("dbt_calendar", "calendar") }} as calendar
        on date_spine.date_nk = calendar.date_nk
```

## Contributing

Install [uv](https://docs.astral.sh/uv/getting-started/installation/) and then install the dependencies:

```bash
uvx --from poethepoet poe install
```
