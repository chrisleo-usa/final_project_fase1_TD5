class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :store_action
  helper_method :require_admin
  helper_method :is_admin?

  private
    def store_action
      return unless request.get? 
      if (request.path != "/candidates/sign_in" &&
          request.path != "/candidates/sign_up" &&
          request.path != "/candidates/password/new" &&
          request.path != "/candidates/password/edit" &&
          request.path != "/candidates/confirmation" &&
          request.path != "/candidates/sign_out" &&
          !request.xhr?)
        store_location_for(:candidate, request.fullpath)
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user_params|
        user_params.permit(:email, :password, :password_confirmation, :company_id, :admin, :name, :cpf, :phone, :biography)
      end

      devise_parameter_sanitizer.permit(:account_update) do |user_params|
        user_params.permit(:email, :password, :password_confirmation, :current_password, :company_id, :admin, :name, :cpf, :phone, :biography)
      end
    end

    def after_sign_in_path_for(resource)
      if candidate_signed_in?
        candidate_path(current_candidate)
      else 
        company_path(current_employee.company)
      end 
    end
end
