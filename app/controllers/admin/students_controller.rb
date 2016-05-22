class Admin::StudentsController < Admin::ApplicationController
  before_action :find_associations, only: [:index, :edit]

  #
  # INDEX
  #
  def index
    query = 'SELECT s.code as student_code, p.name as program_name, *
             FROM students s
             INNER JOIN programs p
             ON s.program_code = p.code
             ORDER BY s.code'

    @students = ActiveRecord::Base.connection.execute(query)
  end

  #
  # SHOW
  #
  def show
    query = "SELECT *
             FROM students
             WHERE (code = '#{params[:id]}')"

    @student = ActiveRecord::Base.connection.execute(query)[0]

    query = "SELECT c.name as course_name, *
             FROM course_results cr
             INNER JOIN courses c
             ON cr.course_code = c.code
             WHERE (student_code = '#{params[:id]}')
             ORDER BY year, semester"

    @results = ActiveRecord::Base.connection.execute(query)
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_students_path, alert: "Algo deu errado. #{e}"
  end

  #
  # CREATE
  #
  def create
    query = "INSERT INTO students(code, program_code, average_grade)
             VALUES (#{params[:code]}, #{params[:program_code]}, #{params[:average_grade]})"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_students_path, notice: 'Criado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_students_path, alert: "Algo deu errado. #{e}"
  end

  #
  # EDIT
  #
  def edit
    query = "SELECT *
             FROM students
             WHERE (code = '#{params[:id]}')"

    @student = ActiveRecord::Base.connection.execute(query)[0]
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_students_path, alert: "Algo deu errado. #{e}"
  end

  #
  # UPDATE
  #
  def update
    query = "UPDATE students
             SET code = '#{params[:code]}',
                 program_code = '#{params[:program_code]}',
                 average_grade = #{params[:average_grade]}
             WHERE (code = '#{params[:id]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_students_path, notice: 'Editado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_students_path, alert: "Algo deu errado. #{e}"
  end

  #
  # DESTROY
  #
  def destroy
    query = "DELETE FROM students WHERE (code = '#{params[:id]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_students_path, notice: "Excluído com sucesso."
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_students_path, alert: "Algo deu errado. #{e}"
  end

  private
  def find_associations
    @programs = ActiveRecord::Base.connection.execute('SELECT * FROM programs')
  end
end
