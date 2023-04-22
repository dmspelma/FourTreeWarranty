# frozen_string_literal: true

require 'test_helper'

# Test job mails to users about expiring emails
class WarrantyExpiringJobTest < ActiveJob::TestCase
  test 'sends multiple emails' do
    user_one = users(:fox)
    user_two = users(:bob)

    Warranty.create!(
      warranty_name: 'Microwave',
      warranty_company: 'Kenmore',
      warranty_start_date: 40.days.ago,
      warranty_end_date: 15.days.ago,
      user_id: user_one.id
    )
    Warranty.create!(
      warranty_name: 'Fur Coat',
      warranty_company: 'Bizakis',
      warranty_start_date: 100.days.ago,
      warranty_end_date: 1.day.ago,
      user_id: user_one.id
    )
    Warranty.create!(
      warranty_name: 'Laptop',
      warranty_company: 'Lenovo',
      warranty_start_date: 40.days.ago,
      warranty_end_date: Date.current + 10.days,
      user_id: user_two.id
    )

    assert_enqueued_jobs 1 do
      WarrantyExpiringJob.perform_later
    end
    perform_enqueued_jobs

    assert_equal 2, ActionMailer::Base.deliveries.size
  end

  test 'does not email if no warranties are about to expire' do
    user = users(:fox)

    # Expired
    Warranty.create!(
      warranty_name: 'Microwave',
      warranty_company: 'Kenmore',
      warranty_start_date: 40.days.ago,
      warranty_end_date: 15.days.ago,
      user_id: user.id,
      expired: true
    )
    # More than 2 weeks before expiration
    Warranty.create!(
      warranty_name: 'Laptop',
      warranty_company: 'Lenovo',
      warranty_start_date: 40.days.ago,
      warranty_end_date: Date.current + 20.days,
      user_id: user.id
    )

    assert_empty WarrantyExpiringJob.perform_now
  end
end
