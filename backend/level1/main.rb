# The car owner chooses a price per day and price per km for her car.
# The driver then books the car for a given period and an approximate distance.

require_relative '../lib/utils'

class OutputService
  def initialize
    puts "***=*running 💜 code*=***"
    @cars, @rentals  = Utils::load_input('./data/input.json')
    execute_getaround
  end

  # the number of rental days multiplied by the car's price per day
  def execute_getaround
    Utils::build_output('./data/output.json') do
      @rentals.map do |rental|
        {
          "id": rental["id"],
          "price": price_per_km(rental, @cars)
        }
      end
    end
  end

  # calculate and return the rental price per car.
  def price_per_km rental
    count           = 0
    for car in @cars
      if (car["id"] == rental["car_id"])
        <<-RETURN
         sum of (the number of rental days multiplied by the car's price per day)
         in addition to (the number of km multiplied by the car's price per km).
        RETURN
        count       = get_price_per_date(car, rental) + get_price_per_km(car, rental)
      end
    end
    count
  end

  def get_price_per_date car, rental
    car["price_per_day"] * Utils::get_timeframe(rental["start_date"], rental["end_date"])
  end

  def get_price_per_km car, rental
    car["price_per_km"] * rental["distance"]
  end
end

# initialize object
OutputService.new