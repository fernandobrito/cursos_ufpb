describe StatsController do
  context 'When has valid data' do
    before do
      @program_cc = FactoryGirl.create(
        :program, name: 'CIÊNCIAS DA COMPUTAÇÃO (BACHARELADO) - CI/João Pessoa')
      5.times do
        FactoryGirl.create(:student, :code_sequence, program: @program_cc, average_grade: 7.34)
      end
      @program_ec = FactoryGirl.create(
        :program, name: 'ENGENHARIA DE COMPUTAÇÃO (BACHARELADO) - CI/João Pessoa')
      3.times do
        FactoryGirl.create(:student, :code_sequence, program: @program_ec, average_grade: 5.5)
      end
    end

    it 'programs count is equals to 5 and 3' do
      get :students
      expect(assigns(:programs_count)).to include(@program_cc => 5)
      expect(assigns(:programs_count)).to include(@program_ec => 3)
    end

    it 'programs average is equals to 5 and 3' do
      get :students
      expect(assigns(:programs_average)).to include(@program_cc => 7.34)
      expect(assigns(:programs_average)).to include(@program_ec => 5.5)
    end

    it 'total students is equals 8' do
      get :students
      expect(assigns(:total_students)).to be(8)
    end

    it 'total programs is equals 2' do
      get :students
      expect(assigns(:total_programs)).to be(2)
    end
  end

  context 'when has not valid data' do
    before { get :students }

    it 'programs count is zero' do
      expect(assigns(:programs_count)).to be_empty
    end

    it 'programs average is zero' do
      expect(assigns(:programs_average)).to be_empty
    end

    it 'total students is zero' do
      expect(assigns(:total_students)).to be(0)
    end

    it 'total programs is zero' do
      expect(assigns(:total_programs)).to be(0)
    end
  end
end
