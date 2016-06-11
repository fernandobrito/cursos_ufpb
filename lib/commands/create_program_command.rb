class CreateProgramCommand < Command

  def initialize(program)
    super()

    @program = program
  end

  def description
    "Created program #{@program.name}"
  end

  def do
    @program.save
  end

  def undo
    @program.destroy
  end
end
