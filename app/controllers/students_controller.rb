class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json

  def index
    Rails.logger.info "Params: #{params.inspect}"
    
    @search_params = params[:search] || {}
    # If there are search parameters, filter the students
    if @search_params.present?
      @students = Student.all

      # Filter by graduation date if present
      # Date search logic
      if @search_params[:expected_graduation_date].present? && @search_params[:date_type].present?
        if @search_params[:date_type] == "before"
          @students = @students.where("expected_graduation_date < ?", @search_params[:expected_graduation_date])
        elsif @search_params[:date_type] == "after"
          @students = @students.where("expected_graduation_date > ?", @search_params[:expected_graduation_date])
        end
      end

      # Filter by major if present
      if @search_params[:major].present?
        @students = @students.where(major: @search_params[:major])
      end

      
    else
      # If no search parameters are present, return an empty collection
      @students = Student.none
    end

    # Log for debugging
    Rails.logger.info "Search Params: #{@search_params.inspect}"
    Rails.logger.info "Filtered Students: #{@students.inspect}"

  end


  # GET /students/1 or /students/1.json
  def show
    @student = Student.find(params[:id])
  end


  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :school_email, :major, :expected_graduation_date, :profile_picture)
    end
end
