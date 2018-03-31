require 'rails_helper'

describe CMD::RoutesRegexp do
  describe '.expected_leading_words_regexp' do
    subject  { described_class.expected_leading_words_regexp }
    it 'matches common files public directory' do
      expect(subject).to match('500.html')
      expect(subject).to match('404.html')
      expect(subject).to match('robots.txt')
    end

    it 'matches `teams` and `api`' do
      expect(subject).to match('teams')
      expect(subject).to match('api')
    end

    it 'rejects custm strings' do
      expect(subject).not_to match('MyTeam')
      expect(subject).not_to match('anything')
    end
  end

  describe '.expected_team_name_regexp' do
    subject  { described_class.expected_team_name_regexp }
    it 'matches `new` and `incidents`' do
      expect(subject).to match('new')
      expect(subject).to match('incidents')
    end

    it 'rejects custm strings' do
      expect(subject).not_to match('MyTeam')
      expect(subject).not_to match('anything')
    end
  end

  describe '.team_format' do
    subject  { %r{\A#{described_class.team_format}\z} }

    it 'matches words with numbers' do
      expect(subject).to match('WORD123')
      expect(subject).to match('pre123MIDDELE456end789')
    end

    it 'matches words with _ in middle' do
      expect(subject).to match('w_o_r_d_')
    end

    it 'matches words with - in middle' do
      expect(subject).to match('w-o-r-d-')
    end

    it 'rejects words starting [^a-zA-Z]' do
      expect(subject).not_to match(' MyTeam')
      expect(subject).not_to match('_anything')
      expect(subject).not_to match('-anything')
    end

    it 'rejects words with /' do
      expect(subject).not_to match('my/team')
    end

    it 'rejects words with spaces' do
      expect(subject).not_to match('my team')
    end
  end

  describe '.safe_team_format' do
    subject  { %r{\A#{described_class.safe_team_format}\z} }

    it 'matches custom words' do
      expect(subject).to match('word123')
    end

    it 'rejects words `new/`' do
      expect(subject).not_to match('new/')
    end
  end

  describe '.safe_organization_format' do
    subject  { %r{\A#{described_class.safe_organization_format}\z} }

    it 'matches words custom words' do
      expect(subject).to match('word123')
    end

    it 'rejects string `new/`' do
      expect(subject).not_to match('new/')
    end

    it 'rejects string `robots.txt/`' do
      expect(subject).not_to match('robots.txt/')
    end
  end

  describe '.safe_full_path' do
    subject { %r{\A#{described_class.safe_full_path.to_s}\z} }

    it 'matches nested teams' do
      expect(subject).to match('organization/subteam1/subteam2')
    end

    it 'reject nested teams with `new` in team name' do
      expect(subject).not_to match('organization/new/subteam2')
    end

    it 'reject nested teams starting on /api' do
      expect(subject).not_to match('api/subteam1/subteam2')
    end
  end
end
