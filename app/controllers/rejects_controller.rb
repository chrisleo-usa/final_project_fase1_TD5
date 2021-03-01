class RejectsController < ApplicationController
  before_action :authenticate_employee!, only: %i[new]

  def new
    @enrollment = Enrollment.find(params[:enrollment_id])
    @reject = Reject.new
  end

  def create
    @enrollment = Enrollment.find(params[:enrollment_id])
    @reject = Reject.new(reject_params)
    @reject.enrollment_id = @enrollment.id

    if @reject.save
      redirect_to enrollment_path(@enrollment), notice: 'Enrollment rejected'
    else
      render :new
    end
  end

  private
    def reject_params
      params.require(:reject).permit(:message)
    end
end