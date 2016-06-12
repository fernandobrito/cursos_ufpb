class CommandHistoryManager
  LIST_SIZE = 25

  @@instance = nil

  attr_accessor :count
  attr_reader :history

  def initialize
    @count = 0
    @history = []

    raise "Operation not supported. Use #{self.class}.get_instance" if @@instance
  end

  def register_command(command)
    # Add to the beginning of the array
    @history.unshift(command)

    # Use only the first N elements
    @history = @history[0..LIST_SIZE]
  end

  def register_and_execute_command(command, *params)
    # Execute command
    CommandRunner.execute(command, params)

    # Register command
    register_command(command)
  end

  def undo_command_by_id(id)
    # Find command
    command = @history.find { |c| c.id == id }

    # Undo
    CommandRunner.unexecute(command)

    # Delete from stack
    @history.delete(command)
  end

  # Singleton static method
  def self.get_instance
    @@instance ||= self.initialize_instance

    return @@instance
  end

  def increase_counter
    @count += 1
  end

  private
  def self.initialize_instance
    @@instance = CommandHistoryManager.new
  end
end
