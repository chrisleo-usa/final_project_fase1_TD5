class JobsController < ApplicationController
  before_action :authenticate_employee!, only: %i[new edit]
  before_action :authenticate_candidate!, only: [:apply]
  before_action :select_level, only: %i[new edit]
  before_action :select_type, only: %i[new edit]

  def index
    @jobs = Job.all
    @company = Company.find(params[:company_id])
  end

  def show
    @job = Job.find(params[:id])
    @enrollments = Enrollment.includes(:candidate).where(job: @job)
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
      select_level
      select_type
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
      redirect_to company_job_path(@job.company, @job)
    else
      select_level
      select_type
      render :edit
    end
  end

  def disable
    @job = Job.find(params[:id])
    if @job.inactive?
      redirect_to @job.company, notice: t('.already_disabled')
    elsif current_employee.company != @job.company
      redirect_to root_path, notice: t('.other_company')
    else
      @job.inactive!
      redirect_to @job.company
    end
  end

  def apply
    @job = Job.find(params[:id])

    if @job.inactive?
      redirect_to company_job_path(@job.company, @job), alert: t('.inactivated')
    elsif @job.active?
      if @job.applied(current_candidate)
        redirect_to candidate_enrollments_path(current_candidate), notice: t('.sucess')
      else
        redirect_to company_job_path(@job.company, @job), alert: t('.already_applied')
      end
    end
  end

  private

  def select_level
    @levels = Job.levels
  end

  def select_type
    @types = Job.type_hirings
  end

  def job_params
    params.require(:job).permit(:title, :level, :type_hiring, :description, :salary_range,
                                :requirements, :deadline_application, :total_vacancies, :status)
  end
end
