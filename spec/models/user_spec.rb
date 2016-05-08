describe User do
  context 'when has invalid attributes' do
    it 'should not accept without name' do
      user = FactoryGirl.build(:user_name_blank)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'should not accept numbers in name' do
      user = FactoryGirl.build(:user_name_with_numbers)
      user.valid?
      expect(user.errors[:name]).to include('must not include numbers')
    end

    it 'should not accept password without at least 2 numbers' do
      user = FactoryGirl.build(:user_passwd_without_numbers)
      user.valid?
      expect(user.errors[:password].join(' ')).to match('letter and two digits')
    end

    it 'should not accept password without at least 1 letter' do
      user = FactoryGirl.build(:user_passwd_without_letters)
      user.valid?
      expect(user.errors[:password].join(' ')).to match('letter and two digits')
    end

    it 'should not accept password shorter than 8 chars' do
      user = FactoryGirl.build(:user_passwd_short)
      user.valid?
      expect(user.errors[:password].join(' ')).to match('too short')
    end

    it 'should not accept password longer than 12 chars' do
      user = FactoryGirl.build(:user_passwd_long)
      user.valid?
      expect(user.errors[:password].join(' ')).to match('too long')
    end
  end

  it 'should be saved' do
    User.create(name: 'Nome',
                email: 'email@example.com',
                password: 'password1234')
    expect(User.count).to be(1)
  end

  it 'should be deleted' do
    user = FactoryGirl.create(:user)
    user.destroy
    expect(User.count).to be(0)
  end

  it 'should be editable' do
    user = FactoryGirl.create(:user)
    user.name = 'New name'
    user.save
    expect(User.last.name).to eq('New name')
  end

  it 'should list all users' do
    5.times { FactoryGirl.create(:user) }
    expect(User.all.length).to be(5)
  end
end
