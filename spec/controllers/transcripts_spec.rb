describe TranscriptsController do
  context 'When submit valid transcript' do
    it 'parse the data correctly' do
      post :create, file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/valid-transcript.pdf", 'application/pdf')
      expect(assigns(:courses)[0].grade).to eq('8.0')
    end
  end

  context 'When submit invalid transcript' do
    it 'redirects to root path' do
      post :create, file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/valid-image.jpg", 'image/jpeg')
      expect(response).to redirect_to root_path
    end
  end
end
