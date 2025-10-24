hostname := gta
local_public_folder := ./public
remote_public_folder := ~/public_html

git_hash = $(shell git log -1 --pretty=format:"%h")

ifneq ($(shell git status --porcelain -- ./public),)
dirty_indicator := " (dirty)"
endif

all: build

deploy: build secure
	rsync -rp --exclude-from=".rsyncignore" "$(local_public_folder)/" "$(hostname):${remote_public_folder}/"

secure:
	find ./public -maxdepth 1 -type f -execdir chmod 644 '{}' \;
	chmod 711 ./public

build:
	echo $(git_hash)$(dirty_indicator) > $(local_public_folder)/VERSION
	@echo "Build complete"

preview:
	nohup open "http://localhost:8000" > /dev/null
	python3 -m http.server -d ./public 8000

.PHONY: all build deploy preview
