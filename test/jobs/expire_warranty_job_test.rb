# frozen_string_literal: true

require 'test_helper'

# Tests for job to mark warranties as expired
class ExpireWarrantyJobTest < ActiveJob::TestCase
  test 'expires transactions successfully' do
    user = users(:bob)
    warranty = Warranty.create!(
      warranty_name: 'Playstation',
      warranty_company: 'Gamestop',
      warranty_start_date: 50.days.ago,
      warranty_end_date: 1.day.ago,
      user_id: user.id,
      expired: false # default
    )

    assert_difference 'Warranty.where(expired: true).count', 1, 'created warranty should be expired' do
      ExpireWarrantyJob.perform_now
    end

    warranty.reload
    assert_equal warranty.expired, true
  end

  test 'if no warranties are set to expire' do
    assert_equal Warranty.where(expired: false).where('warranty_end_date < ?', Date.current).count, 0

    assert_no_difference 'Warranty.where(expired: true).count', 'no warranties should be changed to expired' do
      ExpireWarrantyJob.perform_now
    end
  end
end
