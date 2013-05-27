class RegistrationsController < ApplicationController
  def index
    @registration = Registration.new
    @users = User.order(:name, :login)
  end

  def create
    @registration = Registration.new(params[:registration])
    if @registration.save
      redirect_to :root_path
    else
      @users = User.order(:name, :login)
      render :index
    end
  end
end
