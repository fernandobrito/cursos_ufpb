namespace :data do
  desc 'Read PDF files and store data on Student and Program tables'
  task import_from_pdf: :environment do
    Dir.glob('/tmp/transcripts/*.pdf') do |file|
      parser = SigaaParser::TranscriptParser.new(File.open(file))

      parsed_student = parser.course_results.student
      program_name = parsed_student.program

      average_grade = parser.course_results.average_up_to(parser.course_results.semesters.last)

      program = Program.find_or_create_by!(name: program_name)
      student = program.students.find_or_create_by!(code: parsed_student.id, average_grade: average_grade)

      puts "#{student.code} - #{program.name}"
    end
  end

end
