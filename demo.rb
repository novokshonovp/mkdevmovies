require_relative './lib/netflix'
require_relative './lib/theatre'
include MkdevMovies

DEFS = { filename_zip: 'movies.txt.zip',
         filename_txt: 'movies.txt' }.freeze

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

netflix = Netflix.new(filename_zip, DEFS[:filename_txt])
netflix.pay(10)
netflix.define_filter(:years_between){ |movie, year1, year2| movie.r_year.between?(year1, year2) }
netflix.define_filter(:years_between_83_85, from: :years_between, arg: [1983,1985] )
netflix.define_filter(:by_year){ |movie, year| movie.r_year==year }
netflix.define_filter(:by_schwarz){ |movie| movie.actors.grep(/Schwarz/).any? }
#netflix.show( actors: /Schwarz/, years_between_83_85: true ){ |movie| movie.genres.include?('Action') }
netflix.show
