require 'spec_helper'

describe CommentsController do
  let(:user) { User.make!(:confirmed) }
  let(:group) { Group.make!(:owner => user) }
  let(:prayer) { Prayer.make!(:groups => [group]) }
  let(:comment) { Comment.make!(:prayer => prayer, :user => user) }
  
  before(:each) do
    sign_in_as user
  end
  
  describe "on GET to :index" do
    before(:each) do
      get :index, :prayer_id => prayer
    end
    it { should respond_with(:redirect) }
    it { should redirect_to(prayer_path(prayer, :anchor => 'comments')) }
  end
  
  describe "on GET to :new" do
    before(:each) do
      get :new, :prayer_id => prayer
    end
    it { should respond_with(:redirect) }
    it { should redirect_to(prayer_path(prayer, :anchor => 'new_comment')) }
  end
  
  describe "on POST to :create" do
    context "when invalid" do
      before(:each) do
        comment.stub!(:valid?).and_return(false)
        stub_nested_comment!(prayer, comment, :new)
        post :create, :prayer_id => prayer
      end
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    context "when valid" do
      before(:each) do
        comment.stub!(:valid?).and_return(true)
        stub_nested_comment!(prayer, comment, :new)
        post :create, :prayer_id => prayer
      end
      it { should redirect_to(prayer_path(prayer)) }
      it { should set_the_flash.to(/Successfully created comment/) }
    end
    
    it "fires a comment created notification" do
      Notification.should_receive(:fire).with(:created, instance_of(Comment))
      post :create, :prayer_id => prayer.id
    end
    
    it "doesn't create a comment for prayers I don't have access to" do
      comment.stub!(:valid?).and_return(true)
      comment.should_not_receive(:create)
      stub_nested_comment!(prayer, comment, :new)
      post :create, :prayer_id => Prayer.make!
    end
  end
  
  describe "on GET to :edit" do
    context "with a comment you own" do
      before(:each) do
        get :edit, :prayer_id => prayer, :id => comment
      end
      it { should assign_to(:comment) }
      it { should assign_to(:prayer).with(prayer) }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
      it { should_not set_the_flash }
    end
    
    context "with a comment you don't own" do
      before(:each) do
        sign_in
        get :edit, :prayer_id => prayer, :id => comment
      end
      it { should respond_with(:success) }
      it { should render_template(:no_access) }
    end
  end
  
  describe "on PUT to :update" do
    context "when invalid" do
      before(:each) do
        comment.stub!(:valid?).and_return(false)
        stub_nested_comment!(prayer, comment)
        put :update, :prayer_id => prayer, :id => comment
      end
      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end
    
    context "when valid" do
      before(:each) do
        comment.stub!(:valid?).and_return(true)
        stub_nested_comment!(prayer, comment)
        put :update, :prayer_id => prayer, :id => comment
      end
      it { should redirect_to(prayer_path(prayer)) }
    end
  end
  
  describe "on DELETE to :destroy" do
    context "with a comment you own" do
      before(:each) do
        delete :destroy, :prayer_id => prayer, :id => comment
      end
      it { should assign_to(:comment) }
      it { should assign_to(:prayer).with(prayer) }
      it { should respond_with(:redirect) }
      it { should redirect_to(prayer_path(prayer)) }
      it { should set_the_flash.to(/Success/) }
    end
    
    context "with a comment you don't own" do
      before(:each) do
        sign_in_as User.make!(:confirmed)
        delete :destroy, :prayer_id => prayer, :id => comment
      end
      it { should respond_with(:success) }
      it { should render_template(:no_access) }
    end
  end
  
  def stub_nested_comment!(prayer, comment = nil, association_method = :find)
    association = double('association')
    Prayer.stub!(:find).and_return(prayer)
    prayer.stub!(:comments).and_return(association)
    association.stub!(association_method).and_return(comment || Comment.make)
  end
  
end