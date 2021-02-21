class JobsController < ApplicationController
  before_action :authenticate_employee!
  before_action :select_level, only: %i[new edit]

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to @job
    else
      select_level()
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])

    if @job.update(job_params)
      redirect_to @job
    else
      select_level()
      render :edit
    end
  end

  private
    def select_level
      @levels = Job.levels
    end

    def job_params
      params.require(:job).permit(:title, :level, :description, :salary_range, :requirements, :deadline_application, :total_vacancies, level_ids: [])
    end

end