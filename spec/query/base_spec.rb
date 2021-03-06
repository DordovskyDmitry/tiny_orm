require_relative '../spec_helper'

describe TinyORM::Query::Base do
  let(:base) { described_class.new(User) }

  it { expect { User.where(id: 1) }.to_not raise_error}
  it { expect { User.having("name = 'John'") }.to_not raise_error}
  it { expect { User.select(:id, :name) }.to_not raise_error}
  it { expect { User.join(:friends) }.to_not raise_error}
  it { expect { User.group(:name) }.to_not raise_error}
  it { expect { User.order(name: :desc) }.to_not raise_error}
  it { expect { User.limit(10) }.to_not raise_error}
  it { expect { User.offset(10) }.to_not raise_error}
  it { expect { User.update('age > 12',name: 'John') }.to_not raise_error}
  it { expect { User.insert(name: 'John') }.to_not raise_error}
  it { expect { User.delete(name: 'John') }.to_not raise_error}
end
