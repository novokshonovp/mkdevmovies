
module MkdevMovies

  class Period
    attr_reader :schedule

    def initialize(&block)
      @schedule = {}
      self.instance_eval(&block)
    end

    def self.period_defs(*period_specs)
      @schedule ||= {}
      period_specs.each do |spec_name|
        define_method(spec_name) do |*args|
          @schedule[spec_name] = args.size > 1 ? args : args.first
        end
      end
    end
    period_defs :description, :filters, :price, :title, :hall
  end

  module Schedule
    attr_accessor :halls, :periods
    def initialize(*args, &block)
      raise 'Need a block to create Theatre!' unless block_given?
      super(*args)
      instance_eval(&block)
    end

    def hall(*args)
      raise 'Hall should have title and places' if args.size < 2
      raise 'No title for a hall!' if args.last[:title].to_s.empty?
      raise 'Places should be > 0!' if args.last[:places].nil? || args.last[:places] <= 0
      @halls ||= {}
      @halls[args.first] = { title: args.last[:title], places: args.last[:places] }
    end

    def period(args, &block)
      @periods ||= {}
      p = Period.new(&block)
      @periods[args] = p.schedule if validate(p.schedule, args)
    end

    private

    def validate(new_period, time_range)
      raise 'Not scheduled hall!' unless hall?(new_period[:hall])
      raise 'Time range overlaps!' if time_range_overlaps?(new_period, time_range)
      true
    end

    def hall?(halls)
      Array(halls).all? { |hall| @halls.include?(hall) }
    end

    def time_range_overlaps?(period, time_range)
      Array(period[:hall]).any? do |hall|
        @periods.any? do |value|
          time_range_overlapsed = (value.first.to_a & time_range.to_a).size > 1
          halls_overlapsed = !(Array(value.last[:hall]) & Array(hall)).empty?
          true if time_range_overlapsed && halls_overlapsed
        end
      end
    end

    def find_schedule(time)
      schedules = get_schedules_by_time(time)
      raise 'Cinema closed!' if schedules.empty?
      choose_hall(schedules).first
    end

    def get_schedules_by_time(time)
      schedule_internal.select { |schedule_time, _| schedule_time.cover?(time.strftime('%H:%M')) }
    end

    def schedule_internal
      @periods.transform_values do |filter|
        unless filter[:filters].nil?
          filter[:filters].transform_values! do |value|
            value.is_a?(Array) ? Regexp.union(value) : value
          end
        end
        filter
      end
    end

    def choose_hall(filters)
      return filters if filters.count == 1
      halls_to_ask = filters.map { |_, value| value[:hall] }.flatten.uniq
      print("Choose hall [#{halls_to_ask.join(' | ')}]: ")
      x = gets.strip.to_sym
      raise 'Wrong hall!' unless halls_to_ask.include?(x)
      filters.select { |_, value| Array(value[:hall]).include?(x) }
    end
  end
end
