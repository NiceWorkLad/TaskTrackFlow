class User < ApplicationRecord
  attr_accessor :pin_0, :pin_1, :pin_2, :pin_3

  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
       :omniauthable, omniauth_providers: [ :google_oauth2 ]

  after_create :send_welcome_email!

  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email)

    if user
      user.update(
        provider: auth.provider,
        uid: auth.uid,
        username: user.username.presence || username_from_omniauth(auth)
      )
    else
      user = create(
        email: auth.info.email,
        username: username_from_omniauth(auth),
        provider: auth.provider,
        uid: auth.uid,
        password: Devise.friendly_token[0, 20],
        email_verified: true
      )
    end

    user
  end

  def self.username_from_omniauth(auth)
    # info.name falls back to the email in OmniAuth, so read the raw key
    auth.info["name"].presence || auth.info.email.to_s.split("@").first
  end

  private

  def send_welcome_email!
    UserMailer.with(user: self).welcome_email.deliver_later
  end

  def send_pin!
    SendPinJob.perform_later(id)
  end

  public

  def deliver_pin!
    send_pin!
  end
end
