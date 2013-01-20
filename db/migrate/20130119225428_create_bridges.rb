class CreateBridges < ActiveRecord::Migration
  def change
    create_table :bridges do |t|
      t.string            :name
      t.string            :host
      t.string            :mac_address
      t.string            :username
      t.boolean           :registered
      t.timestamps
    end
  end
end
