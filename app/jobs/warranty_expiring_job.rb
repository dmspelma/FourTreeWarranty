# frozen_string_literal: true

# Job to find warranties about to expire and notify the user
class WarrantyExpiringJob < ApplicationJob
  queue_as :default

  def perform
    return if expiring_warranties.nil?

    users.each do |u|
      warranties = expiring_warranties.where(user_id: u.id).order(:warranty_name)
      WarrantyExpiringMailer.email(u.email, warranties).deliver_now
    end
  end

  private

  def expiring_warranties
    @expiring_warranties ||= Warranty.includes(:user)
                                     .where('warranty_end_date < ?', Date.current + 14.days)
                                     .where(expired: false)
  end

  def users
    expiring_warranties.map(&:user).uniq
  end
end
