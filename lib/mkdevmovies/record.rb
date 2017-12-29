
module Mkdevmovies
  class Record
     
    def self.import_attributes(object)
      mdb_class = self
      self.attributes.each do |attr|
        object.instance_eval { define_method(attr) { @records[mdb_class].get(attr) } }
      end
    end

    def initialize(imdb_id, cache)
      @imdb_id = imdb_id
      @cache = cache
    end

    def get(field)
      @cache.put(@imdb_id, fetch).save unless @cache.cached?(@imdb_id, field)
      @cache.get(@imdb_id, field)
    end
  end
end
