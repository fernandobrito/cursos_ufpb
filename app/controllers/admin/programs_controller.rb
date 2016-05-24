class Admin::ProgramsController < Admin::ApplicationController

  #
  # INDEX
  #
  def index
    query = 'SELECT *
             FROM programs
             ORDER BY name'

    @programs = ActiveRecord::Base.connection.execute(query)
  end

  #
  # SHOW
  #
  def show
    query = "SELECT *
             FROM programs
             WHERE (code = '#{params[:id]}')"

    @program = ActiveRecord::Base.connection.execute(query)[0]

    query = "SELECT s.code as student_code, p.name as program_name, *
             FROM students s
             INNER JOIN programs p
             ON s.program_code = p.code
             WHERE (p.code = '#{params[:id]}')
             ORDER BY s.code"

    @students = ActiveRecord::Base.connection.execute(query)
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_programs_path, alert: "Algo deu errado. #{e}"
  end

  #
  # CREATE
  #
  def create
    query = "INSERT INTO programs(code, name)
             VALUES (#{params[:code]}, '#{params[:name]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_programs_path, notice: 'Criado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_programs_path, alert: "Algo deu errado. #{e}"
  end

  #
  # EDIT
  #
  def edit
    query = "SELECT *
             FROM programs
             WHERE (code = '#{params[:id]}')"

    @program = ActiveRecord::Base.connection.execute(query)[0]
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_programs_path, alert: "Algo deu errado. #{e}"
  end

  #
  # UPDATE
  #
  def update
    query = "UPDATE programs
             SET code = '#{params[:code]}',
                 name = '#{params[:name]}'
             WHERE (code = '#{params[:id]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_programs_path, notice: 'Editado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_programs_path, alert: "Algo deu errado. #{e}"
  end

  #
  # DESTROY
  #
  def destroy
    query = "DELETE FROM programs WHERE (code = '#{params[:id]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_programs_path, notice: "Excluído com sucesso."
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_programs_path, alert: "Algo deu errado. #{e}"
  end

  #
  # DESTROY_ALL
  #
  def destroy_all
    query = "DELETE FROM programs"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_programs_path, notice: "Todos os registros excluídos com sucesso."
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_programs_path, alert: "Algo deu errado. #{e}"
  end
end
