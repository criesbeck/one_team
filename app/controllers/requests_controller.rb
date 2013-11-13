class RequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    @requests = Request.all_except_completed_or_cancelled.page(params[:page]).order("created_at DESC")
    @response = Response.new
    
  end

  def my_requests
    @my_lead_requests = Request.where(user_id: current_user).order("created_at DESC")
    @my_responses = Response.where(user_id: current_user).order("created_at DESC")
    @assignment = Assignment.new
  end

  def new
    @request = Request.new
  end

  def create
    @request = Request.new(request_params)
    @request.user_id = current_user.id
    if @request.save
      flash[:notice] = "Request Created!"
      redirect_to requests_path
    else
      render 'new'
    end
  end

  def update
    @request = Request.find(params[:id])
    if @request.update_attributes(request_params)
      redirect_to requests_path, :notice => "Request updated."
    else
      render 'edit', :alert => "Unable to update request."
    end
  end

  def edit
    @request = Request.find(params[:id])
  end

  private

    def request_params
      params.require(:request).permit(:title, :description, :start_date,
                                   :end_date, :group_name, :office_name, 
                                   :date_cancelled, :date_completed, :skills_needed_ids => [])
    end
end
