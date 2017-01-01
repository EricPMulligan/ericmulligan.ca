require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'database table "posts"' do
    describe 'columns' do
      it { is_expected.to have_db_column(:id).             of_type(:integer) }
      it { is_expected.to have_db_column(:created_at).     of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).     of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:title).          of_type(:string).  with_options(null: false) }
      it { is_expected.to have_db_column(:body).           of_type(:text).    with_options(null: false, default: '') }
      it { is_expected.to have_db_column(:published).      of_type(:boolean). with_options(null: false, default: false) }
      it { is_expected.to have_db_column(:published_at).   of_type(:datetime) }
      it { is_expected.to have_db_column(:created_by_id).  of_type(:integer). with_options(null: false) }
      it { is_expected.to have_db_column(:slug).           of_type(:string).  with_options(null: false) }
      it { is_expected.to have_db_column(:seo_title).      of_type(:string) }
      it { is_expected.to have_db_column(:seo_description).of_type(:string) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:title) }
      it { is_expected.to have_db_index(:created_at) }
      it { is_expected.to have_db_index(:published) }
      it { is_expected.to have_db_index(:created_by_id) }
      it { is_expected.to have_db_index(:slug).unique }
    end
  end

  describe '"Post" model' do
    describe 'creating an instance' do
      describe 'attributes' do
        it { is_expected.to respond_to :id }
        it { is_expected.to respond_to :created_at }
        it { is_expected.to respond_to :updated_at }
        it { is_expected.to respond_to :title }
        it { is_expected.to respond_to :body }
        it { is_expected.to respond_to :published }
        it { is_expected.to respond_to :published_at }
        it { is_expected.to respond_to :created_by_id }
        it { is_expected.to respond_to :created_by }
        it { is_expected.to respond_to :categories }
        it { is_expected.to respond_to :slug }
        it { is_expected.to respond_to(:seo_title) }
        it { is_expected.to respond_to(:seo_description) }
      end

      describe 'associations' do
        it { is_expected.to belong_to(:created_by).class_name('User') }

        it { is_expected.to have_many(:categories_posts) }
        it { is_expected.to have_many(:categories).through(:categories_posts) }
      end

      describe 'check validity' do
        subject { create(:post) }

        it { is_expected.to be_valid }
      end

      describe 'validation' do
        before(:each) { create(:post) }

        it { is_expected.to validate_presence_of :title }
        it { is_expected.to validate_presence_of :created_by }
        it { is_expected.to validate_presence_of :slug }

        it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }
      end

      describe 'scopes' do
        describe '#latest' do
          it 'is_expected.to return the latest posts' do
            third  = create(:post, created_at: DateTime.new(2016, 5, 2))
            second = create(:post, created_at: DateTime.new(2016, 5, 1))
            first  = create(:post, created_at: DateTime.new(2016, 4, 24))

            latest = Post.latest
            expect(latest).to match([third, second, first])
          end
        end

        describe '#published' do
          it 'is_expected.to return only the published posts' do
            first  = create(:post, published: true, created_at: DateTime.new(2016, 5, 2))
            second = create(:post, published: false, created_at: DateTime.new(2016, 6, 2))
            third  = create(:post, published: true, created_at: DateTime.new(2016, 5, 1))

            published_posts = Post.published
            expect(published_posts).to match([first, third])
          end
        end
      end
    end
  end
end
