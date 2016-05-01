module TranscriptDataProcessor
  # Return an array without headers
  # Semester formatted for chart, real average, only approved courses average
  # [ [ { v: 0, f: '2015.1' }, 6.7, 8.5 ], ...  ]
  def self.semesters_average(course_results)
    output = []

    # Do not iterate over last (current?) semester
    course_results.semesters[0..-2].each_with_index do |semester, index|
      output << [{v: index, f: semester },
                  course_results.average_up_to(semester),
                  course_results.average_up_to(semester, approved_only: true)]
    end

    output
  end

  # Return an hash { APROVADO: 20, REPROVADO: 30, ... }
  def self.courses_grouped_by_situation(course_results)
    # Group courses by situation
    output = course_results.results.group_by(&:situation)

    # Replace courses with count
    output.each do |situation, courses|
      output[situation] = courses.count
    end

    # Sort by count
    output.sort_by { |_, count| count }.reverse
  end

  # Return array with headers and
  #    { max_grade: <max_grade>, min_grade: <min_grade>, max_semester: <max_semester> }
  # Check: https://developers.google.com/chart/interactive/docs/gallery/bubblechart#data-format
  # [ ID, X, Y, Color, Size]
  # [ Course name, Semester formatted for chart, Grande, Grade, Credits ]
  def self.courses_for_bubble(course_results)
    # Filter courses (remove REP. FALTA and MATRICULADO)
    situations = ['APROVADO', 'REPROVADO', 'DISPENSADO']
    courses = course_results.results.select { |course| situations.include?(course.situation) }

    # Make semesters map for bubble chart
    # { 2015.1: 0, 2015.2: 1, 2016.1: 2, ...}
    semesters_map = {}

    courses.map(&:semester).uniq.sort.each_with_index do |semester, index|
      semesters_map[semester] = index;
    end

    # Header
    output = []

    courses.each_with_index do |result, index|
      output << [ result.name,
                   { v: semesters_map[result.semester], f: result.semester },
                   result.grade.to_f,
                   result.grade.to_f,
                   result.credits.to_i ]
    end

    # Calculate statistics
    stats = {}
    stats[:max_grade] = output.map { |row| row[2] }.max
    stats[:min_grade] = output.map { |row| row[2] }.min
    stats[:max_semester] = semesters_map.values.max

    # Add header to beginning of array
    output.unshift(['ID', 'Semestre', 'Nota', 'Nota', 'Créditos'])

    return output, stats
  end
end