class ProposalsController < ApplicationController
  def new
    @enrollment = Enrollment.find(params[:enrollment_id])
    @proposal = Proposal.new
  end

  def create
    @enrollment = Enrollment.find(params[:enrollment_id])
    @proposal = Proposal.new(proposal_params)
    @proposal.enrollment_id = @enrollment.id

    if @proposal.save
      redirect_to proposal_path(@proposal), notice: 'Candidate approved, proposal successfully created'
    else
      render :new
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
  end

  def decline
    proposal = Proposal.find(params[:id])

    if proposal.pending?
      proposal.declined!
      redirect_to new_proposal_decline_path(proposal)
    elsif proposal.declined?
      if proposal.decline.blank?
        redirect_to new_proposal_decline_path(proposal)
      else
      redirect_to proposal_path(proposal), alert: 'You already declined this proposal'
      end
    end
  end

  private
    def proposal_params
      params.require(:proposal).permit(:proposal_message, :proposal_salary, :start_date)
    end
end