INSTALL_DIRS = $(sort $(dir $(wildcard */)))

.PHONY: install
install:
	for dir in $(INSTALL_DIRS) ; do \
		$(MAKE) -C $$dir install ; \
	done


.PHONY: clean
clean:
	for dir in $(INSTALL_DIRS) ; do \
		$(MAKE) -C $$dir clean ; \
	done
