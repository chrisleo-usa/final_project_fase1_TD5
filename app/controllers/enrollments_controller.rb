class EnrollmentsController < ApplicationController
  # before_action :authenticate_employee!, only: [:show]
  # before_action :authenticate_candidate!, only: %i[index show]

  def index
    @enrollments = Enrollment.includes(:job).where(candidate: current_candidate)
  end

  def show
    @enrollment = Enrollment.includes(:job, :candidate).find(params[:id])
  end

  def approve
    enrollment = Enrollment.find(params[:id])

    if enrollment.pending?
      enrollment.approved!
      redirect_to new_enrollment_proposal_path(enrollment)
    elsif enrollment.approved?
      if enrollment.proposal.blank?
        redirect_to new_enrollment_proposal_path(enrollment)
      else
        redirect_to enrollment_path(enrollment), alert: 'Candidate is already approved!'
      end
    end
  end
end