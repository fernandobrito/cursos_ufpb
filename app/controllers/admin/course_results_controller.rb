class Admin::CourseResultsController < Admin::ApplicationController
  before_action :find_associations, only: [:index, :edit]

  #
  # INDEX
  #
  def index
    query = 'SELECT c.name as course_name, *
             FROM course_results cr
             INNER JOIN courses c
             ON cr.course_code = c.code
             ORDER BY year, semester'

    @results = ActiveRecord::Base.connection.execute(query)
  end

  #
  # CREATE
  #
  def create
    query = "INSERT INTO course_results
             (student_code, course_code, year, semester, grade, situation)
             VALUES (#{params[:student_code]}, '#{params[:course_code]}',
                     #{params[:year]}, #{params[:semester]}, #{params[:grade]}, '#{params[:situation]}')"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_course_results_path, notice: 'Criado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_course_results_path, alert: "Algo deu errado. #{e}"
  end

  #
  # EDIT
  #
  def edit
    query = "SELECT *
             FROM course_results
             WHERE (student_code = '#{params[:student_code]}' AND
                    course_code = '#{params[:course_code]}' AND
                    year = #{params[:year]} AND
                    semester = #{params[:semester]})"

    @result = ActiveRecord::Base.connection.execute(query)[0]
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_course_results_path, alert: "Algo deu errado. #{e}"
  end

  #
  # UPDATE
  #
  def update
    query = "UPDATE course_results
             SET student_code = '#{params[:student_code]}',
                 course_code = '#{params[:course_code]}',
                 year = #{params[:year]},
                 semester = #{params[:semester]},
                 grade = #{params[:grade]},
                 situation = '#{params[:situation]}'
             WHERE (student_code = '#{params[:old_student_code]}' AND
                    course_code = '#{params[:old_course_code]}' AND
                    year = #{params[:old_year]} AND
                    semester = #{params[:old_semester]})"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_course_results_path, notice: 'Editado com sucesso.'
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_course_results_path, alert: "Algo deu errado. #{e}"
  end

  #
  # DESTROY
  #
  def destroy
    query = "DELETE FROM course_results
             WHERE (student_code = '#{params[:student_code]}' AND
                    course_code = '#{params[:course_code]}' AND
                    year = #{params[:year]} AND
                    semester = #{params[:semester]})"

    ActiveRecord::Base.connection.execute(query)

    redirect_to admin_course_results_path, notice: "Excluído com sucesso."
  rescue ActiveRecord::StatementInvalid => e
    redirect_to admin_course_results_path, alert: "Algo deu errado. #{e}"
  end

  private
  def find_associations
    @students = ActiveRecord::Base.connection.execute('SELECT code FROM students')
    @courses = ActiveRecord::Base.connection.execute('SELECT code, name FROM courses')
  end
end
