require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "prayer" do
    @expected.subject = 'NotificationMailer#prayer'
    @expected.body    = read_fixture('prayer')
    @expected.date    = Time.now

    assert_equal @expected.encoded, NotificationMailer.create_prayer(@expected.date).encoded
  end

  test "comment" do
    @expected.subject = 'NotificationMailer#comment'
    @expected.body    = read_fixture('comment')
    @expected.date    = Time.now

    assert_equal @expected.encoded, NotificationMailer.create_comment(@expected.date).encoded
  end

end
