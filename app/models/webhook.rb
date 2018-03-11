class Webhook < ApplicationRecord
  belongs_to :team

  validates :uri, presence: true
  validates :uri, format: { with: URI.regexp }, allow_blank: false
  validates :uri, format: { with: /\Ahttp:\/\/|https:\/\// }

  validates :token, format: { with: /\A[-A-Za-z0-9+\/=@ ]*\z/ }
  validates :name, presence: true, uniqueness: { scope: :team }

  strip_attributes only: :name, collapse_spaces: true, replace_newlines: true

  def render(vars)
    template.gsub(/{{\s*([a-zA-Z_][a-zA-Z0-9_]*)\s}}/) do
      vars[$1].to_s
    end
  end
end
