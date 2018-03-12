# == Schema Information
#
# Table name: webhooks
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  name       :string
#  token      :string
#  uri        :string(2000)
#  template   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_webhooks_on_team_id  (team_id)
#

class Webhook < ApplicationRecord
  belongs_to :team
  has_many   :escalation_rules,     as: :targetable

  validates :uri, presence: true
  validates :uri, format: { with: URI.regexp }, allow_blank: false
  validates :uri, format: { with: /\Ahttp:\/\/|https:\/\// }

  validates :token, format: { with: /\A[-A-Za-z0-9+\/=@ ]*\z/ }
  validates :name, presence: true, uniqueness: { scope: :team }

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  def render(vars = {})
    template.gsub(/{{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*}}/) do
      variable = $1
      escaped = variable.sub!(/_escaped\z/, '')
      value = vars[variable.intern].to_s
      escaped ?  value.inspect : value
    end
  end
end
