## Email Search 

[![Build status](https://secure.travis-ci.org/kigster/email-search.png)](http://travis-ci.org/kigster/email-search)

Email Search is a rails application for loading a directory containing lots of 
email message files in the *.emlx (Apple) format, and then using Solr to search them.

## Usage

1. You should have a directory containing a bunch of *.emlx files you want import.  This could be a flat directory, or a hierarchy.
2. Run ```ruby rake emails:load:directory["/top/level/directory/with/your/files"]```
3. Now you should be able to search them in the console or the database.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Konstantin Gredeskoul, @kig, http://github.com/kigster
