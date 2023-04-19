# frozen_string_literal: true

# Default Warranty creation
class CreateWarranties < ActiveRecord::Migration[6.1]
  def change
    create_table :warranties do |t|
      t.string :warranty_name
      t.string :warranty_company
      t.text :extra_info
      t.datetime :warranty_start_date
      t.datetime :warranty_end_date

      t.timestamps
    end
  end
end
