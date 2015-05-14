class RegistrationsController < Devise::RegistrationsController
  private

    def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :phone, :services_offered, :city, :zipcode, :email, :password, :password_confirmation, :current_password)
    end

    def account_update_params
      params.require(:user).permit(:first_name, :last_name, :phone, :services_offered, :city, :zipcode, :email, :password, :password_confirmation, :current_password)
    end
end
