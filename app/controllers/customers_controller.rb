class CustomersController < ApplicationController
  skip_before_action :verified_user, only: [:new, :create]

  def new
    @customer = Customer.new
  end

  def create
    customer = Customer.create(customer_params)
    if customer.save
      session[:user_id] = customer.id
      redirect_to customer_path(customer)
    elsif
      message = customer.errors.full_messages.join(", ")
      flash[:message] = message
      redirect_to signup_path
    end
  end

  def show
    @customer = Customer.find_by(id: params[:id])
  end

  def edit
    @customer = Customer.find_by(id: params[:id])
  end

  def update
    customer = Customer.find_by(id: params[:id])
    customer.update(customer_params)
    redirect_to customer_path(customer)
  end

  def destroy
    current_user.delete
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(
      :name,
      :email,
      :password,
      :city,
      :state
    )
  end

end
