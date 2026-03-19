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

## Contributing

Install [uv](https://docs.astral.sh/uv/getting-started/installation/) and then install the dependencies:

```bash
uvx --from poethepoet poe install
```
