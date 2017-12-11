# require_relative './lib/netflix'

# require_relative './lib/movierenderer'
require 'dotenv'
Dotenv.load('.env')
require_relative './lib/theatre'

include MkdevMovies


# netflix = Netflix.new('./spec/test_movies.txt.zip', 'movies.txt')

collection = MovieCollection.new
puts collection.all.first.title.inspect
puts Movie.attributes.inspect
puts collection.all.first.r_year.inspect
puts collection.all.first.genres.inspect
puts collection.all.first.r_date.inspect
puts collection.all.first.title_ru
puts collection.all.first.poster_id
puts collection.all.first.budget
#puts collection.cache.data.each {|id, data| puts "id:#{id}, data:#{data[:genres]}" }
#puts collection.all.first.inspect
#puts collection.all.each {|movie| puts movie.title}
#puts collection.filter(genres: 'Action')
 #puts collection.all.first.has_genre?('Action')
# puts Record.attributes.inspect
# c.cache.data.each { |id, values|  puts "#{id},#{values[:title]}, #{values[:r_year]}" }
