class CompoundCommand < Command

  def initialize
    super()

    @commands = []
  end

  def description
    "Generic CompoundCommand"
  end

  def add_command(command)
    @commands << command
  end

  def do
    @commands.each do |command|
      CommandRunner.execute(command)
    end
  end

  def undo
    @commands.each do |command|
      CommandRunner.unexecute(command)
    end
  end
end
