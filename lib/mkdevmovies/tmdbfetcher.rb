require 'open-uri'
require 'dotenv/load'

module Mkdevmovies
  class TMDBFetcher
    TMDB_DATA_URL = ENV['TMDB_DATA_URL']
    TMDB_API_KEY = ENV['TMDB_API_KEY']

    def data(imdb_id)
      uri = URI("#{TMDB_DATA_URL}#{imdb_id}?")
      puts uri.inspect
      uri.query = URI.encode_www_form(api_key: TMDB_API_KEY, language: 'ru_RU',
                                      external_source: 'imdb_id')
      uri.read
    end
  end
end
