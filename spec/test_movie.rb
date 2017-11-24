require 'ostruct'
 shared_context 'create_test_movie' do
  let(:movie_collection) { MovieCollection.new("./movies.txt.zip","movies.txt")}
  let(:movie) { movie_collection.all.first}
  #let(:wrong_movie){ OpenStruct.new({link: "http://imdb.com/title/tt0816692/?ref_=chttp_tt_0", title: "Wrong test movie", r_year: "2022", country: "USA", r_date: "2022-11-07", genres: "Adventure,Drama,Sci-Fi", runtime: "169 min", rating: "8.7", director: "Christopher Nolan", actors: "Matthew McConaughey,Anne Hathaway,Jessica Chastain"})}
  let(:wrong_movie) { { link: "http://imdb.com/title/tt0816692/?ref_=chttp_tt_0", title: "Wrong test movie", r_year: "2022", country: "USA", r_date: "2022-11-07", genres: "Adventure,Drama,Sci-Fi", runtime: "169 min", rating: "8.7", director: "Christopher Nolan", actors: "Matthew McConaughey,Anne Hathaway,Jessica Chastain" } }
end                                              