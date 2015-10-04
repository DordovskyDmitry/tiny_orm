require_relative '../lib/tiny_orm'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  class Photo < TinyORM::Base
    self.table_name = 'photos' #TODO 'photo'.pluralize => 'photoes' instead of 'photos'
    belongs_to :profile
  end

  class AuthorBook < TinyORM::Base
    has_many :books
  end

  class Author < TinyORM::Base
    has_one :profile
    has_many :books, through: :author_books
  end

  class Profile < TinyORM::Base
    belongs_to :author
    has_many :photos
  end

  class Book < TinyORM::Base
    has_many :author_books
    has_many :authors, through: :author_books
  end

  class User < TinyORM::Base
    has_many :friends
  end

  class Friend < TinyORM::Base
    self.table_name = 'not_enemies'
    belongs_to :user
  end
end
