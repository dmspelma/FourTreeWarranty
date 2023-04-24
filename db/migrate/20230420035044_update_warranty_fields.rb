# frozen_string_literal: true

# Update warranty fields to include user foreign key.
# Also, adding other fields outlined in diagram.
class UpdateWarrantyFields < ActiveRecord::Migration[6.1]
  def change
    change_table :warranties do |t|
      t.references :user, foreign_key: true
      t.boolean :expired, default: false, null: false
      t.datetime :deleted_at
    end
  end
end
