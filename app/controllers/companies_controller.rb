class CompaniesController < ApplicationController
  before_action :authenticate_employee!, only: %i[edit]
  before_action :select_districts, only: %i[edit update]

  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
  end

  def edit
    @company = Company.find(params[:id])
    select_districts
  end

  def update
    @company = Company.find(params[:id])

    if @company.update(company_params)
      redirect_to @company
    else
      render :edit
    end
  end

  def select_districts
    @states = District.states
    @cities = District.cities
  end

  private

  def company_params
    params.require(:company).permit(:name, :logo, :address, :complement, :city, :state, :cnpj, :site, :social_media)
  end
end
