class Group < ActiveRecord::Base

  belongs_to                  :bridge
  has_and_belongs_to_many     :lights

  attr_accessible             :name, :all_group

  before_destroy :verify_not_all
  before_save :verify_not_all

  def verify_not_all
    !all_group || id.nil?
  end

end
