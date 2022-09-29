# **Goal**
# We now want to know how much money must be debited/credited for each actor,
# this will allow us to debit or pay them accordingly.

require_relative '../lib/utils'

class PaymentService
  def initialize
    puts "***=*running 💜 code*=***"
    @cars, @rentals  = Utils::parse_rental_inputs('./data/input.json')
    apply_commission
  end

  # the number of rental days multiplied by the car's price per day
  def apply_commission
    Utils::build_output('./data/output.json') do
      @rentals.map do |rental|
        {
          "id": rental["id"],
          "price": Utils::get_price_per_km(rental, @cars),
          "actions": generate_commission(
                        Utils::get_price_per_km(rental, @cars),
                        Utils::get_timeframe(rental["start_date"], rental["end_date"])
                      )
        }
      end
    end
  end

  # only debit driver and credit other actors
  def get_share_for who, amount
    payment = {}
    payment["amount"] = amount
    payment["who"] = who
    case who
    when "driver"
      payment["type"] = "debit"
    else
      payment["type"] = "credit"
    end
    payment
  end

  # Return the commissions for each merchands.
  def generate_commission(price, number_of_day)
    repartition = []
    repartition << get_share_for("driver", price)

    # Total amount of commission
    commission_amount = (price * 0.3).to_i
    # Repartition for the owner
    repartition << get_share_for("owner", (price - commission_amount).to_i)
    # Repartition for the `assistance`
    repartition << get_share_for("insurance_fee", (commission_amount * 0.5).to_i)
    
    # Repartition and commission that belong to the `assistance`
    commission_amount *= 0.5
    repartition << get_share_for("insurance_fee", number_of_day * 100)

    # Commission that belongs to the `assistance`
    commission_amount -= number_of_day * 100
    
    # Repartition that belongs to `Drivy`
    repartition << get_share_for("drivy_fee", commission_amount.to_i)
    repartition
  end
end

# initialize object
PaymentService.new