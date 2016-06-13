class CommandsList
  def initialize
    @list = []
  end

  def add_command(command)
    @list << command
  end

  def get_iterator
    CommandsListIterator.new(@list)
  end

  def size
    @list.size
  end
end

class CommandsListIterator
  def initialize(list)
    @index = 0
    @list = list
  end

  def next
    object = @list[@index]
    @index += 1

    object
  end

  def has_next?
    @index < @list.size
  end
end
