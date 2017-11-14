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

netflix.define_filter(:old_sci_fi) { |movie, year|  movie.r_year < year && movie.genres.include?('Action')  && movie.period == 'ClassicMovie' && !movie.country.include?('UK') }
netflix.define_filter(:year_between){ |movie, year1, year2|  movie.r_year.between?(year1, year2) }
netflix.define_filter(:action_by_year){ |movie, year|  movie.genres.include?('Action') && movie.r_year == year } 
netflix.define_filter(:new_sci_fi) { |movie, year|  movie.r_year > year && movie.genres.include?('Sci-Fi') }

netflix.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)
netflix.define_filter(:terminator, from: :action_by_year, arg: 1984) 
netflix.show(terminator: true)

          
