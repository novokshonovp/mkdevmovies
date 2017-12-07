# require_relative './lib/netflix'

# require_relative './lib/movierenderer'
require 'dotenv'
Dotenv.load('.env')
require_relative './lib/theatre'

include MkdevMovies

# netflix = Netflix.new('./spec/test_movies.txt.zip', 'movies.txt')

# puts x.methods
 collection = MovieCollection.new
 puts collection.all.first.title
 puts collection.all.first.title_ru
  puts collection.all.first.poster_id
   puts collection.all.first.budget
# puts m.has_genre?('Action')
# puts Record.attributes.inspect
# c.cache.data.each { |id, values|  puts "#{id},#{values[:title]}, #{values[:r_year]}" }
