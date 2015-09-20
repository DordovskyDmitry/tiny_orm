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
      it { expect(where.and('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'or' do
    it { expect(where.or(name: 'john').compile!).to eq("(name = 'john')") }
    it { expect(where.or(name: 'john', email: 'john@gmail.com').compile!).to eq("(name = 'john' AND email = 'john@gmail.com')") }
    it { expect(where.or(name: 'john').or(email: 'john@gmail.com').compile!).to eq("(name = 'john') OR (email = 'john@gmail.com')") }

    context 'nil' do
      it { expect(where.or(name: nil, email: 'john@gmail.com').compile!).to eq("(name IS NULL AND email = 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.or('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'not' do
    it { expect(where.not(name: 'john').compile!).to eq("NOT(name = 'john')") }
    it { expect(where.not(name: 'john', email: 'john@gmail.com').compile!).to eq("NOT(name = 'john' AND email = 'john@gmail.com')") }
    it { expect(where.not(name: 'john').not(email: 'john@gmail.com').compile!).to eq("NOT(name = 'john') AND NOT(email = 'john@gmail.com')") }

    context 'nil' do
      it { expect(where.not(name: nil).compile!).to eq('NOT(name IS NULL)') }
      it { expect(where.not(name: nil, email: 'john@gmail.com').compile!).to eq("NOT(name IS NULL AND email = 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.not('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'like' do
    it { expect(where.like(name: 'john').compile!).to eq("(name LIKE 'john')") }
    it { expect(where.like(name: 'john', email: 'john@gmail.com').compile!).to eq("(name LIKE 'john' AND email LIKE 'john@gmail.com')") }
    it { expect(where.like(name: 'john').like(email: 'john@gmail.com').compile!).to eq("(name LIKE 'john') AND (email LIKE 'john@gmail.com')") }

    context 'nil' do
      it { expect(where.like(name: nil).compile!).to eq('(name IS NULL)') }
      it { expect(where.like(name: nil, email: 'john@gmail.com').compile!).to eq("(name IS NULL AND email LIKE 'john@gmail.com')") }
    end

    context 'string' do
      it { expect(where.like('email is not null').compile!).to eq('(email is not null)') }
    end
  end

  context 'mix' do
    it { expect(where.and(name: 'john').or(email: 'john@gmail.com').compile!).to eq("(name = 'john') OR (email = 'john@gmail.com')") }
    it { expect(where.and(name: 'john').or(email: 'john@gmail.com').not(age: 20).compile!).to eq("(name = 'john') OR (email = 'john@gmail.com') AND NOT(age = 20)") }
    it { expect(where.and(name: 'john').like(email: '%john@gmail.com').compile!).to eq("(name = 'john') AND (email LIKE '%john@gmail.com')") }
  end

  context 'object as argument' do
    let(:subwhere) { TinyORM::Query::Where.new }

    it { expect(where.and(subwhere.and(name: 'john')).compile!).to eq("(name = 'john')") }
    it { expect(where.and(name: 'sam').or(subwhere.and(name: 'john').or(name: 'bob')).compile!).to eq("(name = 'sam') OR (name = 'john') OR (name = 'bob')") }
  end
end
