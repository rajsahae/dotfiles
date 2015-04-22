#!/usr/bin/env rake
# encoding: UTF-8

require 'fileutils'

REPO_FILES = %w(
  Rakefile
  README.md
)

task :install => [:install_dotfiles, :install_vim, :install_mutt, :install_bin]
task :clean => [:clean_dotfiles, :clean_vim, :clean_mutt, :clean_bin]

# Install home folder dotfiles
task :install_dotfiles do
  dotfiles = (Dir['*'] - REPO_FILES).select{|f| File::file? f}
  dotfiles.each do |file|
    FileUtils.ln_s File.expand_path(file), File.expand_path(File.join(ENV['HOME'], ".#{file}"))
  end
end

# Clean dotfiles from home folder
task :clean_dotfiles do
  list = Dir['*'] - REPO_FILES
  dotfiles = list.select{ |f| File::file? f }
  dotfiles.map!{ |file| File.expand_path(File.join(ENV['HOME'], ".#{file}")) }
  FileUtils.rm_f dotfiles
end

# link vim folder
task :install_vim do
end

# link mutt folder
task :install_mutt do
end

# link bin folder
task :install_bin do
end
