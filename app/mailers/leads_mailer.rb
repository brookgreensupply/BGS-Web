class LeadsMailer < ActionMailer::Base
  default to: ::EmailsForLeads
  default from: "admin@#{Rails.application.secrets.domain_name}"

  def email(type, hash)
    @type = type
    @hash = hash
    mail(subject: "new website request for #{type} quote")
  end
end
