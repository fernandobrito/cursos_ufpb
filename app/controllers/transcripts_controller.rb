# Controller for handle submitted student transcripts
class TranscriptsController < ApplicationController
  def sample
    file = File.open(Rails.root.join('db/data/sample-transcript.pdf'))
    parser = SigaaParser::TranscriptParser.new(file)

    create(parser, true)
  end

  def create(parser = nil, is_sample_file = false)
    # Process data
    begin
      parser ||= SigaaParser::TranscriptParser.new(params[:file].tempfile)
    rescue SigaaParser::TranscriptParser::InvalidFileFormat,
           SigaaParser::TranscriptParser::InvalidFileExtension
      redirect_to root_path,
                  alert: 'O arquivo que você enviou não se parece com
                          um histórico escolar emitido pelo SIGAA UFPB.'
      return
    end

    # Get data from parser
    course_results = parser.course_results

    # Process data for 'charts/line_average' and for 'data/average_grades'
    # Need to populate gon.smesters_average and @semesters_average
    @semesters_average = TranscriptDataProcessor.semesters_average(course_results)
    gon.semesters_average = @semesters_average

    # Process data for 'charts/donut_situation' and for 'data/situation_groups'
    # Need to populate gon.courses_by_situation and @courses_by_situation
    @courses_by_situation = TranscriptDataProcessor.courses_grouped_by_situation(course_results)
    gon.courses_by_situation = @courses_by_situation.to_a

    # Process data for 'charts/bubble_courses'
    # Need to populate gon.courses_for_bubble and gon.bubble_stats
    gon.bubble, gon.bubble_stats = TranscriptDataProcessor.courses_for_bubble(course_results).to_a

    # Process data for 'charts/column_semesters'
    # Need to populate gon.semesters_workload
    gon.semesters_workload = TranscriptDataProcessor.semesters_workload(course_results)

    # Process data for 'data/courses_list'
    # Need to populate @courses
    @courses = course_results.results

    # Process data for 'charts/_progress_bars'
    @progress = course_results.progress

    # Persist student data for statistics
    parsed_student = course_results.student
    program_name = parsed_student.program

    average_grade = parser.course_results.average_up_to(parser.course_results.semesters.last)

    #  Delete previous record
    delete_student(parsed_student.id)

    # Find course
    program_code = find_or_create_program(program_name)

    # Create student
    create_student(parsed_student.id, program_code, average_grade)

    # Create courses
    @courses.each do |course_result|
      create_course(course_result)
      create_course_result(parsed_student.id, course_result)
    end

    # Save file on Dropbox
    if ENV['RAILS_ENV'] == 'production' && !is_sample_file
      filename = "#{course_results.student.id}_#{course_results.semesters.last.sub('.', '_')}.pdf"
      FileStorage.store(filename, params[:file].tempfile)
    end

    flash[:warning] = "O seu curso '#{program_name}' ainda não possui dados
                      suficientes para calcular estatísticas como a comparação
                      do seu CRA com a dos alunos do seu curso.
                      Convide seus colegas para liberar este recurso!"
    render :show

    flash[:warning] = nil
  end

  protected
  def delete_student(code)
    query = "DELETE FROM students WHERE (code = '#{code}')"
    ActiveRecord::Base.connection.execute(query)
  end

  def find_or_create_program(program_name)
    # Try to find
    query = "SELECT *
             FROM programs
             WHERE (name = '#{program_name}')"

    results = ActiveRecord::Base.connection.execute(query)

    if results.ntuples > 0
      puts "Program found. #{results[0]['code']}"
      return results[0]['code']
    end

    # Could not find, create new
    query = "INSERT INTO programs(name)
             VALUES ('#{program_name}')"

    ActiveRecord::Base.connection.execute(query)

    # Find code
    query = "SELECT *
             FROM programs
             WHERE (name = '#{program_name}')"

    results = ActiveRecord::Base.connection.execute(query)

    return results[0]['code']
  end

  def create_course(course)
    # Try to find
    query = "SELECT *
             FROM courses
             WHERE (code = '#{course.code}')"

    results = ActiveRecord::Base.connection.execute(query)

    if results.ntuples > 0
      puts "Course found. #{results[0]['code']}"
      return results[0]['code']
    end

    # Could not find, create new
    query = "INSERT INTO courses(code, name, credits, workload)
             VALUES ('#{course.code}', '#{course.name}', #{course.credits}, #{course.workload})"

    ActiveRecord::Base.connection.execute(query)
  end

  def create_student(code, program_code, average_grade)
    query = "INSERT INTO students(code, program_code, average_grade)
             VALUES (#{code}, #{program_code}, #{average_grade})"

    ActiveRecord::Base.connection.execute(query)
  end

  def create_course_result(student_code, course)
    year = course.semester.split('.')[0]
    semester = course.semester.split('.')[1]

    grade = course.grade == '--' ? 'NULL' : course.grade

    query = "INSERT INTO course_results
             (student_code, course_code, year, semester, grade, situation)
             VALUES (#{student_code}, '#{course.code}',
                     #{year}, #{semester}, #{grade}, '#{course.situation}')"

    ActiveRecord::Base.connection.execute(query)
  end
end
