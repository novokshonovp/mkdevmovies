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
  Theatre.new(filename_zip, DEFS[:filename_txt]) do
    hall :red, title:'Красный зал', places: 100
    hall :blue, title: 'Синий зал', places: 50
    hall :green, title: 'Зелёный зал (deluxe)', places: 12   
    hall :vip, title: 'Зелёный зал (deluxe)', places: 12   
    period '09:00'..'11:00' do
      description 'Утренний сеанс'
      filters genres: 'Comedy', r_year: 1900..1980
      price 10
      hall :blue
    end
   period '11:00'..'16:00' do
      description 'Спецпоказ'
      title 'The Terminator'
      price 50
      hall :green
   end
    period '11:00'..'18:00' do
      description 'Спецпоказ по 70'
      title 'The Terminator'
      price 70
      hall :vip
   end
    period '16:00'..'20:00' do
      description 'Вечерний сеанс'
      filters genres: ['Action', 'Drama'], r_year: 2007..Time.now.year
      price 20
      hall :red, :blue
    end

    period '19:00'..'22:00' do
      description 'Вечерний сеанс для киноманов'
      filters r_year: 1900..1945, exclude_country: 'USA' 
      price 30
      hall :green
    end
  end

theatre.show('22:00')
puts theatre.when?('The Terminator')
puts theatre.periods
       

