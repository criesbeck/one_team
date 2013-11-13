class ResponsesController < ApplicationController

  def create
    @request = Request.find_by_id(params[:request_id])
    @response = @request.responses.new(response_params)
    @response.user_id = current_user.id
    if @response.save
      flash[:notice] = "Response Created!"
      redirect_to requests_path
    else
      render 'new'
    end
  end

  def destroy
    response = Response.find_by_id(params[:id])  
    if response.destroy
      flash[:success] = "Response Cancelled!"
      redirect_to requests_path
    end
  end

  private

    def response_params
      params.require(:response).permit(:comment)
    end

end
