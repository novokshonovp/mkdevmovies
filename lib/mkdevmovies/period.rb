module Mkdevmovies
  class Period
    attr_reader :params, :time_range

    def initialize(time_range, &block)
      @params = {}
      @time_range = time_range
      instance_eval(&block)
    end

    def self.period_defs(*period_specs)
      period_specs.each do |spec_name|
        define_method(spec_name) do |*args|
          @params[spec_name] = args.size > 1 ? args : args.first
        end
      end
    end

    def halls
      Array(params[:hall])
    end

    def overlaps?(new_period)
      time_range_overlapsed = (@time_range.to_a & new_period.time_range.to_a).size > 1
      halls_overlapsed = !(halls & new_period.halls).empty?
      time_range_overlapsed && halls_overlapsed
    end

    def cover?(time)
      time_range.cover?(time)
    end

    def parse_filter
      return { title: params[:title] } unless params[:title].nil?
      params[:filters].transform_values do |filter|
        filter.is_a?(Array) ? Regexp.union(filter) : filter
      end
    end

    period_defs :description, :filters, :price, :title, :hall
  end
end
