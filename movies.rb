C_FILENAME_ZIP = "movies.txt.zip"
C_FILENAME_TXT = "movies.txt"
C_LINK = :link
C_TITLE = :title
C_RELEASE_YEAR = :r_year
C_COUNTRY = :country
C_RELEASE_DATE = :r_date
C_GENRE = :genre
C_RUNTIME = :runtime
C_RATING = :rating
C_DIRECTOR = :director
C_STARS = :stars

require 'zip'

# method to print a movie data
def print_movies(a_movies,i_records)
a_movies[0..i_records].each {| i | 
						puts "#{i[:title]} (#{i[:r_date]}; #{i[:genre]}) - #{i[:runtime]} min"}	
end
#check params
filename = ARGV[0]
a_movies = Array.new
if ARGV.length<1
	puts "Too few arguments. Use the default #{C_FILENAME_ZIP}."
	filename = C_FILENAME_ZIP
end
if !File.exist?(filename)
	puts "File #{filename} doesn't exist. Use the default #{C_FILENAME_ZIP}."
	filename = C_FILENAME_ZIP
end
#parse zip file 
a_movies = Zip::File.new(C_FILENAME_ZIP).read(C_FILENAME_TXT).split("\n").map {
						|record| 
					Hash[C_LINK => record.split("|")[0],
					C_TITLE =>record.split("|")[1], 
					C_RELEASE_YEAR => record.split("|")[2], 
					C_COUNTRY => record.split("|")[3], 
					C_RELEASE_DATE => record.split("|")[4],
					C_GENRE => record.split("|")[5],
					C_RUNTIME => record.split("|")[6].scan(/[0-9]/).join.to_i,
					C_RATING => record.split("|")[7],
					C_DIRECTOR => record.split("|")[8],
					C_STARS => record.split("|")[9]]}


#print the 5 longest movies
puts "###   The 5 longest movies   ###"
print_movies(a_movies.sort_by {|i| i[C_RUNTIME] }.reverse,5)

#print 10 comedies ordered by r_date
puts "###   10 comedies ordered by release date   ###"
print_movies(a_movies.select {|i| i[C_GENRE].include? "Comedy" }.sort_by{ |i| i[C_RELEASE_DATE] },10)

#print all directors ordered by last word
puts "###   all directors ordered by last word   ###"
puts a_movies.sort_by {|i| i[C_DIRECTOR].split.last}.map {|i| [i[C_DIRECTOR]]}.uniq

#print the number of the movies shoted not in the USA
puts "\nThe number of the movies shoted not in the USA: " + a_movies.count {|i| !i[C_COUNTRY].include? "USA" }.to_s						
						
						
						
						
						
						
						
						