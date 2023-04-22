# frozen_string_literal: true

require 'test_helper'

# For testing warrannties that are about to expire
class WarrantyExpiringMailerTest < ActionMailer::TestCase
  test 'Successful Email Sent' do
    user_one = users(:fox)

    Warranty.create!(
      warranty_name: 'Microwave',
      warranty_company: 'Kenmore',
      warranty_start_date: 40.days.ago,
      warranty_end_date: 15.days.ago,
      user_id: user_one.id
    )
    Warranty.create!(
      warranty_name: 'Laptop',
      warranty_company: 'Lenovo',
      warranty_start_date: 40.days.ago,
      warranty_end_date: 16.days.ago,
      user_id: user_one.id
    )

    warranties = Warranty.where('warranty_end_date < ?', Date.current + 14.days)
                         .where(user_id: user_one.id)
                         .where(expired: false)
    email = WarrantyExpiringMailer.email(user_one.email, warranties)

    # Assert
    assert_emails 1 do
      email.deliver_now
    end
    assert_equal "You have #{warranties.size} expiring warranty(s)!", email.subject
    assert_equal [user_one.email], email.to
    assert_match warranties.first.warranty_name.to_s, email.body.to_s
    assert_match warranties.first.warranty_end_date.to_formatted_s(format: '%m-%d-%Y'), email.body.to_s
    assert_match warranties.last.warranty_name.to_s, email.body.to_s
    assert_match warranties.last.warranty_end_date.to_formatted_s(format: '%m-%d-%Y'), email.body.to_s
  end
end
