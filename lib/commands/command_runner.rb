module CommandRunner
  def self.execute(command)
    puts "[CommandRunner] Executing command of type #{command.class}"
    command.do()
  end

  def self.unexecute(command)
    puts "[CommandRunner] Unexecuting command of type #{command.class}"
    command.undo()
  end
end
