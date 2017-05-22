text = ENV['EMAIL_LEADS_TO']
emails = text.gsub(/\s/,'').split(',') if text
emails ||= []
::EmailsForLeads = emails
