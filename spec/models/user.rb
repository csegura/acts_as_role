class User < ActiveRecord::Base
  acts_as_role :roles, :values => %w(user admin editor reader), :default => :user
end
