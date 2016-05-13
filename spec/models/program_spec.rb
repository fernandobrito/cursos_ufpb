describe Program do
  context 'when has invalid attributes' do
    it 'is invalid without name' do
      program = FactoryGirl.build(:program, name: nil)
      program.valid?
      expect(program.errors[:name]).to include("can't be blank")
    end
  end

  it 'has a valid factory' do
    program = FactoryGirl.build(:program)
    program.valid?
    expect(program.errors.messages).to be_empty
  end

  it 'must destroy dependent students when destroyed' do
    program = FactoryGirl.create(:program)
    5.times { FactoryGirl.create(:student, :code_sequence, program: program) }
    expect(Student.all.length).to be(5)
    program.destroy
    expect(Student.all.length).to be(0)
  end
end
