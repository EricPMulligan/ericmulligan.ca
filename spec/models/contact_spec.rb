require 'rails_helper'

describe Contact do
  describe 'database table "contacts"' do
    describe 'columns' do
      it { is_expected.to have_db_column(:id).        of_type(:integer) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:read_by_id).of_type(:integer) }
      it { is_expected.to have_db_column(:read_at).   of_type(:datetime) }
      it { is_expected.to have_db_column(:name).      of_type(:string).  with_options(default: '') }
      it { is_expected.to have_db_column(:email).     of_type(:string).  with_options(null: false) }
      it { is_expected.to have_db_column(:body).      of_type(:text).    with_options(null: false) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:email) }
      it { is_expected.to have_db_index(:read_by_id) }
      it { is_expected.to have_db_index(:read_at) }
      it { is_expected.to have_db_index(:created_at) }
    end
  end

  describe '"Contact" model' do
    describe 'creating an instance' do
      describe 'attributes' do
        it { is_expected.to respond_to :id }
        it { is_expected.to respond_to :created_at }
        it { is_expected.to respond_to :updated_at }
        it { is_expected.to respond_to :name }
        it { is_expected.to respond_to :email }
        it { is_expected.to respond_to :body }
        it { is_expected.to respond_to :read_at }
        it { is_expected.to respond_to :read_by_id }
        it { is_expected.to respond_to :read_by }
      end

      describe 'validations' do

      end

      describe 'associations' do
        it { is_expected.to belong_to(:read_by).class_name('User') }
      end

      describe 'validity' do
        it { is_expected.to validate_presence_of(:email) }
        it { is_expected.to validate_presence_of(:body) }
      end

      describe 'scopes' do
        describe '#unread' do
          it 'is_expected.to return only unread messages' do
            create(:read_contact, read_by: create(:user))
            contact = create(:contact)
            unread = Contact.unread
            expect(unread).to include(contact)
          end
        end
      end
    end
  end
end
