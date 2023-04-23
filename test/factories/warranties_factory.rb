# frozen_string_literal: true

# Define an exemplar for a basic Warranty
FactoryBot.define do
  factory :warranty do
    sequence(:warranty_name) { |n| "SomeWarranty#{n}" }
    sequence(:warranty_company) { |n| "SomeCompany#{n}" }
    warranty_start_date { 50.days.ago }
    user factory: :user
  end
end
