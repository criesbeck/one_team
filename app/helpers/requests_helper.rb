module RequestsHelper
  def setup_evaluation(request, response)
    @assignment = Assignment.find_by_response_id(response.id)
    @request_assigned_user = User.find(Response.find(@assignment.response_id).user_id)
    assigned_user_skills = (@request_assigned_user.cskills + @request_assigned_user.dskills).uniq
    assigned_skills_match = request.find_matching_skills(assigned_user_skills)
    @total_project_days = (Date.today - request.start_date).to_i
    assigned_skills_match.each do |skill|
        @assignment.evaluations.build(skill_id: skill.id)
    end
  end
end
