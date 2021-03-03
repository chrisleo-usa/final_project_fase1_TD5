class EnrollmentsController < ApplicationController
  before_action :authenticate_employee!, only: %i[approve reject]
  before_action :authenticate_candidate!, only: %i[index]

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
        redirect_to enrollment_path(enrollment), alert: 'Esta inscrição já está aprovada!'
      end
    end
  end

  def reject
    enrollment = Enrollment.find(params[:id])

    if enrollment.pending?
      enrollment.denied!
      redirect_to new_enrollment_reject_path(enrollment)
    elsif enrollment.denied?
      if enrollment.reject.blank?
        redirect_to new_enrollment_reject_path(enrollment)
      else
      redirect_to enrollment_path(enrollment), alert: 'Esta inscrição já foi reprovada!'
      end
    end
  end
end