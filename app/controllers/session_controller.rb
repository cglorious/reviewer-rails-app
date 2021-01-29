class SessionController < ApplicationController
  skip_before_action :verified_user

  def new
    @customer = Customer.new
  end

  def create
    if auth = request.env['omniauth.auth']
      if @customer = Customer.find_by(email: auth['info']['email'])
      else
        password = auth['info']['name'].split(" ")[0].downcase
        @customer = Customer.create(
          email: auth['info']['email'],
          name: auth['info']['name'],
          password: password,
          location: "Earth, Solar System"
        )
        #location: auth['raw_info']['location']
      end
        session[:user_id] = @customer.id
        redirect_to customer_path(@customer)
    elsif
      @customer = Customer.find_by(email: params[:customer][:email])
      if @customer && @customer.authenticate(params[:customer][:password])
        session[:user_id] = @customer.id
        redirect_to customer_path(@customer)
      else
        flash[:message] = "Please enter correct log in information."
        redirect_to '/login'
      end
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
