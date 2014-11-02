# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :applications, dependent: :destroy
  has_many :passwords, through: :applications, dependent: :destroy

  after_create :generate_encrypting_key

  def encrypt(text)
    encryptor.encrypt_and_sign(text)
  end

  def decrypt(text)
    encryptor.decrypt_and_verify(text)
  end

  def generate_encrypting_key
    self.encrypting_key = Digest::SHA1.hexdigest(email)
    self.save
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(encrypting_key)
  end
end
