class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  def index
  	@listings = Listing.all
  end
  def show
  	@listing = Listing.find(params[:id])
  end
  def new
  	@listing = Listing.new
  end
  private
  def listing_params
  	params.require(:listing).permit(:address,:price,:description)
  end
  protect_from_forgery with: :exception
end
