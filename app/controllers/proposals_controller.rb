class ProposalsController < ApplicationController
  def new
    @enrollment = Enrollment.find(params[:enrollment_id])
    @proposal = Proposal.new
  end

  def create
    @enrollment = Enrollment.find(params[:enrollment_id])
    @proposal = Proposal.new(proposal_params)
    @proposal.enrollment_id = enrollment.id

    if @proposal.save
      redirect_to @proposal
    else
      render :new
    end
  end

  private
    def proposal_params
      params.require(:proposal).permit(:proposal_message, :proposal_salary, :start_date)
    end
end