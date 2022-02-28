LOCAL_NVIM_INIT  = $(shell pwd)/init.vim
TGT_NVIM_CFG_DIR = $(HOME)/.config/nvim
TGT_NVIM_INIT    = $(TGT_NVIM_CFG_DIR)/init.vim

.PHONY: install
install:
	rm -rf $(TGT_NVIM_CFG_DIR)
	mkdir -p $(TGT_NVIM_CFG_DIR)
	ln -svf $(LOCAL_NVIM_INIT) $(TGT_NVIM_INIT)

.PHONY: clean
clean:
	rm -rf $(TGT_NVIM_CFG_DIR)
