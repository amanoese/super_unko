.PHONY: default
default: usage

.PHONY: usage
usage: ## Print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check
check: test lint ## Run tests and linter

.PHONY: lint
lint: ## Run linter
	./linter.sh all

.PHONY: test
test: ## Run tests
	docker-compose -f docker-compose-ci.yml run --rm ci_sh_5.0

.PHONY: clean
clean: ## Clear files
	$(RM) super_unko.tar.gz pkg/*.tmp

.PHONY: setup
setup: ## Setup super_unko, linter, formatter and coverage tools docker image
	docker-compose build
	docker-compose -f docker-compose-ci.yml build ci_sh_default
	docker-compose -f docker-compose-tools.yml build

.PHONY: setup-all
setup-all: ## Setup all docker images
	docker-compose build
	docker-compose -f docker-compose-ci.yml build
	docker-compose -f docker-compose-tools.yml build

.PHONY: test-bash-version
test-bash-version: ## Run tests all bash version
	docker-compose -f docker-compose-ci.yml up

.PHONY: coverage
coverage: ## Report test coverage
	docker-compose -f docker-compose-tools.yml run coverage
