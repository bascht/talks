# -- encoding: utf-8 --
require 'logger'
require 'fileutils'
require 'erb'

@logger = Logger.new(STDOUT)
@logger.formatter = proc { |serverity, time, progname, msg| "#{time} – #{msg}\n" }

def talks(file = "")
  Dir.glob("[0-9]*/#{file}").sort.reverse
end

def dontbotherme(command)
  @logger.info("Executing [#{command}]")
  pid = spawn(command, [:out, :err] => '/dev/null')
  Process.wait(pid)
end

task :ioslide do
  system("git checkout gh-pages")
  talks("README.org").each do |file|
    path = File.dirname(file)
    if File.exists?("#{path}/index.html")
      @logger.warn("Skipping #{path}. Found an index.html.")
      next
    end

    @logger.info("Building #{file}")
    dontbotherme("emacs --batch -l ~//.emacs.d/init.el --visit=#{file} --funcall org-ioslide-export-to-html")
    @logger.debug("Moving #{path}/README.html to #{path}/index.html")
    FileUtils.move("#{path}/README.html", "#{path}/index.html")
  end
  @logger.info("Done building ioslides.")
end

task :index do
  README = File.read('README.org.erb')
  index = ERB.new(README).result(binding)
  File.open('README.org', 'w') {|f| f.write(index) }
  @logger.info("Rebuilt ORG index.")
  dontbotherme("emacs --batch -l ~//.emacs.d/init.el --visit=README.org --funcall org-html-export-to-html")
  FileUtils.move("README.html", "index.html")
  @logger.info("Rebuilt HTML index. I'm done.")
end

task :default => [:ioslide, :index]
