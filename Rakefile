#!/usr/bin/env rake
# encoding: UTF-8

require 'fileutils'

@repo_files = %w(
  Rakefile
  README.md
)

@home            = File.expand_path('~')
@dotfiles        = (Dir['*'] - @repo_files).select{|f| File::file? f}

@vim_dir          = File.expand_path("~/.vim"                 )
@vimswaps_dir     = File.expand_path("~/.vimswaps"            )
@mutt_dir         = File.expand_path("~/.mutt"                )
@bin_dir          = File.expand_path("~/bin"                  )
@launch_agent_dir = File.expand_path("~/Library/LaunchAgents" )

@local_vimdirs   = Dir["vim/*"].     select {|dir | File.directory? dir }
@local_muttfiles = Dir["mutt/*"].    select {|file| File.file? file     }
@local_binfiles  = Dir["bin/*"].     select {|file| File.file? file     }
@local_plist     = Dir["launchd/*"]. select {|file| File.file? file     }

task :install => [:install_dotfiles, :install_vim, :install_mutt, :install_bin, :install_launchd]
task :clean => [:clean_dotfiles, :clean_vim, :clean_mutt, :clean_bin, :clean_launchd]

# Install home folder dotfiles
task :install_dotfiles do
  @dotfiles.each do |file|
    source = File.expand_path(file)
    target = File.join(@home, ".#{file}")

    FileUtils.ln_s source, target
    FileUtils.chmod 0644, target
  end

  # ensure that the msmtp file is the right permissions
  FileUtils.chmod 0600, 'msmtprc' if @dotfiles.include? 'msmtprc'

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

# link launchd scripts
task :install_launchd do
  FileUtils.ln_s @local_plist.map{ |file| File.expand_path file}, @launch_agent_dir
  @local_plist.each { |file| system "launchctl load #{File.basename(file)}" }
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

# Clean LaunchAgent folder links
task :clean_launchd do
  @local_plist.each { |file| system "launchctl unload #{File.basename(file)}" }
  FileUtils.rm_f @local_plist.map{ |file| File.expand_path file}
end
