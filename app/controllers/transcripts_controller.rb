require 'dropbox_sdk'

class TranscriptsController < ApplicationController
  def create
    # Process data
    begin
      parser = SigaaParser::TranscriptParser.new(params[:file].tempfile)
    rescue SigaaParser::TranscriptParser::InvalidFileFormat, SigaaParser::TranscriptParser::InvalidFileExtension
      redirect_to root_path, alert: 'O arquivo que você enviou não se parece com um histórico escolar emitido pelo SIGAA UFPB.'
      return
    end

    # Process data for line graph
    @results = parser.course_results

    @semester_average = []

    @results.semesters[0..-2].each_with_index do |semester, index|
      @semester_average << [ {v: index, f: semester },
                             @results.average_up_to(semester),
                             @results.average_up_to(semester, approved_only: true)]
    end

    gon.semesters_average = @semester_average

    # Process data for pie graph
    @courses_groupped_by_situation = @results.results.group_by(&:situation)

    @courses_groupped_by_situation.map { |situation, courses| @courses_groupped_by_situation[situation] = courses.count }
    @courses_groupped_by_situation = @courses_groupped_by_situation.sort_by { |_, count| count }.reverse

    @total_courses = @results.results.size

    gon.courses_groupped_by_situation = @courses_groupped_by_situation.to_a

    # Process data for bubble graph
    semesters_map = {}
    @results.results.select { |r| r.grade.to_f != 0 && r.grade != '--' }.map(&:semester).uniq.sort.each_with_index do |semester, index|
      semesters_map[semester] = index;
    end

    @bubble = [['ID', 'Semestre', 'Nota', 'Nota', 'Créditos']]
    @results.results.select { |r| r.grade.to_f != 0 && r.grade != '--' }.each_with_index do |result, index|
      @bubble << [ result.name,
                   { v: semesters_map[result.semester], f: result.semester },
                   result.grade.to_f,
                   result.grade.to_f,
                   result.credits.to_i ]
    end

    gon.bubble = @bubble
    gon.bubble_max_grade = @bubble[1..-1].map { |el| el[2] }.max
    gon.bubble_min_grade = @bubble[1..-1].map { |el| el[2] }.min
    gon.bubble_semesters_max = semesters_map.map { |k, v| v }.max

    # Save file on Dropbox
    if ENV['RAILS_ENV'] == 'production'
      client = DropboxClient.new(ENV['DROPBOX_ACCESS_TOKEN'])
      filename = "#{@results.student.id}_#{@results.semesters.last.sub('.','_')}.pdf"
      client.put_file(filename, params[:file].tempfile)
    end

    render :show
  end
end
