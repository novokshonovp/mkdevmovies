require 'haml'

require_relative './lib/netflix'
require_relative './lib/theatre'
require_relative './lib/cinemaconverter'

include MkdevMovies

DEFS = { filename_zip: 'movies.txt.zip',
         filename_txt: 'movies.txt' }.freeze
KEY_CODE = 'dad2ab070e32d9245be1effef55b641f'.freeze
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

puts 'Downloading budget data from imdb.com ...'
converter = CinemaConverter.new(netflix, FILENAME_YAML)
converter.load_tmdb_data_to_file(KEY_CODE, FILENAME_YAML)
converter.add_tmpdb_data_to_collection(FILENAME_YAML)
converter.download_posters(POSTER_PATH)

template = File.read('./show_collection.haml')
puts 'Render html ...'
output = Haml::Engine.new(template).render(converter)
File.open('./show_collection.html', 'w') { |file| file.write(output) }
puts 'Finished'
