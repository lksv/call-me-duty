# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  phone                  :string
#  name                   :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :calendar_events,        inverse_of: :user
  has_many :escalation_rules,       as: :targetable

  has_many :members
  has_many :teams, through: :members
  has_many :organizations, -> { where(parent_id: nil) }, through: :members, source: 'team'

  # has_and_belongs_to_many :teams

  def services
    Service.where(team_id: teams)
  end

  def visible_users
    all_team_ids = organizations.each do |slug|
      Team.where('full_path like ?', "#{slug}/%").pluck(:id)
    end.flatten.uniq

    User.joins(:members).where(members: { team_id: all_team_ids })
  end

  def visible_delivery_gateways
    DeliveryGateway.where(team_id: teams).distinct
  end
end
