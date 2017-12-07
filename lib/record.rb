module MkdevMovies
  module Record
    attr_accessor :imdb_id

    private

    def fetch(imdb_id, field_name)
      collection.cache.put(imdb_id, get_remote(imdb_id)).save
      collection.cache.get(imdb_id, field_name)
    end

    def get(imdb_id, field)
      collection.cache.get(imdb_id, field)
    end

    def put(imdb_id, field)
      collection.cache.put(imdb_id, field)
    end

    def cached?(imdb_id, field)
      collection.cache.cached?(imdb_id, field)
    end

    def self.attributes
      @attributes ||= [:imdb_id]
    end

    def self.add_attributes(attrs)
      @attributes = attributes + attrs
    end
  end
end
