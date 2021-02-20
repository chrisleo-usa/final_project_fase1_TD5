class JobsController < ApplicationController
  before_action :authenticate_employee!
  before_action :select_level, only: %i[new edit]

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

  private
    def select_level
      @levels = Job.levels
    end

    def job_params
      params.require(:job).permit(:title, :level, :description, :salary_range, :requirements, :deadline_application, :total_vacancies, level_ids: [])
    end

end