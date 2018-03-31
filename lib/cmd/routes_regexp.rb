module CMD
  module RoutesRegexp
    extend self
    def expected_leading_words_regexp
      @expected_leading_words_regexp ||=
        Regexp.union(
          %w(teams api) +
          Dir.entries(Rails.root + 'public')
      ).freeze
    end

    def expected_team_name_regexp
      @expected_team_name_regexp ||=
        Regexp.union(
          %w(incidents new calendar teams)
      ).freeze
    end


    def team_format
      @team_format ||= '[a-zA-Z][a-zA-Z0-9_-]*'
    end

    def safe_team_format
      "(?!(?:#{expected_team_name_regexp})/)#{team_format}"
    end

    def safe_organization_format
      "(?!(?:#{expected_leading_words_regexp})/)#{team_format}"
    end

    def safe_full_path
      %r{#{safe_organization_format}(/#{safe_team_format})*}
    end
  end
end
