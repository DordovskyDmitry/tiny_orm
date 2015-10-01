require_relative '../../spec/spec_helper'

describe TinyORM::Query::Join do

  let(:join) { described_class.new(TinyORM::Query::Container.new(Model.new('users'))) }

  it { expect(join.set('LEFT JOIN orders ON users.id = orders.user_id').compile!).to eq('LEFT JOIN orders ON users.id = orders.user_id') }
  it { expect(join.set(:orders).compile!).to eq('INNER JOIN orders ON users.id = orders.user_id') }
  it 'many-to-many' do
    expect(join.set(user_addresses: :addresses).compile!)
           .to eq('INNER JOIN user_addresses ON users.id = user_addresses.user_id INNER JOIN addresses ON addresses.id = user_addresses.address_id')
  end
end
