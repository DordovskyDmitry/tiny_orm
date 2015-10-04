require_relative '../spec_helper'

describe TinyORM::Association::HasOne do
  context 'one-to-many' do
    context 'default' do
      let(:has_many) { User.associations(:friends) }
      it { expect(has_many.owner).to eq(User) }
      it { expect(has_many.target).to eq(Friend) }
      it { expect(has_many.internal_key).to eq(:id) }
      it { expect(has_many.external_key).to eq(:user_id) }
      it { expect(has_many.path).to eq([has_many]) }
    end

    context 'custom' do
      class Firm < TinyORM::Base
        has_many :customers, class_name: 'User', internal_key: :internal_id, external_key: :firm_id
      end

      let(:has_many) { Firm.associations(:customers) }
      it { expect(has_many.owner).to eq(Firm) }
      it { expect(has_many.target).to eq(User) }
      it { expect(has_many.internal_key).to eq(:internal_id) }
      it { expect(has_many.external_key).to eq(:firm_id) }
      it { expect(has_many.path).to eq([has_many]) }
    end
  end

  context 'many-to-many' do
    context 'default' do
      let(:has_many) { Author.associations(:books) }
      it { expect(has_many.owner).to eq(Author) }
      it { expect(has_many.target).to eq(Book) }
      it { expect(has_many.internal_key).to eq(:id) }
      it { expect(has_many.external_key).to eq(:id) }

      describe 'path' do
        let(:path) { has_many.path }
        it { expect(path.count).to eq(2) }

        context 'first' do
          let(:first) { path.first }
          it { expect(first.owner).to eq(Author) }
          it { expect(first.target).to eq(AuthorBook) }
          it { expect(first.internal_key).to eq(:id) }
          it { expect(first.external_key).to eq(:author_id) }
        end

        context 'second(use keys from opposite assoc since direct does not exist)' do
          let(:second) { path.last }
          it { expect(second.owner).to eq(AuthorBook) }
          it { expect(second.target).to eq(Book) }
          it { expect(second.internal_key).to eq(:book_id) }
          it { expect(second.external_key).to eq(:id) }
        end
      end
    end

    context 'custom' do
      class Firm < TinyORM::Base
        has_many :firm_orders, external_key: :performer_id
        has_many :orders, through: :firm_orders
      end

      class Order < TinyORM::Base
        has_many :firms, through: :firm_orders
      end

      class FirmOrder < TinyORM::Base
        belongs_to :firm, internal_key: :performer_id
        belongs_to :order, internal_key: :booking_id
      end

      let(:has_many) { Firm.associations(:orders) }
      it { expect(has_many.owner).to eq(Firm) }
      it { expect(has_many.target).to eq(Order) }
      it { expect(has_many.internal_key).to eq(:id) }
      it { expect(has_many.external_key).to eq(:id) }

      describe 'path' do
        let(:path) { has_many.path }
        it { expect(path.count).to eq(2) }

        context 'first' do
          let(:first) { path.first }
          it { expect(first.owner).to eq(Firm) }
          it { expect(first.target).to eq(FirmOrder) }
          it { expect(first.internal_key).to eq(:id) }
          it { expect(first.external_key).to eq(:performer_id) }
        end

        context 'second' do
          let(:second) { path.last }
          it { expect(second.owner).to eq(FirmOrder) }
          it { expect(second.target).to eq(Order) }
          it { expect(second.internal_key).to eq(:booking_id) }
          it { expect(second.external_key).to eq(:id) }
        end
      end
    end
  end
end
