require 'rails_helper'

describe Category do
  describe 'database table "categories"' do
    describe 'columns' do
      it { is_expected.to have_db_column(:id).           of_type(:integer) }
      it { is_expected.to have_db_column(:created_at).   of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).   of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:created_by_id).of_type(:integer). with_options(null: false) }
      it { is_expected.to have_db_column(:name).         of_type(:string).  with_options(null: false) }
      it { is_expected.to have_db_column(:description).  of_type(:text).    with_options(null: false, default: '') }
      it { is_expected.to have_db_column(:slug).         of_type(:string).  with_options(null: false) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:created_by_id) }
      it { is_expected.to have_db_index(:name) }
      it { is_expected.to have_db_index(:slug) }
    end
  end

  describe '"Category" model' do
    describe 'create an instance' do
      describe 'attributes' do
        it { is_expected.to respond_to(:id) }
        it { is_expected.to respond_to(:created_at) }
        it { is_expected.to respond_to(:updated_at) }
        it { is_expected.to respond_to(:created_by_id) }
        it { is_expected.to respond_to(:created_by) }
        it { is_expected.to respond_to(:name) }
        it { is_expected.to respond_to(:description) }
        it { is_expected.to respond_to(:slug) }
      end

      describe 'associations' do
        it { is_expected.to belong_to(:created_by).class_name('User') }

        it { is_expected.to have_many(:categories_posts) }
        it { is_expected.to have_many(:posts).through(:categories_posts) }
      end

      describe 'check validity' do
        subject { create(:category) }

        it { is_expected.to be_valid }
      end

      describe 'validation' do
        subject { create(:category) }

        it { is_expected.to validate_presence_of(:name) }
        it { is_expected.to validate_presence_of(:created_by) }

        it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }
      end

      describe 'scopes' do

      end
    end
  end
end
