require 'spec_helper'

describe "Request pages" do

  let!(:user)     { FactoryGirl.create(:user)}
  let!(:group)    { FactoryGirl.create(:group) }
  let!(:location) { FactoryGirl.create(:location) }
  let!(:skill1)   { FactoryGirl.create(:skill, name: "Skill 1") }
  let!(:skill2)   { FactoryGirl.create(:skill, name: "Skill 2") }

  subject { page }

  describe "When signed in" do
    before do
      visit new_user_session_path
      fill_in "Email",    with: user.email.upcase
      fill_in "Password", with: user.password
      click_button "Login"
    end

    describe "index page" do
      let!(:r1) { FactoryGirl.create(:request, user_id: 2) }

      before do 
        visit requests_path
      end

      it {should have_title('OneTeam') }
      
      describe "all requests tab" do
        it {should have_content 'All Requests'}
        describe "requests information" do
          it { should have_content(r1.title) }
          it { should have_content(r1.description) }
          it { should have_content(r1.start_date)}
          it { should have_content(r1.end_date)}
          it { should have_content(r1.group_name)}
          it { should have_content(r1.office_name)}

          describe "for cancelled requests" do
            before do 
              r1.date_cancelled = Date.today
              r1.save
              visit requests_path
            end
            it { should_not have_content(r1.title)}
          end
          
          describe "for completed requests" do
            before do 
              r1.date_completed = Date.today
              r1.save
              visit requests_path
            end
            it { should_not have_content(r1.title)}
          end
        end
        
        # describe "responding to a request", :js => true do
        #   before do
        #     click_on('Apply')
        #     fill_in "Comment", with: "I'm interested."
        #   end
        #   it "should create a response" do
        #     expect { click_button "Confirm Application" }.to change(Response, :count).by(1)
        #   end
        # end

        # describe "cancelling a response", :js => true do
        #   let!(:response){FactoryGirl.create(:response)}
        #   before do 
        #     visit requests_path
        #     click_on 'Cancel Application'
        #     page.driver.browser.switch_to.alert.accept
        #   end
        #   it {should_not have_content 'Cancel Application' }
        # end
      end
    end

    # describe "new request page" do
    #   before do
    #     visit new_request_path
    #   end
    #   describe "create a request" do
        
    #     describe "with valid information" do
    #       before do
    #         fill_in "Title",          with: "Example Title"
    #         fill_in "Description",    with: "Example description"
    #         fill_in "Start Date",     with: Date.today
    #         fill_in "End Date",       with: Date.today + 1.month   
    #         select "Example group",   :from => "Group"
    #         select "Example location",:from => "Office"
    #         check("Skill 1")
    #         check("Skill 2")
    #       end
    #       it "should create a request" do
    #         expect { click_button "Create Request" }.to change(Request, :count).by(1)
    #       end
    #     end
    #   end
    # end

    describe "editing a request" do
      let!(:r2) { FactoryGirl.create(:request, user_id: 1) }
      let(:new_title) { "New Title" }
      
      before do
        visit requests_path
        click_on 'Edit Request'
        fill_in 'Title', with: new_title
      end
      describe "update request" do
        describe "with valid information" do
          before do
            fill_in 'Title', with: new_title
            click_button 'Update Request'
          end
          specify { expect(r2.reload.title).to eq new_title }
        end

        describe "with invalid information" do
          before do
            fill_in 'Title', with: ''
            click_button 'Update Request'
          end
          specify { expect(r2.reload.title).not_to eq new_title }
        end
      end

      # describe "cancel request", :js => true do
      #   before do
      #     click_button 'Cancel Request'
      #     page.driver.browser.switch_to.alert.accept
      #   end
      #   it {should_not have_content r2.title}
      # end
    end
  end
end
