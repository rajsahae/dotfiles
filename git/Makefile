LOCAL_GITCONFIG = $(shell pwd)/gitconfig
TGT_GITCONFIG   := $(HOME)/.gitconfig

.PHONY: install
install:
	rm -f $(TGT_GITCONFIG)
	ln -svf $(LOCAL_GITCONFIG) $(TGT_GITCONFIG)

.PHONY: clean
clean:
	rm -f $(TGT_GITCONFIG)
