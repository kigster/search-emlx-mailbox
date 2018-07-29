task :reset do
  begin
    Rake::Task['sunspot:solr:start'].invoke
    Rake::Task['db:reset'].invoke
    sleep 6
    Rake::Task['emails:reset_solr'].invoke
  ensure
    Rake::Task['sunspot:solr:stop'].invoke
  end
end

namespace :emails do
  task :reset_solr => [:environment] do
    Sunspot.remove_all!
  end

  namespace :load do
    desc 'Load all emails from a directory hierarchy, ie: rake emails:load:directory[\'/home/blah/emails\',\'emlx\']'
    task :directory, [:directory, :extension] => [:environment] do |t, args|
      EmailSearch::Importer.new(args[:directory], file_extension: args[:extension]).import!
    end
    desc 'Load a single email by file name'
    task :file, [:file] => [:environment] do |t, args|
      EmailSearch::AsciiLoader.new(args[:file]).email.save!
    end
  end
end
