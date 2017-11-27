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

theatre =
  Theatre.new('./spec/test_movies.txt.zip', 'movies.txt') do
    hall :red, title: 'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12
    period '06:00'..'12:00' do
      description 'Утренний сеанс'
      filters period: 'AncientMovie'
      price 3
      hall :red, :blue
    end
    period '10:00'..'18:00' do
      description 'Комедии и приключения'
      filters genres: %w[Comedy Adventure]
      price 5
      hall :green
    end
    period '18:00'..'24:00' do
      description 'Ужасы'
      filters genres: 'Horror'
      price 10
      hall :green
    end
  end

                      
puts theatre.halls_by_periods.inspect
theatre.show('7:30')
theatre.buy_ticket('11:05', hall: :green)
puts theatre.when?('The Terminator')
