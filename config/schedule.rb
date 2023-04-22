# frozen_string_literal: true

# Fire email notifying users of warranties soon to expire
every 1.day, at: '9am' do
  WarrantyExpiringJob.perform_now
end
