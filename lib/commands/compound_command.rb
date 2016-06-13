class CompoundCommand < Command

  def initialize
    super()

    @commands_list = CommandsList.new
  end

  def description
    "Generic CompoundCommand"
  end

  def add_command(command)
    @commands_list.add_command(command)
  end

  def do
    iterator = @commands_list.get_iterator

    while(iterator.has_next?)
      command = iterator.next
      CommandRunner.execute(command)
    end
  end

  def undo
    iterator = @commands_list.get_iterator

    while(iterator.has_next?)
      command = iterator.next
      CommandRunner.unexecute(command)
    end
  end
end
