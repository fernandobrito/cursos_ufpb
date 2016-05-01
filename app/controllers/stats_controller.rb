class StatsController < ApplicationController
  def students
    @programs_count = Student.group(:program).order('count_all desc').limit(10).count
    @programs_average = Student.group(:program).average(:average_grade).to_hash

    @total_students = Student.count
    @total_programs = Program.count
  end
end