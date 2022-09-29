# **Goal**
# To be as competitive as possible, we decide to have a decreasing pricing for longer rentals.

require_relative '../lib/utils'

class CommissionService
  def initialize
    puts "***=*running 💜 code*=***"
    @cars, @rentals  = Utils::load_input('./data/input.json')
    apply_commission
  end

  # the number of rental days multiplied by the car's price per day
  def apply_commission
    Utils::build_output('./data/output.json') do
      @rentals.map do |rental|
        {
          "id": rental["id"],
          "price": Utils::get_price_per_km(rental, @cars),
          "commission": generate_commission(
                          Utils::get_price_per_km(rental, @cars),
                          Utils::get_timeframe(rental["start_date"], rental["end_date"])
                        )
        }
      end
    end
  end

  # Return the commissions for each merchands.
  def generate_commission price, number_of_day
    commission_amount            = (price * 0.3).to_i # Total amount of commission
    commission                   = {}
    
    # Commission that belongs to the insurance
    commission["insurance_fee"]  = (commission_amount * 0.5).to_i
    commission_amount           *= 0.5

    # Commission that belongs to the assistance
    commission["assistance_fee"] = number_of_day * 100
    commission_amount           -= number_of_day* 100
    
    # Commission that belongs to Drivy
    commission["drivy_fee"]      = commission_amount.to_i
    commission
  end
end

# initialize object
CommissionService.new