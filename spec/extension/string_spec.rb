require_relative '../spec_helper'

describe String do
  describe 'underscore' do
    it { expect('author_books'.underscore).to eq('author_books')}
    it { expect('AuthorBooks'.underscore).to eq('author_books')}
    it { expect('Authorbooks'.underscore).to eq('authorbooks')}
    it { expect('Author Books'.underscore).to eq('Author Books')}
  end

  describe 'camelize' do
    it { expect('author_books'.camelize).to eq('AuthorBooks')}
    it { expect("AuthorBooks".camelize).to eq("Authorbooks")}
    it { expect('Authorbooks'.camelize).to eq('Authorbooks')}
    it { expect('Author Books'.camelize).to eq('Author books')}
  end
end
