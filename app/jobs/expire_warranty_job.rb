# frozen_string_literal: true

# Expire warranties if warranty_end_date is less than today
class ExpireWarrantyJob < ApplicationJob
  queue_as :default

  def perform
    ActiveRecord::Base.transaction do
      warranties_to_expire.each do |w|
        w.update!(expired: true)
      end
    rescue StandardError => e
      # Handle any exceptions that occur during the transaction
      raise ActiveRecord::Rollback, e.message
    end
  end

  def warranties_to_expire
    @warranties_to_expire ||= Warranty.where(expired: false).where('warranty_end_date < ?', Date.current)
  end
end
