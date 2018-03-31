module TeamsHelper
  def show_team_path(team, teams_cache: [])
    teams_by_path = teams_cache.group_by(&:full_path)

    last = ''
    result = team.full_path.split('/').map do |current_team_slug|
      last = '%s/%s' % [last, current_team_slug]
      last.sub!(/\A\//, '')
      teams_by_path[last]&.first || last
    end
    result = result.map { |team| Team === team ? link_to(team.name, team_incidents_path(team)) : team }
    result[result.size-1] = content_tag(:strong) do
      result.last
    end
    result.join(' / ').html_safe
  end
end
