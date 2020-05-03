all: format scrub lint docs test

lint: FORCE  ## Run flake8, mypy and black (in check mode)
	poetry run flake8
	poetry run mypy .
	poetry run black . --check

test: FORCE  ## Run pytest
	poetry run python -m pytest --cov=ergo --doctest-modules -s .

xtest: FORCE  ## Run pytest in parallel mode using xdist
	poetry run python -m pytest --cov=ergo -n auto --doctest-modules -s .

format: FORCE  ## Run isort and black (rewriting files)
	poetry run isort -rc .
	poetry run black .

docs: FORCE  ## Build docs
	poetry run $(MAKE) -C docs html

serve: FORCE  ## Run Jupyter notebook server
	poetry run python -m jupyter lab

scrub: FORCE  ## Scrub notebooks/src/.ipynb of output
	poetry run python scripts/scrub_notebooks.py notebooks/build notebooks/src

.PHONY: help

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

FORCE:
