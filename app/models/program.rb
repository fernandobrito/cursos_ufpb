# Define a university program model
class Program < ActiveRecord::Base
  self.primary_key = :code

  validates :name, presence: true

  has_many :students, dependent: :destroy, foreign_key: :program_code
end
