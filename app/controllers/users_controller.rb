class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :show, :edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @user_assignments = @user.assignments
  end

  def edit
    @user = current_user
    @user.setup_skills
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(update_user_params)
      CurrentSkill.where(proficiency_level: "0").delete_all
      DesiredSkill.where(interest_level: "0").delete_all
      redirect_to user_path(@user), :notice => "Profile updated."
    else
      redirect_to edit_user_path(@user), :alert => "Unable to update user profile."
    end
  end

  private

    def update_user_params
      params.require(:user).permit(:years_with_company, :manager, :u_position,
                                   :u_department, :u_group, :u_location, :image, 
                                   :current_skills_attributes => [:id, :skill_id, :proficiency_level],
                                   :desired_skills_attributes => [:id, :skill_id, :interest_level]
                                   )
    end
end
