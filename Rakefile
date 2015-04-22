#!/usr/bin/env rake
# encoding: UTF-8

require 'fileutils'

@repo_files = %w(
  Rakefile
  README.md
)

@home            = File.expand_path('~')
@dotfiles        = (Dir['*'] - @repo_files).select{|f| File::file? f}

@vim_dir         = File.expand_path("~/.vim")
@vimswaps_dir    = File.expand_path("~/.vimswaps")
@mutt_dir        = File.expand_path("~/.mutt")
@bin_dir         = File.expand_path("~/bin")

@local_vimdirs   = Dir["vim/*"].select{|dir| File.directory? dir }
@local_muttfiles = Dir["mutt/*"].select{|file| File.file? file }
@local_binfiles  = Dir["bin/*"].select{|file| File.file? file }

task :install => [:install_dotfiles, :install_vim, :install_mutt, :install_bin]
task :clean => [:clean_dotfiles, :clean_vim, :clean_mutt, :clean_bin]

# Install home folder dotfiles
task :install_dotfiles do
  @dotfiles.each do |file|
    FileUtils.ln_s File.expand_path(file), File.join(@home, ".#{file}")
  end
end

# link vim folder
task :install_vim do
  FileUtils.mkdir_p @vim_dir
  FileUtils.mkdir_p @vimswaps_dir
  FileUtils.ln_s @local_vimdirs.map{ |dir| File.expand_path dir }, @vim_dir
end

# link mutt folder
task :install_mutt do
  FileUtils.mkdir_p @mutt_dir
  FileUtils.ln_s @local_muttfiles.map{ |dir| File.expand_path dir }, @mutt_dir
end

# link bin folder
task :install_bin do
  FileUtils.mkdir_p @bin_dir
  FileUtils.ln_s @local_binfiles.map{ |dir| File.expand_path dir }, @bin_dir
end

# Clean dotfiles from home folder
task :clean_dotfiles do
  FileUtils.rm_f @dotfiles.map{ |file| File.join(@home, ".#{file}") }
end

# Clean vim folder links
task :clean_vim do
  FileUtils.rm_rf @vim_dir
  FileUtils.rm_rf @vimswaps_dir
end

# Clean mutt folder links
task :clean_mutt do
  files = @local_muttfiles.map{|f| File.join(@home, '.mutt', File.basename(f)) }
  FileUtils.rm_f files
end

# Clean bin folder links
task :clean_bin do
  files = @local_binfiles.map{|f| File.join(@home, 'bin', File.basename(f)) }
  FileUtils.rm_f files
end
