require_relative '../../spec_helper'

describe TinyORM::Query::Select do

  let(:select) { described_class.new(TinyORM::Query::Get::Builder.new(Book)) }

  it { expect(select.set(:price).compile!).to eq('books.price') }
  it { expect(select.set('price, size').compile!).to eq('price, size') }
  it { expect(select.set(:price, :size, 'orders.quantity').compile!).to eq('books.price, books.size, orders.quantity') }
end
