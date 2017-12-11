require_relative 'record'
require_relative 'imdbfetcher'

module MkdevMovies
  class IMDBRecord < Record
    FIELDS = { budget: %i[budget to_s] }.freeze

    def data(field_name)
      fetch(field_name) { IMDBFetcher.new.data(@imdb_id) }
    end
  end
end
