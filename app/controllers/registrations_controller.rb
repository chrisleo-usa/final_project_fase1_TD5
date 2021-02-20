class RegistrationsController < Devise::RegistrationsController
  protected

  #TODO: Fazer com que se a empresa ou domínio já existe, então direcionar para a página da empresa. Se não existe, direcionar para new_company_path para cadastrar
  def after_sign_up_path_for(resource)
    new_company_path
  end
end