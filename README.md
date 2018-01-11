# Mkdevmovies

The Mkdevmovies gem provides:
 - Load IMDB top 250 movies from csv prepared file (data/movies.txt) to a collection.
 - Add budget field to the collection by parse imdb.com
 - Add Russian title and poster path to the collection from API of tmdb.com
 - Sort, filter and get stats data of the collection.
 - Create cinema schedules.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mkdevmovies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mkdevmovies
Add environment variables to system
    $touch .env
Use your favorite editor and add follow lines to .env file.
  FILE_RECORD_TXT = './movies.txt'
  IMDB_DATA_URL = 'http://imdb.com/title/'
  FILE_CACHE_YAML = './cache.yaml'
  TMDB_IMAGE_URL = 'http://image.tmdb.org/t/p/w185/'
  POSTER_IMAGES = './images'
  TMDB_DATA_URL = 'https://api.themoviedb.org/3/find/'
  TMDB_API_KEY = 'ADD YOUR API KEY HERE'

Download collection to your local directory
  $curl -O https://raw.githubusercontent.com/novokshonovp/mkdev-movies/master/data/movies.txt

Create directory to hold posters images
  $mkdir images

Receive THE MOVIE DB API Key from tmdb.com and add to TMDB_API_KEY

## Usage

### Quick Start
```ruby
  2.4.3 :001 > require 'mkdevmovies'
 => true
2.4.3 :002 > include Mkdevmovies
 => Object
2.4.3 :003 > col = MovieCollection.new
 => #<Mkdevmovies::MovieCollection: ...OUTPUT CUTTED...]>]>
2.4.3 :004 > Movie.attributes
 => [:period, :link, :title, :r_year, :country, :r_date, :genres, :runtime, :rating, :director, :actors, :title_ru, :poster_id, :budget]
2.4.3 :005 > col.first.title
 => "The Shawshank Redemption"
2.4.3 :006 > col.first.title_ru
 => "Побег из Шоушенка"
```

### Collection routine
Various filter options passes as hash options:
```ruby
col = MovieCollection.new
col.filter(period: 'AncientMovie', r_year: 1942) #filter by period and r_year
col.filter(genres: 'Drama', exclude_title: 'Interstellar') # or with an exclude field option
```

Calculate stats data
```ruby
col = MovieCollection.new
col.stats(:director)
```

Use a collection as an enumerable object
```ruby
col = MovieCollection.new
col.select { |movie| movie.title == 'Casablanca' }.first.title
```

### Create a schedule

Toolbox allow to create cinema schedules with a simple DSL.
```ruby
cinema = Class.new { include Schedule }
cinema.new do
             hall :red, title:'Red hall', places: 100
             hall :blue, title: 'Blue hall', places: 50
             period '06:00'..'12:00' do
             description 'Morning show'
             filters period: 'AncientMovie'
             price 3
             hall :red, :blue
           end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mkdevmovies. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mkdevmovies project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/mkdevmovies/blob/master/CODE_OF_CONDUCT.md).
