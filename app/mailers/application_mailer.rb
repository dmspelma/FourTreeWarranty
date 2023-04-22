# frozen_string_literal: true

# Application level mailer defaults
class ApplicationMailer < ActionMailer::Base
  default from: 'thisfoxcodes@gmail.com'
  layout 'mailer'
end
