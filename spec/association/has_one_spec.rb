require_relative '../spec_helper'

describe TinyORM::Association::HasOne do
  context 'default' do
    let(:has_one) { Author.associations(:profile) }
    it { expect(has_one.owner).to eq(Author) }
    it { expect(has_one.target).to eq(Profile) }
    it { expect(has_one.internal_key).to eq(:id) }
    it { expect(has_one.external_key).to eq(:author_id) }
    it { expect(has_one.path).to eq([has_one]) }
  end

  context 'custom' do
    class Firm < TinyORM::Base
      has_one :director, class_name: 'User', internal_key: :identifier, external_key: :firm_id
    end

    let(:has_one) { Firm.associations(:director) }
    it { expect(has_one.owner).to eq(Firm) }
    it { expect(has_one.target).to eq(User) }
    it { expect(has_one.internal_key).to eq(:identifier) }
    it { expect(has_one.external_key).to eq(:firm_id) }
  end
end
