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

    # Save file on Dropbox
    if ENV['RAILS_ENV'] == 'production'
      client = DropboxClient.new(ENV['DROPBOX_ACCESS_TOKEN'])
      filename = "#{@results.student.id}_#{@results.semesters.last.sub('.','_')}.pdf"
      client.put_file(filename, params[:file].read)
    end

    render :show
  end
end
