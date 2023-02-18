class Warranty < ApplicationRecord
    validates :warranty_name, presence: true
    validates :warranty_company, presence: true
    validates :warranty_start_date, presence: true
    validates :warranty_end_date, presence: true
end
