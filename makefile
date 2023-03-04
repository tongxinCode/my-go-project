PROJECTNAME=$(shell basename "$(PWD)")

# Go related variables.
GOBASE=$(shell pwd)
GOBIN=$(GOBASE)/bin
GOFILES=$(GOBASE)/cmd/$(PROJECTNAME)/$(wildcard *.go)

# Redirect error output to a file, so we can show it in development mode.
STDERR=/tmp/.$(PROJECTNAME)-stderr.txt

# PID file will store the server process id when it's running on development mode
PID=/tmp/.$(PROJECTNAME).pid

# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

build:
	@echo "  >  Building binary..."
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go build -o $(GOBIN)/$(PROJECTNAME) $(GOFILES)
	@echo "  >  $(PROJECTNAME) is available at $(GOBIN)"

run: clean build
	@-$(GOBIN)/$(PROJECTNAME) 2>&1 & echo $$! > $(PID)
	@cat $(PID) | sed "/^/s/^/  \>  PID: /"

start: clean build
	@-$(GOBIN)/$(PROJECTNAME) & echo $$! > $(PID)
	@cat $(PID) | sed "/^/s/^/  \>  PID: /"

clean:
	@echo "  >  Cleaning build cache"
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go clean
	@rm -rf bin/*

install:
	@GOPATH=$(GOPATH) GOBIN=$(GOBIN) go install $(GOFILES)

.PHONY: build
