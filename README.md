## Email Search 

[![Build status](https://secure.travis-ci.org/kigster/search-emlx-mailbox.png)](http://travis-ci.org/kigster/search-emlx-mailbox)

Email Search is a simple rails application, whose goal is to provide fast and effective search across many
email messages saved in a standard ASCII text format, one file per message, where mail header and the body are separated by two newlines.
For example, *.emlx format used by Apple Mail works great.  This app provides an easy way to import these messages
from a directory to the database, and then uses Apache Solr to search imported messages using full text search.

## Why?

I had to dig through a whole lot (tens of thousands) of very old email files, and search for relevant items,
and using ```grep``` and ```find``` quickly became complete nuisance. I wanted to search case insensitively,
including terms, excluding terms, using full text search and natural language capabilities of modern search engines.

And then I thought, hell, maybe someone else will need to do this too.  So I decided to make it a "proper" app,
write some tests, and open source it.

The result is a rather simple but effective Rails app, that supports sophisticated full-text searches
powered by Solr (powered by Sunspot), and offers a convenient screen viewport for scanning through email
content that match search, with a UI based on Twitter Bootstrap.  You can then export the results that match
a particular search criteria using the "Download" button, which creates a zip file that includes matching email
messages, and then sends it to the browser.

## Dependencies

- Rails 4
- Ruby 2.0
- PostgreSQL is the default database engine, but you can change it in database.yml

## Usage

1. You should have a directory containing a bunch of *.emlx files you want import.  This could be a flat directory, or a hierarchy.
2. Checkout the app
3. Run ```bundle install```
4. Run ```rake reset``` (this rebuilds database, and re-creates Solr index)
5. Run ```foreman start``` to start the application and Solr (in development mode)
6. Run ```rake 'emails:load:directory[/top/level/directory/with/your/files,extension]```. For example, ```rake 'emails:load:directory[/Users/kig/mail,emlx]```. This should display a progress bar, as files are being imported and indexed by Solr.
7. Connect to http://localhost:8080/
8. Search, refine your search, hover over matching emails to view them, search again.
9. Results of any search query can be exported as a zip file and downloaded.

### Screen Shot

Below is a sample screen shot with the Rails application running.

![Sample Screen Shot](https://raw.github.com/kigster/email-search/master/doc/email_search_ss.png "Email Search App opened")

## Testing

To run the tests either run ```rspec``` (bypasses Solr tests), or to test with Solr enabled, run:

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

Konstantin Gredeskoul, http://github.com/kigster

## License

See the LICENSE file.

