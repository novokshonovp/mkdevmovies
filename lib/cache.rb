
require 'yaml'

module MkdevMovies
  class Cache
    attr_reader :data
    def initialize(path)
      @data = {}
      @path = path
      load
    end

    def cached?(id, field)
      @data[id]&.key?(field)
    end

    def get(id, field)
      @data[id][field]
    end

    def put(id, data)
      @data[id] ||= {}
      @data[id] = @data[id].merge(data)
      self
    end

    def save
      File.write(@path, @data.to_yaml)
      self
    end

    private

    def load
      @data = YAML.load_file(@path) if File.exist?(@path)
      @data ||= {}
      self
    end
  end
end
