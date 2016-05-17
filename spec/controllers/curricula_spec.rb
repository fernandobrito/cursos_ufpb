describe Api::CurriculaController do
  context 'when accessing valid data' do
    it 'return curricula array' do
      get :index
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['curricula']).to include(
        'id' => '0282007',
        'name' => 'MEDICINA - João Pessoa - Presencial - MT - OUTRO TIPO DE GRAU ACADÊMICO',
        'faculty' => 'CENTRO DE CIÊNCIAS MÉDICAS (CCM) (11.00.60)',
        'semesters' => 12
      )
    end

    it 'with curriculum id, return courses array' do
      get :show, id: 162_006
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['curriculum']['name']).to include(
        'CIÊNCIAS DA COMPUTAÇÃO - João Pessoa - Presencial - MT - BACHARELADO')
      expect(parsed_body['curriculum']['courses']).to include(
        'id' => '1101168',
        'name' => 'FISICA APLICADA A COMPUTACAO II',
        'category' => 'Complementar Optativa',
        'semester' => 0,
        'workload' => '90h(6cr) aula 0h(0cr) lab.',
        'type' => 'DISCIPLINA',
        'prerequisites' => %w(1101167 1101118)
      )
    end
  end

  context 'when accessing invalid data' do
    it 'return error message with wrong id' do
      get :show, id: 1_111_001
      parsed_body = JSON.parse(response.body)

      expect(parsed_body['error']).to match('with code 1111001')
    end

    it 'return a 404 HTTP status' do
      get :show, id: 1_111_001
      expect(response).to have_http_status(404)
    end
  end
end
