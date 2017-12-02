require_relative './lib/netflix'
require_relative './lib/theatre'
require_relative './lib/movierenderer'
include MkdevMovies

DEFS = { filename_zip: 'movies.txt.zip',
         filename_txt: 'movies.txt' }.freeze

FILENAME_YAML = 'tmdb_data.yaml'.freeze
POSTER_PATH = './images'.freeze

filename_zip = ARGV[0]
if ARGV.empty?
  puts "Too few arguments. Use the default #{DEFS[:filename_zip]}."
  filename_zip = DEFS[:filename_zip]
end
unless File.exist?(filename_zip)
  puts "File #{filename_zip} doesn't exist. \
       Use the default #{DEFS[:filename_zip]}."
  filename_zip = DEFS[:filename_zip]
end

netflix = Netflix.new('./spec/test_one_movie.txt.zip', 'movies.txt')

require_relative './lib/fetchercache'

Movie.include(FetcherCache::MovieExtender)

puts netflix.all.first.title_ru

mr = MovieRenderer.new(netflix).download_tmdb_posters
mr.render('./show_collection.haml', './show_collection.html')
