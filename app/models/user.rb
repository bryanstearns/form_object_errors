class User < ActiveRecord::Base
  attr_accessible :login, :name

  validates :login, :name, :length => {:minimum => 3}
end
