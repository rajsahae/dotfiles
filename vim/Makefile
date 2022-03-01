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
	sudo apt install build-essential cmake vim-nox python3-dev mono-complete golang nodejs default-jdk npm
	git submodule update --init --recursive
	cd $(LOCAL_VIMDIR)/bundle/youcompleteme && python3 install.py --all
	vim +PluginInstall +qall

.PHONY: clean
clean:
	rm -rf $(TGT_VIMDIR) $(TGT_VIMRC) $(TGT_VIMSWAPS)
