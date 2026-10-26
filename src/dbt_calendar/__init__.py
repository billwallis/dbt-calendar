import os
import pathlib
import shutil

import duckdb

HERE = pathlib.Path(__file__).parent
PROJECT_ROOT = HERE.parent.parent  # dbt-calendar/


def _read_query(query_name: str) -> str:
    return (HERE / query_name).read_text(encoding="utf-8")


def _to_csv(query: str, destination: pathlib.Path) -> None:
    sql = "copy ({query}) to '{destination}' (header, delimiter ',')"
    duckdb.sql(sql.format(query=query, destination=str(destination.resolve())))


def _to_incremental_csv(model_name: str) -> None:
    # TODO: Do something better here, this feels bleh
    shutil.move(
        PROJECT_ROOT / f"seeds/{model_name}.csv",
        PROJECT_ROOT / f"seeds/tmp_{model_name}.csv",
    )
    _to_csv(
        query=_read_query(f"{model_name}.sql"),
        destination=PROJECT_ROOT / f"seeds/{model_name}.csv",
    )
    os.unlink(PROJECT_ROOT / f"seeds/tmp_{model_name}.csv")


def sql_to_csv() -> None:
    _to_csv(
        query=_read_query("calendar.sql"),
        destination=PROJECT_ROOT / "seeds/calendar.csv",
    )
    _to_incremental_csv("bank_holidays")
    _to_incremental_csv("daylight_savings")
