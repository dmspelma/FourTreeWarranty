# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/warranty_expiring_mailer
class WarrantyExpiringMailerPreview < ActionMailer::Preview
  def email
    user = User.find(262_201_575)

    warranties = Warranty.where('warranty_end_date < ?', Date.current + 14.days)
                         .where(user_id: user.id)
                         .where(expired: false)

    WarrantyExpiringMailer.email(user.email, warranties)
  end
end
