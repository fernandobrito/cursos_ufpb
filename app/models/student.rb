class Student < ActiveRecord::Base
  self.primary_key = :code

  belongs_to :program

  validates :code, presence: true, uniqueness: true
  validates :program, presence: true
end
