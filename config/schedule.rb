# frozen_string_literal: true

# NOTE: The times below are actually utc time.

# Fire email notifying users of warranties soon to expire
every 1.day, at: '9am' do
  WarrantyExpiringJob.perform_now
end

# Find and Expire warranties every day
every 1.day, at: '8:30am' do
  ExpireWarrantyJob.perform_now
end
