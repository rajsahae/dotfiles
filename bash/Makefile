LOCAL_BASHRC  = $(shell pwd)/bashrc
LOCAL_ALIASES = $(shell pwd)/bash_aliases
TGT_BASHRC    = $(HOME)/.bashrc
TGT_ALIASES   = $(HOME)/.bash_aliases

.PHONY: install
install:
	rm -f $(TGT_BASHRC) $(TGT_ALIASES)
	ln -svf $(LOCAL_BASHRC) $(TGT_BASHRC)
	ln -svf $(LOCAL_ALIASES) $(TGT_ALIASES)

.PHONY: clean
clean:
	rm -f $(TGT_BASHRC) $(TGT_ALIASES)
