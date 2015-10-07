require_relative '../../spec_helper'

describe TinyORM::Query::Where do

  let(:where) { described_class.new(TinyORM::Query::Get::Builder.new(User)) }

  context 'and' do
    it { expect(where.and(name: 'john').compile!).to eq("(users.name = 'john')") }
    it { expect(where.and(name: 'john', email: 'john@gmail.com').compile!).to eq("(users.name = 'john' AND users.email = 'john@gmail.com')") }
    it { expect(where.and(name: 'john').and(email: 'john@gmail.com').compile!).to eq("(users.name = 'john') AND (users.email = 'john@gmail.com')") }
    it { expect(where.and(name: %w(john bob sam)).compile!).to eq("(users.name IN ('john', 'bob', 'sam'))") }
    it { expect(where.and(age: 12..14).compile!).to eq('(users.age BETWEEN 12 AND 14)') }
    it { expect(where.and(age: Date.new(2015, 10, 7).prev_day..Date.new(2015, 10, 7)).compile!).to eq("(users.age BETWEEN '2015-10-06' AND '2015-10-07')") }

    context 'nil' do
      it { expect(where.and(name: nil, email: 'john@gmail.com').compile!).to eq("(users.name IS NULL AND users.email = 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.and('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'or' do
    it { expect(where.or(name: 'john').compile!).to eq("(users.name = 'john')") }
    it { expect(where.or(name: 'john', email: 'john@gmail.com').compile!).to eq("(users.name = 'john' AND users.email = 'john@gmail.com')") }
    it { expect(where.or(name: 'john').or(email: 'john@gmail.com').compile!).to eq("(users.name = 'john') OR (users.email = 'john@gmail.com')") }

    context 'nil' do
      it { expect(where.or(name: nil, email: 'john@gmail.com').compile!).to eq("(users.name IS NULL AND users.email = 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.or('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'not' do
    it { expect(where.not(name: 'john').compile!).to eq("NOT(users.name = 'john')") }
    it { expect(where.not(name: 'john', email: 'john@gmail.com').compile!).to eq("NOT(users.name = 'john' AND users.email = 'john@gmail.com')") }
    it { expect(where.not(name: 'john').not(email: 'john@gmail.com').compile!).to eq("NOT(users.name = 'john') AND NOT(users.email = 'john@gmail.com')") }

    context 'nil' do
      it { expect(where.not(name: nil).compile!).to eq('NOT(users.name IS NULL)') }
      it { expect(where.not(name: nil, email: 'john@gmail.com').compile!).to eq("NOT(users.name IS NULL AND users.email = 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.not('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'like' do
    it { expect(where.like(name: 'john').compile!).to eq("(users.name LIKE 'john')") }
    it { expect(where.like(name: 'john', email: 'john@gmail.com').compile!).to eq("(users.name LIKE 'john' AND users.email LIKE 'john@gmail.com')") }
    it { expect(where.like(name: 'john').like(email: 'john@gmail.com').compile!).to eq("(users.name LIKE 'john') AND (users.email LIKE 'john@gmail.com')") }

    context 'nil' do
      it { expect(where.like(name: nil).compile!).to eq('(users.name IS NULL)') }
      it { expect(where.like(name: nil, email: 'john@gmail.com').compile!).to eq("(users.name IS NULL AND users.email LIKE 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.like('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'update' do
    it { expect { where.like(name: 'john').update(name: 'johny') }.to_not raise_error }
  end

  context 'delete' do
    it { expect { where.like(name: 'john').delete }.to_not raise_error }
  end

  context 'mix' do
    it { expect(where.and(name: 'john').or(email: 'john@gmail.com').compile!).to eq("(users.name = 'john') OR (users.email = 'john@gmail.com')") }
    it { expect(where.and(name: 'john').or(email: 'john@gmail.com').not(age: 20).compile!).to eq("(users.name = 'john') OR (users.email = 'john@gmail.com') AND NOT(users.age = 20)") }
    it { expect(where.and(name: 'john').like(email: '%john@gmail.com').compile!).to eq("(users.name = 'john') AND (users.email LIKE '%john@gmail.com')") }
  end

  context 'object as argument' do
    let(:subwhere) { TinyORM::Query::Where.new(TinyORM::Query::Get::Builder.new(Book)) }

    it { expect(where.and(subwhere.and(name: 'john')).compile!).to eq("(books.name = 'john')") }
    it { expect(where.and(name: 'sam').or(subwhere.and(name: 'john').or(name: 'bob')).compile!).to eq("(users.name = 'sam') OR (books.name = 'john') OR (books.name = 'bob')") }
  end
end
