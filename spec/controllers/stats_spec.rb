describe StatsController do
  context 'When has valid data' do

    before {
      FactoryGirl.reload
      @program_cc = FactoryGirl.create(:program, name: 'CIÊNCIAS DA COMPUTAÇÃO (BACHARELADO) - CI/João Pessoa')
      5.times { FactoryGirl.create(:student, :code_sequence, program: @program_cc) }
      @program_ec = FactoryGirl.create(:program, name: 'ENGENHARIA DE COMPUTAÇÃO (BACHARELADO) - CI/João Pessoa')
      3.times { FactoryGirl.create(:student, :code_sequence, program: @program_ec, average_grade: 5.5) }
    }

    it 'is programs count equals to 5 and 3' do
      get :students
      expect(assigns(:programs_count)).to include(@program_cc => 5)
      expect(assigns(:programs_count)).to include(@program_ec => 3)
    end

    it 'is programs average equals to 5 and 3' do
      get :students
      expect(assigns(:programs_average)).to include(@program_cc => 7.34)
      expect(assigns(:programs_average)).to include(@program_ec => 5.5)
    end

    it 'is total students equals 8' do
      get :students
      expect(assigns(:total_students)).to be(8)
    end

    it 'is total programs equals 2' do
      get :students
      expect(assigns(:total_programs)).to be(2)
    end
  end

  context 'when has not valid data' do

    before { get :students }

    it 'is programs count zero' do
      expect(assigns(:programs_count)).to be_empty
    end

    it 'is programs average zero' do
      expect(assigns(:programs_average)).to be_empty
    end

    it 'is total students zero' do
      expect(assigns(:total_students)).to be(0)
    end

    it 'is total programs zero' do
      expect(assigns(:total_programs)).to be(0)
    end
  end
end
