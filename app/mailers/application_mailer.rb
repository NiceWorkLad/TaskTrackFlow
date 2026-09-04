class ApplicationMailer < ActionMailer::Base
  default from: "TaskTracker <noreply@contact.tasktrackflow.com>"
  layout "mailer"
end
