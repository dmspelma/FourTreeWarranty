# frozen_string_literal:true

# Handles warranty information
class Warranty < ApplicationRecord
  belongs_to :user

  validates :warranty_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :warranty_company, presence: true, length: { minimum: 2, maximum: 50 }
  validates :warranty_start_date, presence: true
  validates :extra_info, length: { maximum: 250 }
  validates :user_id, presence: true
end
