import pathlib
import textwrap

import duckdb

HERE = pathlib.Path(__file__).parent
PROJECT_ROOT = HERE.parent.parent  # dbt-calendar/


def _read_query(query_name: str) -> str:
    return (HERE / query_name).read_text(encoding="utf-8")


def _to_csv(query: str, destination: pathlib.Path) -> None:
    sql = textwrap.dedent(
        """
        copy (
            {query}
        )
        to '{destination}' (header, delimiter ',')
        """
    )
    duckdb.sql(sql.format(query=query, destination=str(destination.resolve())))


def sql_to_csv() -> None:
    _to_csv(
        query=_read_query("calendar.sql"),
        destination=PROJECT_ROOT / "seeds/calendar.csv",
    )
