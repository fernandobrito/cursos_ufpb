require 'securerandom'

class Command
  attr_accessor :created_at, :id

  def initialize
    @id = SecureRandom.hex
    @created_at = Time.now
  end

  def do ; end
  def undo ; end
  def description ; end
end
