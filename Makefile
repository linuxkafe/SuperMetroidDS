.PHONY: setup run test lint format build check doctor help

AES_LANGUAGE ?= unknown
AES_LINT ?= echo "No linter configured"
AES_TEST ?= echo "No tests configured"
AES_FORMAT ?= echo "No formatter configured"
AES_BUILD ?= echo "No build configured"
AES_RUN ?= echo "No run command configured"

export AES_LANGUAGE AES_LINT AES_TEST AES_FORMAT AES_BUILD AES_RUN

setup:
	@echo "Unknown language. Configure Makefile manually."

run:
	@$(AES_RUN)

test:
	@$(AES_TEST)

lint:
	@$(AES_LINT)

format:
	@$(AES_FORMAT)

build:
	@$(AES_BUILD)

check: docs-check

docs-check:
	@test -f docs/VISION.md && grep -q "Problem" docs/VISION.md
	@test -f docs/PERSONAS.md && grep -q "User" docs/PERSONAS.md
	@test -f docs/REQUIREMENTS.md && grep -q "Functional" docs/REQUIREMENTS.md
	@test -f docs/ROADMAP.md && grep -q "Roadmap" docs/ROADMAP.md

doctor:
	@echo "Language: $(AES_LANGUAGE) (generic)"

help:
	@echo "AES Commands: customize Makefile with your language tools"
