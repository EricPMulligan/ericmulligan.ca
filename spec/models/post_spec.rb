require 'rails_helper'

describe Post do
  describe 'database table "posts"' do
    describe 'columns' do
      it { should have_db_column(:id).             of_type(:integer) }
      it { should have_db_column(:created_at).     of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:updated_at).     of_type(:datetime).with_options(null: false) }
      it { should have_db_column(:title).          of_type(:string).  with_options(null: false) }
      it { should have_db_column(:body).           of_type(:text).    with_options(null: false, default: '') }
      it { should have_db_column(:published).      of_type(:boolean). with_options(null: false, default: false) }
      it { should have_db_column(:published_at).   of_type(:datetime) }
      it { should have_db_column(:created_by_id).  of_type(:integer). with_options(null: false) }
      it { should have_db_column(:slug).           of_type(:string).  with_options(null: false) }
      it { should have_db_column(:seo_title).      of_type(:string) }
      it { should have_db_column(:seo_description).of_type(:string) }
    end

    describe 'indexes' do
      it { should have_db_index(:title) }
      it { should have_db_index(:created_at) }
      it { should have_db_index(:published) }
      it { should have_db_index(:created_by_id) }
      it { should have_db_index(:slug).unique }
    end
  end

  describe '"Post" model' do
    describe 'creating an instance' do
      describe 'attributes' do
        it { should respond_to :id }
        it { should respond_to :created_at }
        it { should respond_to :updated_at }
        it { should respond_to :title }
        it { should respond_to :body }
        it { should respond_to :published }
        it { should respond_to :published_at }
        it { should respond_to :created_by_id }
        it { should respond_to :created_by }
        it { should respond_to :categories }
        it { should respond_to :slug }
        it { should respond_to(:seo_title) }
        it { should respond_to(:seo_description) }
      end

      describe 'associations' do
        it { should belong_to(:created_by).class_name('User') }

        it { should have_and_belong_to_many(:categories).class_name('Category') }
      end

      describe 'check validity' do
        subject { create(:post) }

        it { should be_valid }
      end

      describe 'validation' do
        before(:each) { create(:post) }

        it { should validate_presence_of :title }
        it { should validate_presence_of :created_by }
        it { should validate_presence_of :slug }

        it { should validate_uniqueness_of(:slug).case_insensitive }
      end

      describe 'scopes' do
        describe '#latest' do
          it 'should return the latest posts' do
            third  = create(:post, created_at: DateTime.new(2016, 5, 2))
            second = create(:post, created_at: DateTime.new(2016, 5, 1))
            first  = create(:post, created_at: DateTime.new(2016, 4, 24))

            latest = Post.latest
            expect(latest).to match([third, second, first])
          end
        end

        describe '#published' do
          it 'should return only the published posts' do
            first  = create(:post, published: true)
            second = create(:post, published: false)
            third  = create(:post, published: true)

            published_posts = Post.published
            expect(published_posts).to match([first, third])
          end
        end
      end
    end
  end
end
