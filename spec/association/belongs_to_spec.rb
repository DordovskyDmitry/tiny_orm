require_relative '../spec_helper'

describe TinyORM::Association::BelongsTo do
  context 'default' do
    let(:belongs_to) { Photo.associations(:profile) }
    it { expect(belongs_to.owner).to eq(Photo) }
    it { expect(belongs_to.target).to eq(Profile) }
    it { expect(belongs_to.internal_key).to eq(:profile_id) }
    it { expect(belongs_to.external_key).to eq(:id) }
    it { expect(belongs_to.path).to eq([belongs_to]) }
  end

  context 'custom' do
    class Firm < TinyORM::Base
    end

    class Worker < TinyORM::Base
      belongs_to :something, internal_key: :firm_id, external_key: :firm_id, class_name: 'Firm'
    end

    let(:belongs_to) { Worker.associations(:something) }
    it { expect(belongs_to.owner).to eq(Worker) }
    it { expect(belongs_to.target).to eq(Firm) }
    it { expect(belongs_to.internal_key).to eq(:firm_id) }
    it { expect(belongs_to.external_key).to eq(:firm_id) }
  end
end
