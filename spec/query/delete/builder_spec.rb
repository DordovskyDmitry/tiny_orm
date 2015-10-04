require_relative '../../spec_helper'

describe TinyORM::Query::Delete::Builder do
  let(:model) { double('User') }
  let(:builder) { described_class.new(model) }

  before { allow(model).to receive(:table_name).and_return('users') }

  it 'empty conditions' do
    expect(builder.compile!).to eq('DELETE FROM users')
  end

  it 'with conditions' do
    condition = TinyORM::Query::Where.new(TinyORM::Query::Get::Builder.new(model)).and(name: 'johny')
    another_condition = TinyORM::Query::Where.new(TinyORM::Query::Get::Builder.new(model)).and(age: 20)

    builder.conditions = [condition, another_condition]
    expect(builder.compile!).to eq("DELETE FROM users WHERE (users.name = 'johny') AND (users.age = 20)")
  end
end
