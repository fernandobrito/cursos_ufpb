class Admin::CommandsController < Admin::ApplicationController
  def index
    chm = CommandHistoryManager.get_instance()
    @commands = chm.history
  end

  def destroy
    chm = CommandHistoryManager.get_instance()
    chm.undo_command_by_id(params[:id])

    redirect_to admin_commands_path, notice: 'Command undo with success.'
  end
end
