html = "<%= f.text_field :price, :value => number_to_currency(@product.potential_sale_price, :unit => ''), 'data-test' => 'test' %>"

Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "potential_sale",
                     :replace => "div#product_price_field",
                     :text => html,
                     :disabled => false)