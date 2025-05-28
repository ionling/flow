.PHONY: run
run:
	hugo server -D

.PHONY: clean
clean:
	rm -rf public resources
