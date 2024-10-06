require 'rails_helper'

RSpec.describe "Students", type: :request do

  # GET /students (index)
  describe "GET /students" do
    context "when students exist" do
      let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }

      # Test 1: Returns a successful response and displays the search form
      it "returns a successful response and displays the search form" do
        get students_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Search') # Ensure search form is rendered
      end

      # Test 2: Ensure it does NOT display students without a search
      it "does not display students until a search is performed" do
        get students_path
        expect(response.body).to_not include("Aaron")
      end
    end

    # Test 3: Handle missing records or no search criteria provided
    context "when no students exist or no search is performed" do
      it "displays a message prompting to search" do
        get students_path
        expect(response.body).to include("Please enter search criteria to find students")
      end
    end
  end

  # Separate describe block for the search functionality
  describe "GET /students (search functionality)" do
    let!(:student1) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }
    let!(:student2) { Student.create!(first_name: "Jackie", last_name: "Joyner", school_email: "joyner@msudenver.edu", major: "Data Science and Machine Learning Major", expected_graduation_date: "2026-05-15") }

    # Test 4: Search by major
    it "returns students matching the major" do
      get students_path, params: { search: { major: "Computer Science BS" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 5: Search by expected graduation date (before)
    it "returns students graduating before the given date" do
      get students_path, params: { search: { expected_graduation_date: "2026-01-01", date_type: "before" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 6: Search by expected graduation date (after)
    it "returns students graduating after the given date" do
      get students_path, params: { search: { expected_graduation_date: "2026-01-01", date_type: "after" } }
      expect(response.body).to include("Jackie")
      expect(response.body).to_not include("Aaron")
    end
  end

  # POST /students (create)
  describe "POST /students" do
    context "with valid parameters" do
      # Test 4: Create a new student and ensure it redirects
      it "creates a new student and redirects" do
        expect {
          post students_path, params: { student: { first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15" } }
        }.to change(Student, :count).by(1)

        expect(response).to have_http_status(:found)  # Expect redirect after creation
        follow_redirect!
        expect(response.body).to include("Aaron", "Aaron")  # Student's details in the response
      end

      # Test 5 (Student will complete this part)
      # Ensure that it returns a 201 status or check for creation success
    end

    context "with invalid parameters" do
      # Test 6 (Student will complete this part)
      # Ensure it does not create a student and returns a 422 status
    end
  end

  # GET /students/:id (show)
  describe "GET /students/:id" do
    context "when the student exists" do
      let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }

      # Test 7 (Student will complete this part)
      # Ensure it returns a successful response (200 OK)

      # Test 8 (Student will complete this part)
      # Ensure it includes the student's details in the response body
    end

    # Test 9: Handle missing records
    context "when the student does not exist" do
      it "returns a 404 status" do
        get "/students/9999"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # DELETE /students/:id (destroy)
  describe "DELETE /students/:id" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }

    # Test 10: Deletes the student and redirects
    it "deletes the student and redirects" do
      expect {
        delete "/students/#{student.id}"
      }.to change(Student, :count).by(-1)

      expect(response).to have_http_status(:found)  # Expect 302 redirect after deletion
      follow_redirect!  # Follow the redirect after deletion
      expect(response.body).to include("Student was successfully destroyed.")
    end

    # Test 11: Returns a 404 when trying to delete a non-existent student
    it "returns a 404 status when trying to delete a non-existent student" do
      delete "/students/9999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
