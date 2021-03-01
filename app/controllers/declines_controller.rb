class DeclinesController < ApplicationController
  before_action :authenticate_candidate!, only: %i[new]

  def new
    @proposal = Proposal.find(params[:proposal_id])
    @decline = Decline.new
  end

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @decline = Decline.new(decline_params)
    @decline.proposal_id = @proposal.id

    if @decline.save
      redirect_to proposal_path(@proposal), notice: 'Proposal declined with success!'
    else
      render :new
    end
  end

  private
    def decline_params
      params.require(:decline).permit(:reason)
    end
end