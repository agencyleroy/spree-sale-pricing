Spree::Variant.class_eval do
  has_many :sale_prices

  # TODO also accept a class reference for calculator type instead of only a string
  def put_on_sale(value, calculator_type = "Spree::Calculator::DollarAmountSalePriceCalculator", start_at = Time.now, end_at = nil, enabled = true)
    sale_price = sale_prices.new({ value: value, start_at: start_at, end_at: end_at, enabled: enabled })
    sale_price.calculator_type = calculator_type
    sale_price.save
  end
  alias :create_sale :put_on_sale

  # TODO make update_sale method

  def active_sale
    on_sale? ? sale_prices.active.order("created_at DESC").first : nil
  end
  alias :current_sale :active_sale

  def next_active_sale
    sale_prices.present? ? sale_prices.order("created_at DESC").first : nil
  end
  alias :next_current_sale :next_active_sale

  def sale_price
    on_sale? ? active_sale.price : nil
  end

  def on_sale?
    sale_prices.active.present?
  end

  def original_price
    a = self.id
    # currency = self.cost_currency
    currency = "EUR" # HARDCODED
    if a.present?
      b = Spree::Price.where(:variant_id => a).where(:currency => currency).first.try(:amount) || nil
    else
      b = nil
    end
    return b
  end

  def potential_sale_price
    on_sale? ? sale_price : original_price
  end

  alias_method :orig_price_in, :price_in
  def price_in(currency)
    return orig_price_in(currency) unless sale_price.present?
    Spree::Price.new(:variant_id => self.id, :amount => self.sale_price, :currency => currency)
  end

  def enable_sale
    return nil unless next_active_sale.present?
    next_active_sale.enable
  end

  def disable_sale
    return nil unless active_sale.present?
    active_sale.disable
  end

  def start_sale(end_time = nil)
    return nil unless next_active_sale.present?
    next_active_sale.start(end_time)
  end

  def stop_sale
    return nil unless active_sale.present?
    active_sale.stop
  end
end
