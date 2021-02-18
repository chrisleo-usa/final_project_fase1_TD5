class RegistrationsController < Devise::RegistrationsController
  before_action :create_domain!, only: [:create], unless: :domain_exists?


  @new_company_redirect_seletor = false

  protected

  def after_sign_up_path_for(resource)
    if @new_company_redirect_seletor
      new_company_path
    else
      company_path
    end
  end

  def domain_exists?
    Domain.exists?(name: extract_domain_from_params)
  end

  def create_domain!
    Domain.create!(name: extract_domain_from_params)
    @new_company_redirect_seletor = true
  end

  def extract_domain_from_params
    params[:employee][:email].gsub(/.+@([^.]+).+/, '\1').downcase
  end
end