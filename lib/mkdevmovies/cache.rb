
require 'yaml'

module Mkdevmovies
  class Cache
    attr_reader :data
    def initialize(path)
      @data = Hash.new { |h, k| h[k] = {} }
      @path = path
      load
    end

    def cached?(id, field)
      @data[id].key?(field)
    end

    def get(id, field)
      @data[id][field]
    end

    def put(id, data)
      @data[id].merge!(data)
      self
    end

    def save
      File.write(@path, @data.compact.to_yaml)
      self
    end

    private

    def load
      @data.merge!(YAML.load_file(@path)) if File.exist?(@path)
      self
    end
  end
end
