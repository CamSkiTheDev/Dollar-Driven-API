class PropertiesController < ApplicationController
  before_action :authorized
  before_action :set_property, only: [:show, :update, :destroy]

  # GET /properties
  def index
    @properties = Property.where(user_id: @user.id)

    render json: @properties
  end

  # GET /properties/1
  def show
    render json: @property
  end

  # POST /properties
  def create
    @property = Property.new(property_params)
    @property.user_id = @user.id

    # gets sales price data from api
    sales_price_response = Faraday.get('https://realty-mole-property-api.p.rapidapi.com/salePrice',
       {
        address: property_params['street_adderss']
       },
       {
         'x-rapidapi-key' => '8530900db9msh81bd1903affac7dp1829a3jsn6a3cd0bd93e0',
         'x-rapidapi-host' => 'realty-mole-property-api.p.rapidapi.com'
       }
    )

    # Parses json data from response
    sales_data = JSON.parse(sales_price_response.body)

    # Sets property information using json data from response
    @property.estimated_value = sales_data['priceRangeLow']
    @property.after_repair_value = sales_data['priceRangeHigh']

    # gets rent price data from api
    rent_estimation_response = Faraday.get('https://realty-mole-property-api.p.rapidapi.com/rentalPrice',
      {
        address: property_params['street_adderss']
      },
      {
        'x-rapidapi-key' => '8530900db9msh81bd1903affac7dp1829a3jsn6a3cd0bd93e0',
        'x-rapidapi-host' => 'realty-mole-property-api.p.rapidapi.com'
      }
    )

    # Parses json data from response
    rent_data = JSON.parse(rent_estimation_response.body)

    # Sets property information using json data from response
    @property.estimated_rent = rent_data['rentRangeHigh']

    
    if @property.save
      render json: @property, status: :created, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    if @property.update(property_params)
      render json: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(:user_id, :street_adderss, :estimated_value, :after_repair_value, :estimated_rent)
    end
end
