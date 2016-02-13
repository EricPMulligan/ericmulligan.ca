require 'rails_helper'

describe User do
  describe 'database table "users"' do
    describe 'columns' do
      it { should have_db_column(:id).                of_type(:integer) }
      it { should have_db_column(:created_at).        of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:updated_at).        of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:email).             of_type(:string).  with_options(null: false) }
      it { should have_db_column(:encrypted_password).of_type(:string).  with_options(limit: 128, null: false) }
      it { should have_db_column(:confirmation_token).of_type(:string).  with_options(limit: 128) }
      it { should have_db_column(:remember_token).    of_type(:string).  with_options(limit: 128, null: false) }
    end

    describe 'indexes' do
      it { should have_db_index(:email) }
      it { should have_db_index(:remember_token) }
    end
  end

  describe '"User" model' do
    describe 'creating an instance' do
      describe 'attributes' do
        it { should respond_to :id }
        it { should respond_to :created_at }
        it { should respond_to :updated_at }
        it { should respond_to :email }
        it { should respond_to :encrypted_password }
        it { should respond_to :password }
        it { should respond_to :confirmation_token }
        it { should respond_to :remember_token }
      end

      describe 'validity' do
        subject { create(:user) }

        it { should be_valid }
      end

      describe 'validation' do
        subject { create(:user) }

        it { should validate_presence_of :email }

        it { should validate_uniqueness_of(:email).case_insensitive }

        it { should validate_length_of(:confirmation_token).is_at_most(128) }
        it { should validate_length_of(:remember_token).is_at_most(128) }
      end
    end
  end
end
