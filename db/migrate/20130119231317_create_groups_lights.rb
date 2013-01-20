class CreateGroupsLights < ActiveRecord::Migration

  def change
    create_table :groups_lights, :id => false do |t|
      t.integer :group_id
      t.integer :light_id
    end
  end

end
