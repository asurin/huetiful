class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string            :name
      t.integer           :bridge_id
      t.boolean           :all_group
      t.timestamps
    end
  end
end
