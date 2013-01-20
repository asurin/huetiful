class Bridge < ActiveRecord::Base
  has_many          :groups

  attr_accessible   :username, :name, :host, :registered
end
