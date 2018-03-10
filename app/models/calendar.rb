# == Schema Information
#
# Table name: calendars
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_calendars_on_team_id  (team_id)
#

class Calendar < ApplicationRecord
  belongs_to :team
  has_many :calendar_events, dependent: :destroy, inverse_of: :calendar

  delegate :users, to: :team

  # get event which is active at particulart time (by default now)
  # When more evens are active at the given time, the one which started first
  # will be returned
  def event_at(at: Datetime.now)
    start_at_field = CalendarEvent.arel_table[:start_at]
    end_at_field = CalendarEvent.arel_table[:end_at]
    calendar_events.where(start_at_field.lteq(at))
      .where(end_at_field.gt(at))
      .limit(1)
      .order(start_at_field.asc())
      .first
  end

  def ends_before_or_eql(at:)
    end_at_field = CalendarEvent.arel_table[:end_at]
    calendar_events.where(end_at_field.lteq(at))
      .limit(1)
      .order(end_at_field.desc())
      .first
  end

  def starts_after_or_eql(at:)
    start_at_field = CalendarEvent.arel_table[:start_at]
    calendar_events.where(start_at_field.gteq(at))
      .limit(1)
      .order(start_at_field.asc())
      .first
  end

end
