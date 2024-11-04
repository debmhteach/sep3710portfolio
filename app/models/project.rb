class Project < ApplicationRecord
  belongs_to :student
  validates :title, :description, presence: true
end
