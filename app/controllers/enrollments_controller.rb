class EnrollmentsController < ApplicationController
  before_action :authenticate_candidate!, only: [:index]

  def index
    @enrollments = Enrollment.includes(:job).where(candidate: current_candidate)
  end
end