class CommandRunner
  def self.execute(command, *params)
    puts "[CommandRunner] Executing command of type #{command.class}"
    command.do(params)
  end

  def self.unexecute(command)
    puts "[CommandRunner] Unexecuting command of type #{command.class}"
    command.undo()
  end
end
