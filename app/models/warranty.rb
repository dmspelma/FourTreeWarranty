# frozen_string_literal:true

# Handles warranty information
class Warranty < ApplicationRecord
  validates :warranty_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :warranty_company, presence: true, length: { minimum: 2, maximum: 50 }
end
