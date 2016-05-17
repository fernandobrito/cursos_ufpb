# Define a student model
class Student < ActiveRecord::Base
  self.primary_key = :code

  belongs_to :program

  validates :code, presence: true, uniqueness: true, numericality: { only_integer: true }
  validates :program, presence: true
  validates :average_grade,
            allow_nil: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }

  validates_length_of :code, is: 8
end
