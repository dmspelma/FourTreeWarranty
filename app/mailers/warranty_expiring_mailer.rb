# frozen_string_literal: true

# For warranties about to expire
class WarrantyExpiringMailer < ApplicationMailer
  # Mailer for notifing when warranty(s) are two weeks or less from expiring
  def email(to_address, warranties)
    @warranties = warranties
    mail(to: to_address, subject:)
  end

  private

  def subject
    "You have #{@warranties.size} expiring warranty(s)!"
  end
end
