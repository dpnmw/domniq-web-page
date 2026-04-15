# frozen_string_literal: true

class CreateDwpConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :dwp_configs do |t|
      t.string  :config_type,  null: false
      t.string  :config_key,   null: false
      t.text    :config_value, null: false, default: ""
      t.integer :position,     default: 0
      t.boolean :enabled,      default: true
      t.timestamps
    end

    add_index :dwp_configs, %i[config_type config_key],
              unique: true,
              name: "idx_dwp_configs_unique"
  end
end
