require_relative '../spec_helper'

describe TinyORM::Query::Order do

  let(:order) { described_class.new(TinyORM::Query::Container.new('users')) }

  it { expect(order.set(:price).compile!).to eq('users.price') }
  it { expect(order.set('price ASC, popularity DESC').compile!).to eq('price ASC, popularity DESC') }
  it { expect(order.set(:price, :popularity => :desc).compile!).to eq('users.price, users.popularity DESC') }
  it { expect(order.set(:price => :asc, :popularity => :desc).compile!).to eq('users.price, users.popularity DESC') }
end
