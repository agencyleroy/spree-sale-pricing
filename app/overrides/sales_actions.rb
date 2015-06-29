html = '
<div class="field" id="product_sale_price_field">
      <label for="product_price">Sale</label>
      <br />
      <% if @product.on_sale? == true %>
        <br />
        <%= link_to "Disable Sale", admin_sale_price_disable_sale_path(@product.id), :class => "button icon-cancel" %>
        <br /><br />
      <label>Original price:</label>
      <br />
      <p><%= @product.original_price.to_f %></p>
      <% else %>
        <br />
        <%= link_to "Enable Sale", admin_sale_price_enable_sale_path + "?product_id=#{@product.id}", :class => "button icon-plus" %>
      <% end %>
</div>
  
'

Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                     :name => "sales_actions",
                     :insert_top => "[data-hook='admin_product_form_right']",
                     :text => html,
                     :disabled => false)
