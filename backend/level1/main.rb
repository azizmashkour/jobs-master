# The car owner chooses a price per day and price per km for her car. The driver then books the car for a given period and an approximate distance.

# The rental price is the sum of:
require 'json'
require 'date'

file            = File.read('./data/input.json')
return_json     = JSON.parse(file)
CARS            = return_json["cars"]
RENTALS         = return_json["rentals"]
PRICES          = []

class OutputService
  attr_reader :title, :date

  def initialize
    puts "***=*running 💜 code*=***"
    execute_getaround
  end

  # the number of rental days multiplied by the car's price per day
  def execute_getaround
    for rental in RENTALS
      output_data_json          = {}
      output_data_json["id"]    = rental["id"]
      output_data_json["price"] = get_price_per_km(rental)
      PRICES << output_data_json
    end
    build_output
  end

  # calculate and return the rental price per car.
  def get_price_per_km rental
    count           = 0
    for car in CARS
      if (car["id"] == rental["car_id"])
        <<-RETURN
         sum of (the number of rental days multiplied by the car's price per day)
         in addtion to (the number of km multiplied by the car's price per km).
        RETURN
        count = car["price_per_day"]*get_timeframe(rental["start_date"], rental["end_date"]) + car["price_per_km"]*rental["distance"] 
      end
    end
    count
  end

  # Return the total number of days for any timeframe given
  def get_timeframe start_date, end_date
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  # Code that creates a new `data/output.json` file from the data in `data/input.json`.
  def build_output
    output            = {}
    output["rentals"] = PRICES
    File.write('./data/output.json', JSON.dump(output))
  end
end

# initialize object
OutputService.new