require_relative '../spec_helper'

class Profile < TinyORM::Base
end

class Book < TinyORM::Base
end

class Photo < TinyORM::Base
  self.table_name = 'photos'
  belongs_to :profile
end

class AuthorBook < TinyORM::Base
  self.table_name = 'author_books'
  has_many :books
end

class Author < TinyORM::Base
  self.table_name = 'authors'
  has_one :profile
  has_many :books, through: :author_books
end

class Profile
  self.table_name = 'profiles'
  belongs_to :author
  has_many :photos
end

class Book
  self.table_name = 'books'
  has_many :author_books
  has_many :authors, through: :author_books
end

describe TinyORM::Query::Join do

  let(:join) { described_class.new(TinyORM::Query::Container.new(Author)) }

  it { expect(join.set('LEFT JOIN orders ON authors.id = orders.author_id').compile!).to eq('LEFT JOIN orders ON authors.id = orders.author_id') }
  it { expect(join.set(:inner, :profile).compile!).to eq('INNER JOIN profiles ON authors.id = profiles.author_id') }
  it { expect(join.set(:left, :profile).compile!).to eq('LEFT JOIN profiles ON authors.id = profiles.author_id') }
  it { expect(join.set(:books).compile!).to eq('INNER JOIN author_books ON authors.id = author_books.author_id INNER JOIN books ON author_books.book_id = books.id')}

  it { expect(join.set(profile: :photos).compile!).to eq('INNER JOIN profiles ON authors.id = profiles.author_id INNER JOIN photos ON profiles.id = photos.profile_id')}
end
