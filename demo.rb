require_relative './lib/netflix'
require_relative './lib/movierenderer'
require_relative './lib/theatre'
require 'dotenv'
Dotenv.overload('./spec/one_movie.env')

include MkdevMovies

netflix = Netflix.new
mr = MovieRenderer.new(netflix)
template_file = './spec/templates/show_collection.haml'
output_file = './show_collection.html'
mr.download_tmdb_posters.render(template_file, output_file)

collection = MovieCollection.new
puts Movie.attributes.inspect
puts collection.all.first.title.inspect
puts collection.all.first.r_year.inspect
puts collection.all.first.genres.inspect
puts collection.all.first.r_date.inspect
puts collection.all.first.title_ru
puts collection.all.first.poster_id
puts collection.all.first.budget
