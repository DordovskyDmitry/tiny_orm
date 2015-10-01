require_relative '../spec_helper'

describe TinyORM::Query::Select do

  let(:select) { described_class.new(TinyORM::Query::Container.new(Model.new('products'))) }

  it { expect(select.set(:price).compile!).to eq('products.price') }
  it { expect(select.set('price, size').compile!).to eq('price, size') }
  it { expect(select.set(:price, :size, 'orders.quantity').compile!).to eq('products.price, products.size, orders.quantity') }
end
