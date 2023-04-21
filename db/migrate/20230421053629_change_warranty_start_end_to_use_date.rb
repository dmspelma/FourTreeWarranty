# frozen_string_literal:true

# Change warranty start/end dates to use date instead of datetime
class ChangeWarrantyStartEndToUseDate < ActiveRecord::Migration[6.1]
  def change
    change_column :warranties, :warranty_start_date, :date
    change_column :warranties, :warranty_end_date, :date
  end
end
