# == Schema Information
#
# Table name: auths
#
#  id                  :bigint           not null, primary key
#  avatar_url          :string
#  current_sign_in_at  :datetime
#  current_sign_in_ip  :inet
#  email               :string           default(""), not null
#  encrypted_password  :string
#  failed_attempts     :integer          default(0), not null
#  last_sign_in_at     :datetime
#  last_sign_in_ip     :inet
#  locked_at           :datetime
#  name                :string
#  provider            :string
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  uid                 :string
#  unlock_token        :string
#  username            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :bigint
#
# Indexes
#
#  index_auths_on_email         (email) UNIQUE
#  index_auths_on_unlock_token  (unlock_token) UNIQUE
#  index_auths_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class AuthSerializer < ActiveModel::Serializer
  attributes :id,
             :provider,
             :uid,
             :name,
             :username,
             :email,
             :avatar_url,
             :created_at
end