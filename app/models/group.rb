class Group < ActiveRecord::Base

  belongs_to                  :bridge
  has_and_belongs_to_many     :lights

end
