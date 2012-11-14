require 'csv'

class Schedule
  include Enumerable

  class Event
    def initialize(fields)
      @fields = Hash[fields]
    end

    def method_missing(name, *args)
      if @fields.has_key?(name.to_s)
        @fields[name.to_s]
      else
        super
      end
    end
  end

  def initialize(input_file)
    @rows = CSV.read input_file
    @field_names = @rows.shift
  end

  def each
    @rows.each do |values|
      yield Event.new(@field_names.zip(values))
    end
  end
end
