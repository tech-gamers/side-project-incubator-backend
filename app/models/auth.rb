# == Schema Information
#
# Table name: auths
#
#  id                 :bigint           not null, primary key
#  avatar_url         :string
#  current_sign_in_at :datetime
#  current_sign_in_ip :inet
#  email              :string           default(""), not null
#  failed_attempts    :integer          default(0), not null
#  last_sign_in_at    :datetime
#  last_sign_in_ip    :inet
#  name               :string
#  provider           :string
#  sign_in_count      :integer          default(0), not null
#  uid                :string
#  username           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint
#
# Indexes
#
#  index_auths_on_email    (email)
#  index_auths_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Auth < ApplicationRecord
  class << self
    def from_github(data, user: nil)
      where(provider: data.provider, uid: data.uid).first_or_create! do |auth|
        auth.user = user
        auth.provider = data.provider
        auth.uid = data.uid

        auth.username = data.info.nickname
        auth.name = data.info.name
        auth.email = data.info.email
        auth.avatar_url = data.info.image
      end
    end

    def for_jwt(user)
      find_or_create_by!(provider: :jwt, user: user)
    end
  end

  belongs_to :user, optional: true

  before_validation lambda {
    self.user = User.create!(name: name, email: email, avatar_url: avatar_url)
  }, if: -> { !user_id }

  validates :user_id, presence: true

  after_create lambda {
    user.name ||= name
    user.email ||= email
    user.avatar_url ||= avatar_url
  }

  def track_login!(request)
    update!(
      current_sign_in_at: Time.current,
      current_sign_in_ip: request.remote_ip,
      sign_in_count: sign_in_count + 1
    )
  end

  def track_logout!
    update!(
      last_sign_in_at: current_sign_in_at,
      last_sign_in_ip: current_sign_in_ip
    )
  end
end
