class AcceptsController < ApplicationController
  before_action :authenticate_candidate!, only: %i[new]

  def new
    @proposal = Proposal.find(params[:proposal_id])
    @accept = Accept.new
  end

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @accept = Accept.new(accept_params)
    @accept.proposal_id = @proposal.id

    if @accept.save
      redirect_to proposal_path(@proposal), notice: 'Congratulations! Welcome to your new job!'
    else
      render :new
    end
  end

  private
    def accept_params
      params.require(:accept).permit(:start_date)
    end
end