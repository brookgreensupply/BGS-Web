class LeadsMailer < ActionMailer::Base
  default to: ::EmailsForLeads
  default from: "admin@#{Rails.application.secrets.domain_name}"

  def email(type, hash)
    @type = type
    @hash = hash
    mail(subject: "[#{Rails.application.secrets.domain_name}] #{type} quote request")
  end
end
