require_relative '../../spec/spec_helper'

describe TinyORM::Query::Where do

  let(:where) { TinyORM::Query::Where.new }

  context 'and' do
    it { expect(where.and(name: 'john').compile!).to eq("(name = 'john')") }
    it { expect(where.and(name: 'john', email: 'john@gmail.com').compile!).to eq("(name = 'john' AND email = 'john@gmail.com')") }
    it { expect(where.and(name: 'john').and(email: 'john@gmail.com').compile!).to eq("(name = 'john') AND (email = 'john@gmail.com')") }

    context 'nil' do
      it { expect(where.and(name: nil, email: 'john@gmail.com').compile!).to eq("(name IS NULL AND email = 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.and('email is not null').compile!).to eq('email is not null') }
    end
  end
end
