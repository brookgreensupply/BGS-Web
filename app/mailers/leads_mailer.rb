class LeadsMailer < ActionMailer::Base
  default to: ::EmailsForLeads

  def email(type, hash)
    @type = type
    @hash = hash
    mail(subject: "new website request for #{type} quote")
  end
end
