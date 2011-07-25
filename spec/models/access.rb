class Access < ActiveRecord::Base  
  acts_as_role :flag, :values => %w(owner manager employee), :message => "invalid role"
end
