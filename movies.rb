
C_HASH_DEFS = {filename_zip: "movies.txt.zip", 
            filename_txt: "movies.txt", 
            country: "USA"}
C_HASH_DATA_STRUCTURE = %i[link title r_year country r_date genre runtime rating director stars]

require 'zip'
require 'csv'
require 'ostruct'
require 'date'

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
#read zip file 
zip_file = Zip::File.new(C_HASH_DEFS[:filename_zip]).read(C_HASH_DEFS[:filename_txt])
#parse data to array of OpenStruct objects
a_movies = CSV.parse(zip_file,:col_sep=>"|").map { |i| rowdata = OpenStruct.new(C_HASH_DATA_STRUCTURE.zip(i).to_h) }

#print the 5 longest movies
puts "###   The 5 longest movies   ###"
print_movies(a_movies.sort_by {|i| i.runtime.scan(/[0-9]/).join.to_i }.reverse,5)

#print 10 comedies ordered by r_date
puts "###   10 comedies ordered by release date   ###"
print_movies(a_movies.select {|i| i.genre.include? "Comedy" }.sort_by{ |i| i.r_date },10)


#print all directors ordered by last word
puts "###   all directors ordered by last word   ###"
puts a_movies.sort_by {|i| i.director.split.last}.map {|i| [i.director]}.uniq


#print the number of the movies shooted not in the USA
puts "\nThe number of the movies shoted not in the USA: #{a_movies.count {|i| !i.country.include? C_HASH_DEFS[:country] }.to_s} \n\n"                      

#print number of movies shooted by months      
puts "###   number of movies shooted by months   ###"   
x = a_movies.inject(Hash.new(0)) { |h,i| 
                                    #get and check month data
                                    begin
                                      month = Date.parse(i.r_date).month
                                    rescue ArgumentError
                                      if /-(\d+)/.match?(i.r_date.to_s)
                                        month = /-(\d+)/.match(i.r_date.to_s)[1]
                                        puts "The movie \"#{i.title}\" has incorrect date - release date (#{i.r_date}), use #{month} as a month"
                                      else
                                        puts "The movie \"#{i.title}\" has no month date - release date (#{i.r_date})"                                       
                                      end
                                    end
                                    if !month.nil? 
                                      h[month.to_i]+=1 
                                    end
                                    h
                                  }
x.sort_by { |i| i[0]}.each {|i| puts "The number of the movies shooted in #{Date::MONTHNAMES[i[0]]}: #{i[1]}"  }


     
