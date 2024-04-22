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
> @rm -fr __pycache__
> @rm -fr ${env_name}
> @rm -fr .coverage

python-env.activate:
> @source "${env_name}/bin/activate"

init-python-env:
> @python3 -m venv "${env_name}" && source "${env_name}/bin/activate" && python3 -m pip install boto3

tests:
> @python3 -m unittest main_test.py

coverage:
> @coverage run -m unittest main_test.py
> @coverage report
