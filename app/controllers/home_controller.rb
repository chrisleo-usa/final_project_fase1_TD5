class HomeController < ApplicationController
  def index
    @jobs = Job.order(created_at: :desc).limit(4)
  end

  def search
    @jobs = Job.where('title like ? OR description like ?', 
                      "%#{params[:q]}%", "%#{params[:q]}%")
  end

  def role
  end
end