# Controller for serve curricula information
class Api::CurriculaController < ApplicationController
  DATA_PATH = File.join(Rails.root, 'db', 'json')

  def index
    render json: open_file('curricula.json')
  end

  def show
    render json: open_file("curricula/#{params[:id]}.json")
  rescue
    render json: { error: "Could not find any curriculum with code #{params[:id]}" }, status: 404
  end

  protected

  def open_file(path)
    File.read(File.join(DATA_PATH, path))
  end
end
