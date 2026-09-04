require "test_helper"
require "action_mailer/test_helper"

class UserTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  test "welcome email is sent with correct details" do
    email_address = "test-#{SecureRandom.hex(4)}@example.com"

    assert_emails 1 do
      User.create!(
        email: email_address,
        password: "password123",
        password_confirmation: "password123"
      )

      perform_enqueued_jobs
    end

    email = ActionMailer::Base.deliveries.last

    assert_equal [ email_address ], email.to
    assert_equal [ "noreply@contact.tasktrackflow.com" ], email.from
    assert_equal "Welcome to TaskTracker!", email.subject
  end
end
