class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :email,
             :avatar_url
end
