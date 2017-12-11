
module MkdevMovies
  class Record
    def self.import_attributes(object, mdb)
      mdb.class::FIELDS.each do |name, conv|
        object.instance_eval do
          define_singleton_method(name) do
            conv.last.respond_to?(:call) ? conv.last.call(mdb.data(name)) : mdb.data(name).send(conv.last)
          end
          object.attributes.push(name)
        end
      end
    end

    def initialize(imdb_id, cache)
      @imdb_id = imdb_id
      @cache = cache
    end

    def fetch(field)
      return @cache.get(@imdb_id, field) if @cache.cached?(@imdb_id, field)
      @cache.put(@imdb_id, yield).save
      @cache.get(@imdb_id, field)
    end
  end
end
