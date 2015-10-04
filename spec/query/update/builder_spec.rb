require_relative '../../spec_helper'

describe TinyORM::Query::Update::Builder do
  let(:builder) { described_class.new(User) }

  it 'empty conditions' do
    builder.attributes = {name: 'john'}
    expect(builder.compile!).to eq('UPDATE users SET (name) VALUES (john)')
  end

  it 'with conditions' do
    condition = TinyORM::Query::Where.new(TinyORM::Query::Get::Builder.new(User)).and(name: 'johny')
    another_condition = TinyORM::Query::Where.new(TinyORM::Query::Get::Builder.new(User)).and(age: 20)

    builder.conditions = [condition, another_condition]
    builder.attributes = {name: 'john'}
    expect(builder.compile!).to eq("UPDATE users SET (name) VALUES (john) WHERE (users.name = 'johny') AND (users.age = 20)")
  end
end
