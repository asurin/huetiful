class CreateLights < ActiveRecord::Migration
  def change
    create_table :lights do |t|
      t.string          :name
      t.boolean         :on
      t.integer         :brightness
      t.integer         :hue
      t.integer         :saturation
      t.integer         :x
      t.integer         :y
      t.integer         :ct
      t.string          :alert
      t.string          :effect
      t.string          :color_mode
      t.boolean         :reachable
      t.timestamps
    end
  end
end
