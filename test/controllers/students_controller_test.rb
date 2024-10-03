require "test_helper"

RSpec.describe StudentsController, type: :controller do
  describe "GET #index" do
    it "assigns @students and renders the index template" do
      student = Student.create!(first_name: "John", last_name: "Doe", school_email: "john@university.edu", major: "CS")
      get :index
      expect(assigns(:students)).to eq([student])
      expect(response).to render_template(:index)
    end
  end
end

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:one)
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count") do
      post students_url, params: { student: { expected_graduation_date: @student.expected_graduation_date, first_name: @student.first_name, last_name: @student.last_name, major: @student.major, school_email: @student.school_email } }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: { expected_graduation_date: @student.expected_graduation_date, first_name: @student.first_name, last_name: @student.last_name, major: @student.major, school_email: @student.school_email } }
    assert_redirected_to student_url(@student)
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end
end
