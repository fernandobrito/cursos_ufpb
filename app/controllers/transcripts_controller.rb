class TranscriptsController < ApplicationController
  def create
    # Process data
    begin
      parser = SigaaParser::TranscriptParser.new(params[:file].tempfile)
    rescue SigaaParser::TranscriptParser::InvalidFileFormat, SigaaParser::TranscriptParser::InvalidFileExtension
      redirect_to root_path, alert: 'O arquivo que você enviou não se parece com um histórico escolar emitido pelo SIGAA UFPB.'
      return
    end

    results = parser.course_results

    semester_average = []

    results.semesters.each_with_index do |semester, index|
      semester_average << [ {v: index, f: semester },
                             results.average_up_to(semester),
                             results.average_up_to(semester, approved_only: true)]
    end

    gon.semesters_average = semester_average

    # Save file
    path = File.join(Rails.root, 'uploads', "#{results.student.id}_#{results.semesters.last.sub('.','_')}.pdf")
    File.open(path, 'wb') { |f| f.write(params[:file].read) }

    render :show
  end
end
