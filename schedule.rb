require 'csv'
require 'date'

class Schedule
  include Enumerable

  class Event
    def initialize(fields)
      @fields = Hash[fields]
    end

    def method_missing(name, *args)
      if @fields.has_key?(name.to_s)
        get name
      else
        super
      end
    end

    def get(field)
      field = field.to_s
      value = @fields[field]

      case field
      when 'date'
        Date.parse(value)
      when /_at$/
        date = get 'date'
        hour, min, sec = value.split(':').map(&:to_i)
        Time.new date.year, date.month, date.day, hour, min, sec
      else
        value
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
