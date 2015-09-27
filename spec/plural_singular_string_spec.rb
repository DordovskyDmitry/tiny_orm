require_relative 'spec_helper'

String.send(:include, TinyORM::PluralSingularString) # Unfortunately using refinements broke using transform_using

describe TinyORM::PluralSingularString do

  describe 'pluralize' do
    context 'from general singular forms' do
      it { expect('user'.pluralize).to eq('users') }

      it { expect('bus'.pluralize).to eq('buses') }
      it { expect('wish'.pluralize).to eq('wishes') }
      it { expect('box'.pluralize).to eq('boxes') }

      it { expect('city'.pluralize).to eq('cities') }
      it { expect('baby'.pluralize).to eq('babies') }
      it { expect('spy'.pluralize).to eq('spies') }
    end

    context 'irregular' do
      it { expect('child'.pluralize).to eq('children') }
      it { expect('person'.pluralize).to eq('people') }
      it { expect('self'.pluralize).to eq('selves') }
      it { expect('analysis'.pluralize).to eq('analyses') }
    end

    context 'uncountable' do
      it { expect('series'.pluralize).to eq('series') }
    end

    context 'already pluralized irregular' do
      it { expect('children'.pluralize).to eq('children') }
      it { expect('people'.pluralize).to eq('people') }
      it { expect('selves'.pluralize).to eq('selves') }
    end
  end

  describe 'singularize' do
    context 'from general plural forms' do
      it { expect('users'.singularize).to eq('user') }

      it { expect('buses'.singularize).to eq('bus') }
      it { expect('wishes'.singularize).to eq('wish') }
      it { expect('boxes'.singularize).to eq('box') }

      it { expect('cities'.singularize).to eq('city') }
      it { expect('babies'.singularize).to eq('baby') }
      it { expect('spies'.singularize).to eq('spy') }
    end

    context 'irregular' do
      it { expect('children'.singularize).to eq('child') }
      it { expect('people'.singularize).to eq('person') }
      it { expect('selves'.singularize).to eq('self') }
      it { expect('analyses'.singularize).to eq('analysis') }
    end

    context 'uncountable' do
      it { expect('series'.singularize).to eq('series') }
    end

    context 'already singularized' do
      it { expect('child'.singularize).to eq('child') }
      it { expect('person'.singularize).to eq('person') }
      it { expect('self'.singularize).to eq('self') }

      it { expect('user'.singularize).to eq('user') }
      it { expect('box'.singularize).to eq('box') }
      it { expect('city'.singularize).to eq('city') }
    end
  end
end
