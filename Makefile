TESTS_INIT := tests/minimal_init.lua
TESTS_DIR  := tests/

.PHONY: ci test lint format format-check

ci: format-check lint test

test:
	nvim --headless --noplugin -u $(TESTS_INIT) \
		-c "PlenaryBustedDirectory $(TESTS_DIR) { minimal_init = '$(TESTS_INIT)' }"

lint:
	luacheck lua plugin tests

format:
	stylua .

format-check:
	stylua --check .
