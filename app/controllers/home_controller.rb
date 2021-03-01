class HomeController < ApplicationController
  def index
    @jobs = Job.order(created_at: :desc)
  end

  def role
  end
end