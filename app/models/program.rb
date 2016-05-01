class Program < ActiveRecord::Base
  validates :name, presence: true

  has_many :students, dependent: :destroy
end
