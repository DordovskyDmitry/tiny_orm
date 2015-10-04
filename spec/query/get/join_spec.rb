require_relative '../../spec_helper'

describe TinyORM::Query::Join do

  let(:join) { described_class.new(TinyORM::Query::Get::Builder.new(Author)) }

  it { expect(join.set('LEFT JOIN orders ON authors.id = orders.author_id').compile!).to eq('LEFT JOIN orders ON authors.id = orders.author_id') }
  it { expect(join.set(:inner, :profile).compile!).to eq('INNER JOIN profiles ON authors.id = profiles.author_id') }
  it { expect(join.set(:left, :profile).compile!).to eq('LEFT JOIN profiles ON authors.id = profiles.author_id') }
  it { expect(join.set(:books).compile!).to eq('INNER JOIN author_books ON authors.id = author_books.author_id INNER JOIN books ON author_books.book_id = books.id')}

  it { expect(join.set(profile: :photos).compile!).to eq('INNER JOIN profiles ON authors.id = profiles.author_id INNER JOIN photos ON profiles.id = photos.profile_id')}
end
