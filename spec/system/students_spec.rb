require 'rails_helper'

RSpec.describe "Students", type: :system do


  describe "Student Registration" do
     # New user with correct information
    context "new user with correct information" do
      it "allows a user to sign up" do
        visit new_student_registration_path
        fill_in "First name", with: "Capybara"
        fill_in "Last name", with: "Rspec"
        fill_in "Password", with: "password"
        select "Computer Science BS", from: "Major"
        fill_in "Expected graduation date", with: "2025-05-10"
        fill_in "Email", with: "cr@msudenver.edu"
        fill_in "Password", with: "password"     
        fill_in "Password confirmation", with: "password"
        click_button "Sign up"
        expect(page).to have_content("Welcome! You have signed up successfully.")
      end

    # New user with incorrect information

    end 
  end #end describe student registration testing

end
