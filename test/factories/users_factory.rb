# frozen_string_literal: true

# Define an exemplar for a basic User
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "examples+#{n}@example.com" }
    password { 'test1234' }
  end
end
