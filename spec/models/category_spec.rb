require 'rails_helper'

describe Category do
  describe 'database table "categories"' do
    describe 'columns' do
      it { should have_db_column(:id).           of_type(:integer) }
      it { should have_db_column(:created_at).   of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:updated_at).   of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:created_by_id).of_type(:integer). with_options(null: false) }
      it { should have_db_column(:name).         of_type(:string).  with_options(null: false) }
      it { should have_db_column(:description).  of_type(:text).    with_options(null: false, default: '') }
      it { should have_db_column(:slug).         of_type(:string).  with_options(null: false) }
    end

    describe 'indexes' do
      it { should have_db_index(:created_by_id) }
      it { should have_db_index(:name) }
      it { should have_db_index(:slug).unique }
    end
  end

  describe '"Category" model' do
    describe 'create an instance' do
      describe 'attributes' do
        it { should respond_to(:id) }
        it { should respond_to(:created_at) }
        it { should respond_to(:updated_at) }
        it { should respond_to(:created_by_id) }
        it { should respond_to(:created_by) }
        it { should respond_to(:name) }
        it { should respond_to(:description) }
        it { should respond_to(:slug) }
      end

      describe 'associations' do
        it { should belong_to(:created_by).class_name('User') }

        it { should have_and_belong_to_many(:posts).class_name('Post') }
      end

      describe 'check validity' do
        subject { create(:category) }

        it { should be_valid }
      end

      describe 'validation' do
        subject { create(:category) }

        it { should validate_presence_of(:name) }
        it { should validate_presence_of(:created_by) }

        it { should validate_uniqueness_of(:slug).case_insensitive }
      end

      describe 'scopes' do

      end
    end
  end
end