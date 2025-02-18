hostname := theta01.scs.carleton.ca
local_public_folder := ./public
remote_public_folder := ~/public_html

git_hash = $(shell git log -1 --pretty=format:"%h")

ifneq ($(shell git status --porcelain -- ./public),)
dirty_indicator := " (dirty)"
endif

all: build

deploy: build secure
	rsync -rp --exclude-from=".rsyncignore" --delete "$(local_public_folder)/" "$(hostname):${remote_public_folder}/"

secure:
	find ./public -type f -execdir chmod 644 '{}' \;
	find ./public -mindepth 1 -type d -execdir chmod 711 '{}' \;

build:
	echo $(git_hash)$(dirty_indicator) > $(local_public_folder)/VERSION
	@echo "Build complete"

.PHONY: all build deploy
