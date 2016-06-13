class DeleteProgramCommand < Command
  def initialize(program)
    super()

    @program = program
    @memento = nil
  end

  def description
    "Delete program #{@memento.name}"
  end

  def do
    @memento = @program.create_memento
    @memento.id = @program.id

    @program.destroy!
  end

  def undo
    Program.create(id: @memento.id, name: @memento.name)
  end
end
