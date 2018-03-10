# == Schema Information
#
# Table name: calendar_events
#
#  id          :integer          not null, primary key
#  calendar_id :integer
#  user_id     :integer
#  start_at    :datetime         not null
#  end_at      :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_calendar_events_on_calendar_id  (calendar_id)
#  index_calendar_events_on_user_id      (user_id)
#

class CalendarEvent < ApplicationRecord
  belongs_to :calendar,   inverse_of: :calendar_events, touch: true
  belongs_to :user,       inverse_of: :calendar_events

  validates :start_at, :end_at, presence: true
  validate :user_in_in_calendar_team


  # returs previews calendar_event (even if there is a gap in schedule)
  def previews
    calendar.ends_before_or_eql(at: start_at)
  end

  # find a following calendar_event (even if there is a gap in a schedule)
  def next
    calendar.starts_after_or_eql(at: end_at)
  end

  private

  def user_in_in_calendar_team
    errors.add(:user_id, "is not in team") unless calendar.users.include?(user)
  end
end
