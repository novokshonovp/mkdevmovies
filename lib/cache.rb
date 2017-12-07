
require 'yaml'

module MkdevMovies
  class Cache
    attr_reader :data
    def initialize(path_cache_file)
      @data = {}
      @filename_yaml = path_cache_file
      load
    end

    def cached?(imdb_id, field)
      return false if @data[imdb_id].nil?
      !@data[imdb_id][field].nil?
    end

    def get(imdb_id, field)
      @data[imdb_id][field]
    end

    def put(imdb_id, data)
      @data[imdb_id] = @data[imdb_id].nil? ? data : @data[imdb_id].merge(data)
      self
    end
    def fetch(imdb_id, field)
      return get(imdb_id, field) if cached?(imdb_id, field)
      put(imdb_id, yield).save
      get(imdb_id, field)
    end

    def save
      File.open(@filename_yaml.to_s, 'w') do |file|
        file.write YAML.dump(@data)
      end
      self
    end

    private

    def load
      @data = YAML.load_stream(File.open(@filename_yaml)).first if File.exist?(@filename_yaml)
      @data ||= {}
      self
    end
    module Interface
      
    end
  end
end
