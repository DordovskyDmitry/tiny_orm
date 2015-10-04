require_relative '../../spec_helper'

describe TinyORM::Query::Delete::Builder do
  let(:builder) { described_class.new(User) }

  it 'empty conditions' do
    expect(builder.compile!).to eq('DELETE FROM users')
  end

  it 'with conditions' do
    condition = TinyORM::Query::Where.new(TinyORM::Query::Get::Builder.new(User)).and(name: 'johny')
    another_condition = TinyORM::Query::Where.new(TinyORM::Query::Get::Builder.new(User)).and(age: 20)

    builder.conditions = [condition, another_condition]
    expect(builder.compile!).to eq("DELETE FROM users WHERE (users.name = 'johny') AND (users.age = 20)")
  end
end
