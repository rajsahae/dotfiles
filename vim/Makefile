LOCAL_VIMDIR = $(shell pwd)
LOCAL_VIMRC  = $(LOCAL_VIMDIR)/vimrc
TGT_VIMRC    := $(HOME)/.vimrc
TGT_VIMDIR   := $(HOME)/.vim
TGT_VIMSWAPS := $(HOME)/.vimswaps

.PHONY: install
install:
	rm -f $(TGT_VIMDIR) $(TGT_VIMRC)
	rm -rf $(TGT_VIMSWAPS)
	ln -svf $(LOCAL_VIMDIR) $(TGT_VIMDIR)
	ln -svf $(LOCAL_VIMRC) $(TGT_VIMRC)
	mkdir -p $(TGT_VIMSWAPS)

.PHONY: clean
clean:
	rm -rf $(TGT_VIMDIR) $(TGT_VIMRC) $(TGT_VIMSWAPS)
