TESTS_INIT := tests/minimal_init.lua
TESTS_DIR  := tests/

.PHONY: test lint format format-check

test:
	nvim --headless --noplugin -u $(TESTS_INIT) \
		-c "PlenaryBustedDirectory $(TESTS_DIR) { minimal_init = '$(TESTS_INIT)' }"

lint:
	luacheck lua plugin tests

format:
	stylua .

format-check:
	stylua --check .
