$original_sunspot_session = Sunspot.session
Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)

module SolrSpecHelper
  def clean_solr!
    Sunspot.remove_all!
  end

  def start_solr!
    unless $sunspot
      $sunspot = Sunspot::Rails::Server.new

      pid = fork do
        STDERR.reopen('/dev/null')
        STDOUT.reopen('/dev/null')
        $sunspot.run
      end
      # shut down the Solr server
      at_exit { Process.kill('TERM', pid) }
      # wait for solr to start
      sleep 5
    end

    Sunspot.session = $original_sunspot_session
  end
end

if ENV['TEST_SOLR']
  RSpec.configure do |config|
    config.include(SolrSpecHelper)
    config.before(:all) do
      start_solr!
    end
    config.before(:each) do
      clean_solr!
    end
  end
end
