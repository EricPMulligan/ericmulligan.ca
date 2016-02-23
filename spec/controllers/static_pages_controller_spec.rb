require 'rails_helper'

describe StaticPagesController do
  describe 'GET #about' do
    before(:each) { get :about }

    it { should respond_with :ok }
    it { should render_template :about }
    it { should render_with_layout :application }
  end
end