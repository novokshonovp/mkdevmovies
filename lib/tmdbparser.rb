require 'open-uri'
require 'json'

module MkdevMovies
  module TMDbParser
    DATA_URL = 'https://api.themoviedb.org/3/find/'.freeze
    IMAGE_URL = 'http://image.tmdb.org/t/p/w185/'.freeze

    private

    def json_by_imdb_id(imdb_id, api_key)
      uri = URI("#{DATA_URL}#{imdb_id}?")
      uri.query = URI.encode_www_form(api_key: api_key, language: 'ru_RU',
                                      external_source: 'imdb_id')
      JSON.parse(uri.read)
    end

    def download_and_save_poster_image(path, poster_id)
      File.open("#{path}#{poster_id}", 'wb') do |file|
        file.write open("#{IMAGE_URL}#{poster_id}").read
      end
    end

    def append_data_to_yaml_file(filename_yaml, data)
      File.open(filename_yaml, 'a') do |file|
        file.write YAML.dump(data)
      end
    end
  end
end
