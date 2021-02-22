class JobsController < ApplicationController
  before_action :authenticate_employee!, only: %i[new edit]
  before_action :select_level, only: %i[new edit]

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @company = Company.find(params[:company_id])
    @job = Job.new
  end

  def create
    @company = Company.find(params[:company_id])
    @job = Job.new(job_params)
    @job.company_id = @company.id

    if @job.save
      redirect_to @job.company
    else
      select_level()
      render :new
    end
  end

  def edit
    @company = Company.find(params[:company_id])
    @job = Job.find(params[:id])
  end

  def update
    @company = Company.find(params[:company_id])
    @job = Job.find(params[:id])

    if @job.update(job_params)
      redirect_to @job.company
    else
      select_level()
      render :edit
    end
  end

  def disable
    @job = Job.find(params[:id])
    @job.inactive!
    redirect_to @job.company
  end

  private
    def select_level
      @levels = Job.levels
    end

    def job_params
      params.require(:job).permit(:title, :level, :description, :salary_range, :requirements, :deadline_application, :total_vacancies, level_ids: [])
    end
end