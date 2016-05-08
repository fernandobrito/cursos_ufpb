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

    program = Program.find_or_create_by!(name: program_name)
    program.students.find_or_create_by!(code: parsed_student.id,
                                        average_grade: average_grade)

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
end
