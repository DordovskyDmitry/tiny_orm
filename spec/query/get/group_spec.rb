require_relative '../../spec_helper'

describe TinyORM::Query::Group do

  let(:group) { described_class.new(TinyORM::Query::Get::Builder.new(User)) }

  it { expect(group.set(:price).compile!).to eq('users.price') }
  it { expect(group.set('price, size').compile!).to eq('price, size') }
  it { expect(group.set(:price, :size, 'weight').compile!).to eq('users.price, users.size, users.weight') }
end
