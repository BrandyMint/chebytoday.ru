# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
#  delivers_from MAIL_CONFIG[:sender]

  def bail_out(e)
    body=e.inspect+"\n\n"+e.backtrace.join("\n")
    mail(:from => MAIL_CONFIG[:sender],
         :to => MAIL_CONFIG[:recipient],
         :subject => "[Scheduler] #{e.message}",
         :body => body)
    logger.error body
  end

  def message_error(e)
    body=e.inspect+"\n\n"+e.backtrace.join("\n")
    mail(:from => MAIL_CONFIG[:sender],
         :to => MAIL_CONFIG[:recipient],
         :subject => "[error] #{e.message}",
         :body => body)
    logger.error body
  end

  def followed
    mail(:from => MAIL_CONFIG[:sender],
         :to => MAIL_CONFIG[:recipient],
         :subject => "Всех юзверей заволлофил",
         :body => "All users is followed")
  end
  
end
