# == Schema Information
#
# Table name: teams
#
#  id               :integer          not null, primary key
#  name             :string           default(""), not null
#  type             :string
#  description      :text
#  parent_id        :integer
#  owner_id         :integer
#  slug             :string           default(""), not null
#  full_path        :string           default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  visibility_level :integer          default(0), not null
#
# Indexes
#
#  index_teams_on_full_path           (full_path) UNIQUE
#  index_teams_on_owner_id            (owner_id)
#  index_teams_on_parent_id           (parent_id)
#  index_teams_on_parent_id_and_name  (parent_id,name) UNIQUE
#  index_teams_on_parent_id_and_slug  (parent_id,slug) UNIQUE
#  index_teams_on_type                (type)
#

class Organization < Team

  validates :parent,           absence: true
  validate :full_path_is_slug

  private

  def full_path_is_slug
    errors.add(:full_path, 'must equal to slug') unless full_path == slug
  end
end
