require_relative '../spec_helper'

describe TinyORM::Association do
  it { expect(Photo.associations(:profile).class).to eq(TinyORM::Association::BelongsTo) }
  it { expect(AuthorBook.associations(:books).class).to eq(TinyORM::Association::HasMany) }
  it { expect(Author.associations(:profile).class).to eq(TinyORM::Association::HasOne) }
end
