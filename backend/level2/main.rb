# **Goal**
# To be as competitive as possible, we decide to have a decreasing pricing for longer rentals.

require_relative '../lib/utils'

class DecreaseService
  def initialize
    puts "***=*running 💜 code*=***"
    @cars, @rentals  = Utils::load_input('./data/input.json')
    decrease_pricing
  end

  # return the total rental price with discount applied
  def decrease_pricing
    Utils::build_output('./data/output.json') do
      @rentals.map do |rental|
        {
          "id": rental["id"],
          "price": Utils::get_price_per_km(rental, @cars)
        }
      end
    end
  end
end

# initialize object
DecreaseService.new