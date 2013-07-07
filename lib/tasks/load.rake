task :reset do
  Rake::Task["db:reset"].invoke
  Rake::Task["emails:reset_solr"].invoke
end

namespace :emails do
  task :reset_solr do
    Sunspot.remove_all!
  end

  namespace :load do
    desc "Load all emails from a directory hierarchy"
    task :directory, [:directory] => [:environment] do |t, args|
      Email.create_from_dir args[:directory]
    end
    desc "Load a single email by file name"
    task :file, [:file] => [:environment] do |t, args|
      Email.from_file args[:file]
    end
  end
end
