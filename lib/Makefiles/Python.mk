SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

env_name="lambda"

python-env.deactivate:
> @deactivate

python-env.activate:
> @source "${env_name}/bin/activate"

init-python-env:
> @python3 -m venv "${env_name}"
> @source "${env_name}/bin/activate" && python3 -m pip install boto3

tests:
> @python -m unittest main_test.py
