class CreateProgramCommand < Command

  def initialize(program)
    super()

    @program = program
  end

  def description
    "Create program #{@program.name}"
  end

  def do
    @program.save
  end

  def undo
    @program.destroy
  end
end
