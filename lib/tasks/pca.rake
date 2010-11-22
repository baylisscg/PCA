#
#
#

CLASS_FILES = FileList['**/*.class']

task :clean => :clobber

task :clobber do
  rm CLASS_FILES
end

namespace :pca do

  desc "Create a normal GRAM run."
  task :make_good do
    connection = Factory.build(:connection)

  end

end
