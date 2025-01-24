module Tenkit
  class Conditions
    def initialize(conditions)
      return if conditions.nil?

      conditions.each do |key, val|
        name = snake(key)
        singleton_class.class_eval { attr_accessor name }
        if val.is_a?(Array)
          val = if key == "days"
            val.map { |e| DayWeatherConditions.new(e) }
          elsif key == "hours"
            val.map { |e| HourWeatherConditions.new(e) }
          else
            val.map { |e| Conditions.new(e) } # just in case
          end
        elsif val.is_a?(Hash)
          val = if key == "metadata"
            Metadata.new(val)
          elsif key == "daytimeForecast"
            DaytimeForecast.new(val)
          elsif key == "overnightForecast"
            OvernightForecast.new(val)
          elsif key == "restOfDayForecast"
            RestOfDayForecast.new(val)
          else
            Conditions.new(val)
          end
        end
        instance_variable_set(:"@#{name}", val)
      end
    end

    def snake(str)
      return str.underscore if str.respond_to? :underscore
      str.gsub(/(.)([A-Z])/, '\1_\2').sub(/_UR_L$/, "_URL").downcase
    end
  end

  class CurrentWeather < Conditions; end

  class HourlyForecast < Conditions; end

  class DailyForecast < Conditions; end

  class HourWeatherConditions < Conditions; end

  class DayWeatherConditions < Conditions; end

  class Metadata < Conditions; end

  class DaytimeForecast < Conditions; end

  class OvernightForecast < Conditions; end

  class RestOfDayForecast < Conditions; end
end
