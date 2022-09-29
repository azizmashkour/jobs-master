require 'json'
require 'date'

<<-RETURN
  This `helper` contains a list of reusable `functions` accross
  all the app. Should be included in all the challenge levels
  to make it works. Otherwise, the code will get broken. It's actually used in:
    - [Level1](../level1/main.rb)
    - [Level2](../level2/main.rb)
    - [Level3](../level3/main.rb)
    - [Level4](../level4/main.rb)
RETURN

module Utils
  class << self
    def load_input file_path
      file           = File.read(file_path)
      return_json    = JSON.parse(file)
      cars           = return_json["cars"]
      rentals        = return_json["rentals"]
      return cars, rentals
    end

    # Code that creates a new `data/output.json` file.
    def build_output output_path
      output_data            = {}
      output_data["rentals"] = yield
      File.write(output_path, JSON.dump(output_data))
    end

    # Return the total number of days for any timeframe given
    def get_timeframe start_date, end_date
      (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
    end

    # apply reduction on pricing per day.
    def apply_discount day, daily_price
      results = 0
      case day.to_i
        when 1..3
          results = daily_price * 0.9 # 10% reduction
        when 4..9
          results = daily_price * 0.7 # 30% reduction
        when 10..
          results = daily_price * 0.5 # 50% reduction
        else
          results = daily_price
      end
      results.to_i
    end

  # sum total discount per day and per distance
  def get_rental_duration_price car, rental
    timeframe         = get_timeframe(rental["start_date"], rental["end_date"])
    discount_price    = 0
    for day in 0...timeframe
      discount_price += apply_discount(day, car["price_per_day"])
    end
    discount_price   += car["price_per_km"] * rental["distance"]
  end

    # calculate and return the rental price per car.
    def get_price_per_km rental, cars
      for car in cars
        if (car["id"] == rental["car_id"])       
          return get_rental_duration_price(car, rental).to_i
        end
      end
    end
  end
end