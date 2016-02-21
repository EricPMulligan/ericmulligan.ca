require 'rails_helper'

describe Contact do
  describe 'database table "contacts"' do
    describe 'columns' do
      it { should have_db_column(:id).        of_type(:integer) }
      it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:read_by_id).of_type(:integer) }
      it { should have_db_column(:read_at).   of_type(:datetime) }
      it { should have_db_column(:name).      of_type(:string).  with_options(default: '') }
      it { should have_db_column(:email).     of_type(:string).  with_options(null: false) }
      it { should have_db_column(:body).      of_type(:text).    with_options(null: false) }
    end

    describe 'indexes' do
      it { should have_db_index(:email) }
      it { should have_db_index(:read_by_id) }
      it { should have_db_index(:read_at) }
      it { should have_db_index(:created_at) }
    end
  end

  describe '"Contact" model' do
    describe 'creating an instance' do
      describe 'attributes' do
        it { should respond_to :id }
        it { should respond_to :created_at }
        it { should respond_to :updated_at }
        it { should respond_to :name }
        it { should respond_to :email }
        it { should respond_to :body }
        it { should respond_to :read_at }
        it { should respond_to :read_by_id }
        it { should respond_to :read_by }
      end

      describe 'validations' do

      end

      describe 'associations' do
        it { should belong_to(:read_by).class_name('User') }
      end

      describe 'validity' do
        it { should validate_presence_of(:email) }
        it { should validate_presence_of(:body) }
      end

      describe 'scopes' do
        describe '#unread' do
          it 'should return only unread messages' do
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
