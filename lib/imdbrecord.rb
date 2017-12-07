require_relative 'record'
require_relative 'imdbfetcher'

module MkdevMovies
  module IMDBRecord
    include Record

    # def get_remote(imdb_id)
    #  IMDBFetcher.new.data(imdb_id)
    # end
    def budget ## The same behavior like TMDBRecord !!!
      return get(imdb_id, :budget) if cached?(imdb_id, :budget)
      put(imdb_id, IMDBFetcher.new.data(imdb_id)).save
      get(imdb_id, :budget)
    end
  end
end
