require_relative '../../spec_helper'

describe TinyORM::Query::Insert::Builder do
  let(:model) { double('User') }
  let(:builder) { described_class.new(model) }

  before { allow(model).to receive(:table_name).and_return('users') }

  it do
    builder.attributes = {name: 'john', age: 20}
    expect(builder.compile!).to eq('INSERT INTO users (name, age) VALUES (john, 20)')
  end
end
