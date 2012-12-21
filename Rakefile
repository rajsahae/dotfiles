task :install => :vim_install
task :clean => :vim_clean

task :vim_install do
  Dir.chdir("vim") do |dir|
    system "rake install"
  end
end

task :vim_clean do
  Dir.chdir("vim") do |dir|
    system "rake clean"
  end
end
