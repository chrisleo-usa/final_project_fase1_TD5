class CompaniesController < ApplicationController
  before_action :authenticate_employee!

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])

    if @company.update(company_params)
      redirect_to @company
    else
        render :edit
    end
  end

  private
    def company_params
      params.require(:company).permit(:name, :logo, :address, :cnpj, :site, :social_media)
    end
end