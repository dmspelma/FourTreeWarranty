# frozen_string_literal: true

set :output, 'log/cron_log.log' # Helps investigate issues
# NOTE: The times below are meant for utc time.

# Fire email notifying users of warranties soon to expire
every 1.day, at: '9am' do
  runner 'WarrantyExpiringJob.perform_later'
end

# Find and Expire warranties every day
every 1.day, at: '8:30am' do
  runner 'ExpireWarrantyJob.perform_now'
end
