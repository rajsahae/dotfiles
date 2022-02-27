.PHONY: install
install:
	$(MAKE) -C git install
	$(MAKE) -C vim install


.PHONY: clean
clean:
	$(MAKE) -C git clean
	$(MAKE) -C vim clean
