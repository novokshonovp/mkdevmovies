
DEFS = {filename_zip: "movies.txt.zip", 
            filename_txt: "movies.txt", 
            country: "USA"}
DATA_STRUCTURE = %i[link title r_year country r_date genre runtime rating director stars]

require 'zip'
require 'csv'
require 'ostruct'
require 'date'

# method to print a movie data
def print_movies(a_movies,i_records)
a_movies[0..i_records].each {| movie | 
                        puts "#{movie[:title]} (#{movie[:r_date]}; #{movie[:genre]}) - #{movie[:runtime]} min"} 
end

#check params
filename = ARGV[0]
if ARGV.length<1
    puts "Too few arguments. Use the default #{DEFS[:filename_zip]}."
    filename = DEFS[:filename_zip]
end
if !File.exist?(filename)
    puts "File #{filename} doesn't exist. Use the default #{DEFS[:filename_zip]}."
    filename = DEFS[:filename_zip]
end
#read zip file 
zip_file = Zip::File.new(DEFS[:filename_zip]).read(DEFS[:filename_txt])
#parse data to array of OpenStruct objects
movies = CSV.parse(zip_file,:col_sep=>"|",:headers=>DATA_STRUCTURE).map{ |i| OpenStruct.new(i.to_h) }

#print the 5 longest movies
puts "###   The 5 longest movies   ###"
print_movies(movies.sort_by { |movie| movie.runtime.scan(/[0-9]/).join.to_i }.reverse,5)

#print 10 comedies ordered by r_date
puts "###   10 comedies ordered by release date   ###"
print_movies( movies.select {|movie| movie.genre.include? "Comedy" }.sort_by(&:r_date),10)


#print all directors ordered by last word
puts "###   all directors ordered by last word   ###"
puts movies.sort_by { |movie| movie.director.split.last }.map(&:director).uniq


#print the number of the movies shooted not in the USA
puts "\nThe number of the movies shoted not in the USA: #{ movies.count {|movie| !movie.country.include? DEFS[:country] }.to_s} \n\n"                      

#print number of movies shooted by months      
puts "###   number of movies shooted by months   ###"   

movies
    .reject{ |movie| movie.r_date.count('-').zero? }
    .each_with_object(Hash.new(0)){ |movie,stats| stats[Date.strptime(movie.r_date,"%Y-%m").month]+=1 }
    .sort
    .each{ |month,stats|  puts "The number of the movies shooted in #{Date::MONTHNAMES[month]}: #{stats}" }    




