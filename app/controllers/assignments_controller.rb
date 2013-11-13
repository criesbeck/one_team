class AssignmentsController < ApplicationController
  def create 
    @response = Response.find(params[:response_id])
    @assignment = @response.build_assignment(assignment_params)
    @assignment.save
    flash[:notice] = "Developer Selected!"
    redirect_to my_requests_path
  end

  def destroy
    assignment = Assignment.find_by_id(params[:id])  
    if assignment.destroy
      flash[:success] = "Selection Cancelled!"
      redirect_to my_requests_path
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    @request = Request.find_by_id(@assignment.response.request_id)
    if @assignment.update_attributes(assignment_params)
      @request.update_column(:date_completed, Date.today)
      redirect_to my_requests_path, :notice => "Request updated."
    else
      redirect_to my_requests_path, :alert => "Unable to update request."
    end
  end


  private

    def assignment_params
      params.require(:assignment).permit(:comment, 
        :evaluations_attributes => [:experience_points, :proficiency_level_judgment, :assignment_id, :skill_id])
    end
end
