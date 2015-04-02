task :install => [:vim_install, :git_install, :sh_install]
task :clean => [:vim_clean, :git_clean, :sh_clean]

["git", "vim", "sh"].each do |prog|
  ["clean", "install"].each do |action|
    task "#{prog}_#{action}".to_sym do
      Dir.chdir(prog) do |dir|
        system "rake #{action}"
      end
    end
  end
end
