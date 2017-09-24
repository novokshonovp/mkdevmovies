C_FILENAME = "movies.txt"
C_PATTERN = "Max"
# method to print a movie data
def print_movies(a_movies,i_records)
a_movies[0..i_records].each {| i | 
						puts "#{i[:title]} (#{i[:r_date]}; #{i[:genre]}) - #{i[:runtime]} min"}	
end
filename = ARGV[0]
a_movies = Array.new
if ARGV.length<1
	puts "Too few arguments. Use the default #{C_FILENAME}."
	filename = C_FILENAME
end
if !File.exist?(filename)
	puts "File #{filename} doesn't exist. Use the default #{C_FILENAME}."
	filename = C_FILENAME
end
File.open(filename).each do |record|
	#parse file to array structure
	a_movies.push({:link => record.split("|")[0],:title =>record.split("|")[1],
					:r_year => record.split("|")[2], 
					:country => record.split("|")[3], 
					:r_date => record.split("|")[4],
					:genre => record.split("|")[5],
					:runtime => record.split("|")[6].scan(/[0-9]/).join.to_i,
					:rating => record.split("|")[7],
					:director => record.split("|")[8],
					:stars => record.split("|")[9].chop}) 
end
#print the 5 longest movies
puts "###   The 5 longest movies   ###"
t_movies = a_movies.sort_by {|i| 
				i[:runtime] 
				}.reverse
print_movies(t_movies,5)

#print 10 comedies ordered by r_date
puts "###   10 comedies ordered by release date   ###"
t_movies = a_movies.select {|i| i[:genre].include? "Comedy" }.sort_by{ |i| i[:r_date] }
print_movies(t_movies,10)

#print all directors ordered by last word
puts "###   all directors ordered by last word   ###"
a_directors = Array.new
a_movies.sort_by {|i| i[:director].split.last}.uniq{ |i| i[:director]}.each{|i| a_directors.push(i[:director])}
puts a_directors

#print the number of the movies shoted not in the USA
puts "\nThe number of the movies shoted not in the USA: " + a_movies.select {|i| !i[:country].include? "USA" }.count.to_s
						
						
						
						
						
						
						
						
						