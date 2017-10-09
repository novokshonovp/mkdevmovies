require_relative 'movie'
require_relative 'moviecollection'


DEFS = {filename_zip: "movies.txt.zip", 
            filename_txt: "movies.txt"}

filename_zip = ARGV[0]
if ARGV.length<1
    puts "Too few arguments. Use the default #{DEFS[:filename_zip]}."
    filename_zip = DEFS[:filename_zip]
end
if !File.exist?(filename_zip)
    puts "File #{filename} doesn't exist. Use the default #{DEFS[:filename_zip]}."
    filename_zip = DEFS[:filename_zip]
end

movies = MovieCollection.new(filename_zip,DEFS[:file_name_txt])

NUMBER_OF_RESULTS = 5

puts "\nFirst #{NUMBER_OF_RESULTS} results of \"all\" method"
puts movies.all.first(NUMBER_OF_RESULTS)

movies.all.first.attrs.each{ | attr_name |
puts "\nFirst #{NUMBER_OF_RESULTS} results of \"sort_by\"  method by \"#{attr_name}\"" 
puts movies.sort_by(attr_name).first(NUMBER_OF_RESULTS) }



puts "\nFirst #{NUMBER_OF_RESULTS} results of \"filter\"  method"
puts movies.filter(actors: 'Harrison Ford').first(NUMBER_OF_RESULTS)


TEST_ATTR = %i[ director actors r_year month country genres]
TEST_ATTR.each { |test_key| 
  puts "\nFirst #{NUMBER_OF_RESULTS} results of \"stats\"  method by \"#{test_key}\" key"
  movies.stats(test_key)      
      .sort_by {|key| key[1]}
      .reverse
      .first(NUMBER_OF_RESULTS)
      .each{|key,value| puts "#{key}: #{value}" } }


puts "\nCheck attrs of the Movie"
puts movies.all.first.actors

test_genre = ["Drama","Comedy","Tragedy"]
test_genre.each { |test_key|
                    puts "\nCheck genre \"#{test_key}\". True- has in the movie, False- has in the collection, Exception for none."
                    begin
                      puts movies.all.first.has_genre?(test_key)
                    rescue Exception => e
                      puts "Rescue exception. Message :\"#{e.message}\""
                    end }


puts movies.filter(actors: /De Niro/, title: /Star/ , r_year: 1991..1993)           
   
    
                    
                    