describe TranscriptsController do
  context 'When submit valid transcript' do
    it 'parse the data correctly' do
      file = "#{Rails.root}/spec/fixtures/valid-transcript.pdf"
      post :create, file: Rack::Test::UploadedFile.new(file, 'application/pdf')
      expect(assigns(:courses)[0].grade).to eq('8.0')
    end
  end

  context 'When submit invalid transcript' do
    it 'redirects to root path' do
      file = "#{Rails.root}/spec/fixtures/valid-image.jpg"
      post :create, file: Rack::Test::UploadedFile.new(file, 'image/jpeg')
      expect(response).to redirect_to root_path
    end
  end
end
