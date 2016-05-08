# Controller for users (admin) operations
class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: [:show, :destroy]
  before_action :authorize, only: [:show, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def destroy
    @user.destroy

    redirect_to admin_users_path
  end

  protected

  def find_resource
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path, alert: 'Usuário não encontrado.'
    return
  end

  def authorize
    redirect_to :back, alert: 'Access denied.' unless @user == current_user
  end
end
