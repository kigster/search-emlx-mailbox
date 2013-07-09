## Email Search 

[![Build status](https://secure.travis-ci.org/kigster/email-search.png)](http://travis-ci.org/kigster/email-search)

Email Search is a simple rails application, whose goal is to provide fast and effective search across many
email messages in the "*.emlx" format (used by Apple Mail).  Application provides a way to import these messages
from a directory to the database, and then uses Apache Solr (via Sunspot gem) to search imported messages.

## Why?

I had to dig through a whole lot (tens of thousands) of very old email files, and search for relevant items,
and using ```grep``` and ```find``` quickly became complete nuisance. I wanted to search case insensitively,
including terms, excluding terms, using full text search and natural language capabilities of modern search engines.

And then I thought, hell, maybe someone else will need to do the same sometimes.  So I decided to make it properly,
and make it open source.

This simple Rails 4 / Ruby 2.0 app allows sophisticated full-text searches powered by Solr, and offers a
convenient screen viewport for scanning through email content that match.  You can export emails back, that match
a particular search criteria, using the "Download" button, which creates a zip file of matching emails.

## Usage

1. You should have a directory containing a bunch of *.emlx files you want import.  This could be a flat directory, or a hierarchy.
2. Run ```bundle install```
3. Run ```rake db:create && rake db:migrate```
4. Run ```bundle exec foreman start``` to start the application and Solr
5. Run ```bundle exec rake emails:load:directory["/top/level/directory/with/your/files"]```
6. Connect to http://localhost:8080/
7. Search, refine your search, hover over matching emails, search again.
8. Results of any search query can be exported as a zip file and downloaded.

### Screen Shot

Below is a sample screen shot with the Rails application running.

![Sample Screen Shot](https://raw.github.com/kigster/email-search/master/doc/email_search_ss.png "Email Search App opened")

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

