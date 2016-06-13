class UpdateProgramCommand < Command
  def initialize(program, new_attributes)
    super()

    @program = program
    @new_attributes = new_attributes
    @memento = nil
  end

  def description
    "Update program #{@program.name}"
  end

  def do
    @memento = @program.create_memento
    @program.update(@new_attributes)
  end

  def undo
    @program.set_memento(@memento)
    @program.save
  end
end
