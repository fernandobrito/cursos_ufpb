# Define a university program model
class Program < ActiveRecord::Base
  validates :name, presence: true

  has_many :students, dependent: :destroy

  def create_memento
    ProgramMemento.new(name)
  end

  def set_memento(memento)
    self.name = memento.name
  end
end
