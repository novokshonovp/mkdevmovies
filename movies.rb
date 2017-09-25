
C_HASH_DEFS = {filename_zip: "movies.txt.zip", 
            filename_txt: "movies.txt", 
            country: "USA"}
C_HASH_DATA_STRUCTURE = %i[link c_title r_year country r_date genre runtime rating director stars]

require 'zip'

# method to print a movie data
def print_movies(a_movies,i_records)
a_movies[0..i_records].each {| i | 
                        puts "#{i[:title]} (#{i[:r_date]}; #{i[:genre]}) - #{i[:runtime]} min"} 
end

#check params
filename = ARGV[0]
if ARGV.length<1
    puts "Too few arguments. Use the default #{C_HASH_DEFS[:filename_zip]}."
    filename = C_HASH_DEFS[:filename_zip]
end
if !File.exist?(filename)
    puts "File #{filename} doesn't exist. Use the default #{C_HASH_DEFS[:filename_zip]}."
    filename = C_HASH_DEFS[:filename_zip]
end
#parse zip file 
a_movies = Hash.new
a_movies = Zip::File.new(C_HASH_DEFS[:filename_zip]).read(C_HASH_DEFS[:filename_txt]).split("\n").map {
                        |record|
                            C_HASH_DATA_STRUCTURE.zip(record.split("|")).to_h }

#print the 5 longest movies
puts "###   The 5 longest movies   ###"
print_movies(a_movies.sort_by {|i| i[:runtime].scan(/[0-9]/).join.to_i }.reverse,5)

#print 10 comedies ordered by r_date
puts "###   10 comedies ordered by release date   ###"
print_movies(a_movies.select {|i| i[:genre].include? "Comedy" }.sort_by{ |i| i[:r_date] },10)

#print all directors ordered by last word
puts "###   all directors ordered by last word   ###"
puts a_movies.sort_by {|i| i[:director].split.last}.map {|i| [i[:director]]}.uniq

#print the number of the movies shoted not in the USA
puts "\nThe number of the movies shoted not in the USA: " + a_movies.count {|i| !i[:country].include? C_HASH_DEFS[:country] }.to_s                     
            
                        
                        
                        
                        
                        
                        