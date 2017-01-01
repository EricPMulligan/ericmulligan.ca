require 'rails_helper'

describe User do
  describe 'database table "users"' do
    describe 'columns' do
      it { is_expected.to have_db_column(:id).                of_type(:integer) }
      it { is_expected.to have_db_column(:created_at).        of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).        of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:email).             of_type(:string).  with_options(null: false) }
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string).  with_options(limit: 128, null: false) }
      it { is_expected.to have_db_column(:confirmation_token).of_type(:string).  with_options(limit: 128) }
      it { is_expected.to have_db_column(:remember_token).    of_type(:string).  with_options(limit: 128, null: false) }
      it { is_expected.to have_db_column(:name).              of_type(:string).  with_options(null: false, default: '') }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:email) }
      it { is_expected.to have_db_index(:remember_token) }
    end
  end

  describe '"User" model' do
    describe 'creating an instance' do
      describe 'attributes' do
        it { is_expected.to respond_to :id }
        it { is_expected.to respond_to :created_at }
        it { is_expected.to respond_to :updated_at }
        it { is_expected.to respond_to :email }
        it { is_expected.to respond_to :encrypted_password }
        it { is_expected.to respond_to :password }
        it { is_expected.to respond_to :confirmation_token }
        it { is_expected.to respond_to :remember_token }
        it { is_expected.to respond_to :name }
      end

      describe 'validity' do
        subject { create(:user) }

        it { is_expected.to be_valid }
      end

      describe 'validation' do
        subject { create(:user) }

        it { is_expected.to validate_presence_of :email }

        it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

        it { is_expected.to validate_length_of(:confirmation_token).is_at_most(128) }
        it { is_expected.to validate_length_of(:remember_token).is_at_most(128) }
      end
    end
  end
end
