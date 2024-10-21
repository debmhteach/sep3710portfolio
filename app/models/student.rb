class Student < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable
    
    VALID_MAJORS = ["Computer Engineering BS", "Computer Information Systems BS", "Computer Science BS", "Cybersecurity Major", "Data Science and Machine Learning Major"]

    validates :major, inclusion: { in: VALID_MAJORS, message: "%{value} is not a valid major" }
    validates :first_name, :last_name, :major, presence: true
    has_one_attached :profile_picture, dependent: :purge_later 
    validate :acceptable_image
    validate :email_format


    #has one relationship and destroy portfolio if student deleted
    has_one :portfolio, dependent: :destroy
    after_create :create_portfolio
    #allow editing of portfolio information in form
    accepts_nested_attributes_for :portfolio

    private

    #create portfolio when student created
    def create_portfolio
        #link portfolio to id of student
        Portfolio.create!(student: self, active: false)
    end


    def email_format
        unless email =~ /\A[\w+\-.]+@msudenver\.edu\z/i
            errors.add(:email, "must be an @msudenver.edu email address")
        end
    end


    def acceptable_image
        return unless profile_picture.attached?

        unless profile_picture.blob.byte_size <= 1.megabyte
            errors.add(:profile_picture, "is too big")
        end

        acceptable_types = ["image/jpeg", "image/png"]
        unless acceptable_types.include?(profile_picture.content_type)
            errors.add(:profile_picture, "must be a JPEG or PNG")
        end

    end

end
