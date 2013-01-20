class CreateBridges < ActiveRecord::Migration
  def change
    create_table :bridges do |t|
      t.string            :name
      t.string            :ip_address
      t.string            :mac_address
      t.string            :username
      t.boolean           :valid
      t.timestamps
    end
  end
end
