## Email Search 

[![Build status](https://secure.travis-ci.org/kigster/email-search.png)](http://travis-ci.org/kigster/email-search)

Email Search is a simple rails application, whose goal is to provide fast and effective search across many
email messages in the "*.emlx" format (used by Apple Mail).  Application provides a way to import these messages
from a directory to the database, and then uses Apache Solr (via Sunspot gem) to search imported messages.

## Usage

1. You should have a directory containing a bunch of *.emlx files you want import.  This could be a flat directory, or a hierarchy.
2. Run ```bundle install```
3. Run ```rake db:create && rake db:migrate```
4. Run ```bundle exec foreman start``` to start the application and Solr
5. Run ```bundle exec rake emails:load:directory["/top/level/directory/with/your/files"]```
4. Connect to http://localhost:8080/emails/search
5. Search.

## Testing

To run the tests either run ```rspec``` (bypasses Solr tests), or to test with Solr running run:

```ruby
TESTS_SOLR=true rspec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Konstantin Gredeskoul, @kig, http://github.com/kigster
