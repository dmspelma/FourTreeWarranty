# frozen_string_literal:true

# Handles warranty information
class Warranty < ApplicationRecord
  before_validation :set_default_warranty_end_date

  belongs_to :user

  validates :warranty_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :warranty_company, presence: true, length: { minimum: 2, maximum: 50 }
  validates_date :warranty_start_date, presence: true, on_or_before: -> { Date.current }
  validates_date :warranty_end_date,
                 after: -> { :warranty_start_date },
                 message: 'end date must be after start date',
                 allow_nil: true
  validates :extra_info, length: { maximum: 250 }

  def set_default_warranty_end_date
    self.warranty_end_date ||= nil
  end
end
