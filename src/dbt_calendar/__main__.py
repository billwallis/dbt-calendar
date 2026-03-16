import dbt_calendar


def main() -> int:
    dbt_calendar.sql_to_csv()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
