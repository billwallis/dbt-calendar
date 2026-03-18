"""
This script has been adapted from the dbt-core/dbt-utils repo:

- https://github.com/dbt-labs/dbt-utils/blob/main/run_test.sh
"""

import contextlib
import functools
import shlex
import shutil
from typing import Any

from dbt.cli.main import dbtRunner

# These are just for patching a dbt bug  (https://github.com/dbt-labs/dbt-core/issues/9719)
from dbt.deps.local import LocalPinnedPackage
from dbt.events.types import DepsCreatingLocalSymlink, DepsSymlinkNotAvailable
from dbt_common.clients import system
from dbt_common.events.functions import fire_event

SUCCESS = 0
FAILURE = 1
UNHANDLED_ERROR = 2
BLUE = "\033[1;34m"
END = "\033[0m"
TESTS_DIR = "./integration_tests"


def _patched_install(
    self: LocalPinnedPackage, project: Any, renderer: Any
) -> None:
    # Copy (mostly) of the fix proposed in https://github.com/dbt-labs/dbt-core/pull/9734
    src_path = self.resolve_path(project)
    dest_path = self.get_installation_path(project, renderer)

    if system.path_exists(dest_path):
        if not system.path_is_symlink(dest_path):
            system.rmdir(dest_path)
        else:
            system.remove_file(dest_path)
    try:
        fire_event(DepsCreatingLocalSymlink())
        system.make_symlink(src_path, dest_path)
    except OSError:
        fire_event(DepsSymlinkNotAvailable())
        try:
            shutil.copytree(
                src_path,
                dest_path,
                ignore=lambda directory, contents: (
                    project.packages_install_path
                    if directory == project.project_root
                    else []
                ),
            )
        except shutil.Error:
            pass


LocalPinnedPackage.install = _patched_install


def echo(text: str) -> None:
    print(f"{BLUE}{text}{END}")


@functools.cache
def dbt_runner() -> dbtRunner:
    return dbtRunner()


def run(cmd: str) -> int:
    args = shlex.split(cmd)[1:]
    run_result = dbt_runner().invoke(args)

    if run_result.success:
        return SUCCESS
    if run_result.exception is None:
        return FAILURE
    return UNHANDLED_ERROR


def main() -> int:
    ret_val = SUCCESS
    with contextlib.chdir(TESTS_DIR):
        echo("\ndbt version info")
        ret_val |= run("dbt --version")

        echo("\ndbt debug")
        ret_val |= run("dbt debug")

        echo("\ndbt deps")
        ret_val |= run("dbt deps")

        # build will seed, run, and test
        echo("\ndbt build")
        ret_val |= run("dbt build --full-refresh")

    return ret_val


if __name__ == "__main__":
    raise SystemExit(main())
