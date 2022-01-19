PROJECT="example"
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=main
BINARY_UNIX=$(BINARY_NAME)_unix
BINARY_WIN=$(BINARY_NAME)_win.exe
BUILD_MAC=${BINARY_NAME}_mac
default:
	@echo ${PROJECT}
	python --version

gitstatus:
	git status

node-v:
	node -v

run:
	go run main.go


# 三端编译
cross_build: build_windows build-linux build_mac
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GOBUILD) -o $(BINARY_UNIX) -v

build_windows:
	CGO_ENABLED=1 GOOS=windows GOARCH=amd64 $(GOBUILD) -o $(BINARY_WIN) -v

build_mac:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 $(GOBUILD) -o $(BUILD_MAC) -v




exec_win:
	@./main_win.exe