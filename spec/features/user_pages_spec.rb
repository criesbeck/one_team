require 'spec_helper'

describe "User pages" do
  
  let!(:user)     { FactoryGirl.create(:user)}
  let!(:group)    { FactoryGirl.create(:group) }
  let!(:location) { FactoryGirl.create(:location) }
  let!(:position) { FactoryGirl.create(:position)}
  let!(:department) {FactoryGirl.create(:department)}

  let!(:skill1){FactoryGirl.create(:skill, name: "Skill 1")}
  let!(:skill2){FactoryGirl.create(:skill, name: "Skill 2")}
  let!(:skill3){FactoryGirl.create(:skill, name: "Skill 3")}
  let!(:skill4){FactoryGirl.create(:skill, name: "Skill 4")}

  let!(:current_skill1){FactoryGirl.create(:current_skill, skill_id: 1, user_id: 1)}
  let!(:current_skill2){FactoryGirl.create(:current_skill, skill_id: 2, user_id: 1)}

  # let!(:desired_skill1){FactoryGirl.create(:desired_skill, skill_id: 3, user_id: 1)}
  # let!(:desired_skill2){FactoryGirl.create(:desired_skill, skill_id: 4, user_id: 1)}

  subject { page }

  describe "can create a new account" do
    let(:name){"Name"}
    let(:email){"example@email.com"}
    let(:password){"password"}
    before do
      visit new_user_registration_path
      fill_in "Name", with: name
      fill_in "Email", with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password
    end
    it "should create a new user" do
      expect { click_button "Sign Up" }.to change(User, :count).by(1)
    end
  end  

  describe "when signed in" do
    before do
      visit new_user_session_path
      fill_in "Email",    with: user.email.upcase
      fill_in "Password", with: user.password
      click_button "Login"
    end

    describe "the user show page" do
      before { visit user_path(user.id)}
      it {should have_content "Test User"}
      # it {should have_content user.avatar}
      it {should have_content "example@example.com"}
      it {should have_content "1 year"}
      it {should have_content "Example Manager"}
      it {should have_content "Example Position"}
      it {should have_content "Example Department"}
      it {should have_content "Example Group"}
      it {should have_content "Example Location"}
      it {should have_content "Current Skills: Skill 1, Skill 2"}
      # it {should have_content "Desired Skills: Skill 3, Skill 4"}
    end

    describe "edit" do
      
      describe "update settings" do
        before {visit edit_user_registration_path}
        it {should have_content "Edit Account Settings"}

        describe "with valid information" do
          let(:new_email) { "new@example.com" }
          before do
            fill_in "Email",  with: new_email
            fill_in "Current Password", with: user.password
            click_button "Save Changes"
          end

          specify { expect(user.reload.email).to eq new_email }
          it { should have_selector('div.alert.alert-success') }
        end

        describe "with wrong password" do
          let(:new_email) { "new@example.com" }
          before do
            fill_in "Email",  with: new_email            
            fill_in "Current Password", with: "abcdefg"
            click_button "Save Changes"
          end
          specify { expect(user.reload.email).not_to eq new_email }
          it { should_not have_selector('div.alert.alert-success') }
        end
      end

      describe "update profile" do
        before {visit edit_user_path(user)}
        it {should have_content "Edit Profile"}
        
        describe "with valid settings" do
          let(:new_manager) {"Chris"}
          let!(:new_group) { FactoryGirl.create(:group, name: "Development") }
          let!(:new_location) { FactoryGirl.create(:location, name: "Tokyo") }
          let!(:new_position) { FactoryGirl.create(:position, name: "Engineer") }
          let!(:new_department) { FactoryGirl.create(:department, name: "IT") }

          before do 
            visit edit_user_path(user)
            fill_in "Immediate Supervisor", with: new_manager
            select new_position.name,   :from => "Position"
            select new_department.name,:from => "Department"
            select new_group.name,   :from => "Group"
            select new_location.name,:from => "Office"
            click_button "Save Changes"
          end
          specify { expect(user.reload.manager).to eq new_manager}
          specify { expect(user.reload.u_position).to eq new_position.name}
          specify { expect(user.reload.u_department).to eq new_department.name}                    
          specify { expect(user.reload.u_group).to eq new_group.name}
          specify { expect(user.reload.u_location).to eq new_location.name}
          it { should have_selector('div.alert.alert-success') }
        end
      end
    end
  end
end
