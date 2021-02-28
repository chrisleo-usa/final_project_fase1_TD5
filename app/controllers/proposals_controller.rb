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
      redirect_to enrollment_path(@enrollment), notice: 'Candidate approved, proposal successfully created'
    else
      render :new
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
  end

  # def edit
  #   @enrollment = Enrollment.find(params[:enrollment_id])
  #   @proposal = Proposal.find(params[:id])
  # end

  # def update
  #   @enrollment = Enrollment.find(params[:enrollment_id])
  #   @proposal = Proposal.find(params[:id])

  #   if @proposal.update(proposal_message)
  #     redirect_to @proposal, notice: 'A new proposal has been send'
  #   else
  #     render :edit
  #   end
  # end

  private
    def proposal_params
      params.require(:proposal).permit(:proposal_message, :proposal_salary, :start_date)
    end
end