# Define a administrative user model for the system
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, password_length: 8..12

  validate :password_complexity
  validate :name_without_numbers
  validates :name, length: { maximum: 20 }, presence: true

  def name_without_numbers
    errors.add :name, 'must not include numbers' if name && !name.match(/[0-9]/).nil?
  end

  def password_complexity
    if password.present? && !password.match(/^(?=.*[0-9]{2})(?=.*[a-zA-Z])([a-zA-Z0-9]+)$/)
      errors.add :password, 'must include at least one letter and two digits'
    end
  end
end
