class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy, :activate, :deactivate]

  before_action :authenticate_admin!

  def index
    @restaurants = Restaurant.order(:name)
  end

  def show
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to restaurants_path, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to restaurants_path, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def activate
    @restaurant.activate!
    respond_to do |format|
      format.html { redirect_to restaurants_path, notice: 'Restaurant was successfully activated.' }
      format.json { render :show, status: :ok, location: @restaurant }
    end
  end

  def deactivate
    @restaurant.deactivate!
    respond_to do |format|
      format.html { redirect_to restaurants_path, notice: 'Restaurant was successfully disabled.' }
      format.json { render :show, status: :ok, location: @restaurant }
    end
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:name, :owner, :active, :user_id)
    end
end
