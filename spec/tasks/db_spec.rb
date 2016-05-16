require 'rake'

describe 'db:seeds' do
  before { UfpbSigaaApi::Application.load_tasks }

  context 'When invoke task' do
    before { Rake::Task['db:seed'].invoke }

    it 'create a User' do
      expect(User.first.name).to eq('First User')
    end
  end
end
