class ContactMailer < ApplicationMailer
  default from: 'EricMulligan.ca Website <eric.pierre.mulligan@gmail.com>'

  def submit_contact(contact)
    @contact = contact
    mail(to: 'eric.pierre.mulligan@gmail.com', subject: 'EricMulligan.ca - Contact Form Submission')
  end
end
