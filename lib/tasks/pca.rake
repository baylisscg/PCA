

CLASS_FILES = FileList['**/*.class']

task :clean => :clobber

task :clobber do
  rm CLASS_FILES
end
