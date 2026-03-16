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

This is similar to [calogica/dbt-date](https://github.com/calogica/dbt-date), except the date attributes are primarily exposed as database objects rather than macros.

## Contributing

Install [uv](https://docs.astral.sh/uv/getting-started/installation/) and then install the dependencies:

```bash
uvx --from poethepoet poe install
```
