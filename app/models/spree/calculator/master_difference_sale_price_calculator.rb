module Spree
  class Calculator::MasterDifferenceSalePriceCalculator < Spree::Calculator
    def self.description
      "Calculates the sale price for a Variant by taking off a percentage of the original price depending on the master"
    end

    def compute(sale_price)
      master_original_price = sale_price.variant.product.master.original_price.to_f
      master_sales_price = sale_price.value.to_f
      master_sales_in_percent = 100 - ((master_sales_price * 100) / master_original_price)
      variant_sales_price = sale_price.variant.original_price.to_f * ((100 - master_sales_in_percent).to_f / 100).to_f.round(2)

      puts "\n\n ****** I AM COMPUTING STUFF ****** \n\n"
      return variant_sales_price
    end
  end
end