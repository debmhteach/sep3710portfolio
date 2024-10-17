class ApplicationController < ActionController::Base
   #configure_permitted_parameters: method runs before each Devise controller action.
   before_action :configure_permitted_parameters, if: :devise_controller?

   #protected methods in class
   protected

   #configure_permitted_parameters method to allow additional parameters
   #by default devise only allows email, password and password_confirmation
   def configure_permitted_parameters
       # parameters allowed during sign up
       devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :major, :expected_graduation_date])
       # parameters that can be updated
       devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :major, :expected_graduation_date])
   end

end

