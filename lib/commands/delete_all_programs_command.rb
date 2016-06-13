class DeleteAllProgramsCommand < CompoundCommand
  def initialize
    super()
  end

  def description
    "Delete #{@commands_list.size} programs"
  end
end
