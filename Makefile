flowclock:
	elm-make FlowClock.elm --output flowclock.html

.PHONY: build
build:
	docker build -t flowclock .
