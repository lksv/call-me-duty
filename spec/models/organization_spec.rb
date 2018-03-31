require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validates that full_path equal slug' do
    it 'reject when slug != full_path' do
      subject = Organization.new(slug: 'a', full_path: 'b')
      subject.valid?
      expect(subject.errors[:full_path].size).to eq 1
    end
  end
end
