class Spree::Admin::SalePricesController < Spree::Admin::ResourceController
  def index
    @sales = Spree::SalePrice.all
  end

  def put_on_sale
    raise "sale"
  end

  def show
    @sale_price = Spree::SalePrice.find(params[:id])
  end

  def disable_sale
    @sale = Spree::Product.find(params[:sale_price_id])
    if @sale.stop_sale
      redirect_to admin_product_path(@sale.slug), success: 'Sale was successfully stopped.'
    else
      redirect_to admin_product_path(@sale.slug)
    end
  end

  def new
    @sale_price = Spree::SalePrice.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sale_price }
    end
  end

  def create
    # authorize! :create, @sale
    @product = Spree::Product.find_by_id(params[:sale_price]["product_id"])
    @new_price = params[:sale_price]["value"]

    respond_to do |format|
      if @product.put_on_sale(@new_price)
        format.html { redirect_to admin_product_path(@product), success: 'Sale was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
end
