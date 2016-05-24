class Admin::CoursesController < Admin::ApplicationController
  #
  # INDEX
  #
  def index
    query = 'SELECT *
             FROM courses
             ORDER BY name'

    @courses = ActiveRecord::Base.connection.execute(query)
  end

  #
  # CREATE
  #
  def create
    query = "INSERT INTO courses(code, name, credits, workload)
             VALUES (#{params[:code]}, '#{params[:name]}', #{params[:credits]}, #{params[:workload]})"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_courses_path, notice: 'Criado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_courses_path, alert: "Algo deu errado. #{e}"
  end

  #
  # EDIT
  #
  def edit
    query = "SELECT *
             FROM courses
             WHERE (code = '#{params[:id]}')"

    @course = ActiveRecord::Base.connection.execute(query)[0]
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_courses_path, alert: "Algo deu errado. #{e}"
  end

  #
  # UPDATE
  #
  def update
    query = "UPDATE courses
             SET code = '#{params[:code]}',
                 name = '#{params[:name]}',
                 credits = '#{params[:credits]}',
                 workload = '#{params[:workload]}'
             WHERE (code = '#{params[:id]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_courses_path, notice: 'Editado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_courses_path, alert: "Algo deu errado. #{e}"
  end

  #
  # DESTROY
  #
  def destroy
    query = "DELETE FROM courses WHERE (code = '#{params[:id]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_courses_path, notice: "Excluído com sucesso."
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_courses_path, alert: "Algo deu errado. #{e}"
  end

  #
  # DESTROY_ALL
  #
  def destroy_all
    query = "DELETE FROM courses"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_courses_path, notice: "Todos os registros excluídos com sucesso."
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_courses_path, alert: "Algo deu errado. #{e}"
  end
end
