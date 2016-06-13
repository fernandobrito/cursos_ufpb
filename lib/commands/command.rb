class Command
  attr_accessor :created_at, :id

  def initialize
    @id = Time.now.to_i.to_s
    @created_at = Time.now
  end

  def do(*params) ; end
  def undo ; end
  def description ; end
end
