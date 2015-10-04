require_relative '../../spec_helper'

describe TinyORM::Query::Insert::Builder do
  let(:builder) { described_class.new(User) }

  it do
    builder.attributes = {name: 'john', age: 20}
    expect(builder.compile!).to eq('INSERT INTO users (name, age) VALUES (john, 20)')
  end
end
