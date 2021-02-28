class CandidatesController < ApplicationController
  before_action :authenticate_candidate!, only: %i[index]

  def show
    @candidate = Candidate.find(params[:id])
  end

end