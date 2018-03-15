# == Schema Information
#
# Table name: delivery_gateways
#
#  id         :integer          not null, primary key
#  name       :string
#  type       :string
#  team_id    :integer
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_delivery_gateways_on_team_id  (team_id)
#  index_delivery_gateways_on_type     (type)
#

class WebhookGateway < DeliveryGateway
  store_accessor :data, :uri, :http_method, :headers, :template

  validates :uri, presence: true
  validates :uri, format: { with: URI.regexp }, allow_blank: false
  validates :uri, format: { with: /\Ahttp:\/\/|https:\/\// }

  validates :http_method, inclusion: { in: %w(GET POST PUT) }
  after_initialize :initialize_defaults, :if => :new_record?

  def personal?
    false
  end

  private

  def initialize_defaults
    self.headers ||= {}
    self.http_method ||= 'POST'
    self.template ||= <<EOF
{
  "event": {{event | toJson}},
  "id": {{id}},
  "iid": {{iid}},
  "title" : {{title | toJson}}
}
EOF
  end
end
