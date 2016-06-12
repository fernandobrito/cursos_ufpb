class UpdateProgramCommand < Command

  def initialize(program)
    super()

    @program = program
    @memento = nil
  end

  def description
    "Updated program #{@program.name}"
  end

  def do(*params)
    @memento = @program.create_memento
    @program.update(eval(params.join))
  end

  def undo
    @program.set_memento(@memento)
    @program.save
  end
end
