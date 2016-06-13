class DeleteAllProgramsCommand < CompoundCommand
  def initialize
    super()
  end

  def description
    "Delete #{@commands.size} programs"
  end
end
