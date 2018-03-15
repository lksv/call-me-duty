# == Schema Information
#
# Table name: calendars
#
#  id                        :integer          not null, primary key
#  team_id                   :integer
#  current_calendar_event_id :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_calendars_on_current_calendar_event_id  (current_calendar_event_id)
#  index_calendars_on_team_id                    (team_id)
#

class Calendar < ApplicationRecord
  belongs_to :team
  has_many :calendar_events, dependent: :destroy, inverse_of: :calendar
  belongs_to :current_calendar_event,
    class_name: 'CalendarEvent',
    foreign_key: :current_calendar_event_id,
    optional: true

  validate :current_calendar_event_belongs_to_this_calendar

  delegate :users, to: :team

  def current_oncall_user
    current_calendar_event&.user
  end

  def calculate_current_calendar_event(at: DateTime.now)
    cce = current_calendar_event
    return if cce && (cce.start_at <= at) && (at < cce.end_at)
    self.current_calendar_event = event_at(at: at)
  end

  # Returns DateTime of next change. It could be:
  # * `#end_at` of current_calendar_event, if current_calendar_event exists
  # * `#start_at` of first upcomming calendar_event when no current_calendar_event
  # * `nil` when no current_calendar_event and no further events
  #
  # It do not handle cases when `at` is behind the current_calendar_event
  def next_change_at(at:)
    cce = current_calendar_event
    return cce.end_at if cce && (cce.start_at <= at) && (at < cce.end_at)
    starts_after_or_eql(at: at)&.start_at
  end

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

  # def oncall_at(at: Time.now)
  #   event_at(at: at)&.user
  # end

  private

  def current_calendar_event_belongs_to_this_calendar
    return unless current_calendar_event

    unless current_calendar_event.calendar == self
      errors.add(:current_calendar_event, 'has to belongs to this calendar')
    end
  end
end
