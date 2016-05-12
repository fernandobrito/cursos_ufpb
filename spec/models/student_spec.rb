describe Student do
  context 'when has invalid attributes' do
    it 'is invalid without code' do
      student = FactoryGirl.build(:student, code: '')
      student.valid?
      expect(student.errors[:code]).to include("can't be blank")
    end

    it 'is invalid without program'

    it 'is invalid with negative average' do
      student = FactoryGirl.build(:student, average_grade: -2.0)
      student.valid?
      expect(student.errors[:average_grade].join(' ')).to match('greater than or equal to 0')
    end

    it 'is invalid with average greater than 10' do
      student = FactoryGirl.build(:student, average_grade: 11.1)
      student.valid?
      expect(student.errors[:average_grade].join(' ')).to match('less than or equal to 10')
    end
  end

  it 'has a valid factory' do
    student = FactoryGirl.build(:student)
    student.valid?
    expect(student.errors.messages).to be_empty
  end
end
