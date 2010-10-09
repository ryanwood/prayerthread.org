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
    it { should assign_to(:comments) }
    it { should assign_to(:prayer).with(prayer) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should_not set_the_flash }
  end
  
  describe "on GET to :new" do
    before(:each) do
      get :new, :prayer_id => prayer
    end
    it { should assign_to(:comment) }
    it { should assign_to(:prayer).with(prayer) }
    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should_not set_the_flash }
  end
  
  describe "on POST to :create" do
    # context "for a prayer I can access" do
    #   setup do
    #     Notification.stubs!(:process)
    #     # Prayer.any_instance.stubs(:groups).returns([@group])
    #     # User.any_instance.stubs(:groups).returns([@group])
    #   end
    # 
    #   context "when invalid" do
    #     # Comment.any_instance.stubs(:valid?).returns(false)
    #     before(:each) do
    #       post :create, :prayer_id => prayer
    #     end
    #     it { should render_template(:new) }
    #   end
    # 
    
    
    
    
    
    #   context "when the model is valid" do
    #     setup do
    #       Comment.any_instance.stubs(:valid?).returns(true)
    #       post :create, :prayer_id => @prayer.id
    #     end
    #     should "redirect to the prayer" do
    #       assert_redirected_to prayer_url(assigns(:prayer))
    #     end
    #     should "set the comment user" do
    #       assert_equal @user, assigns(:comment).user
    #     end
    #   end
    #   
    #   should "fired a comment created notification" do
    #     Notification.expects(:fire).with(:created, instance_of(Comment))
    #     post :create, :prayer_id => @prayer.id
    #   end
    # end
    # 
    # context "for a prayer I don't have access to" do
    #   should "not create a comment" do
    #     Comment.any_instance.stubs(:valid?).returns(true)
    #     Comment.any_instance.expects(:create).never
    #     post :create, :prayer_id => Factory(:prayer).id
    #   end
    # end
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
        load_comment(comment, :from => prayer)
        put :update, :prayer_id => prayer, :id => comment
      end
      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end
    
    context "when valid" do
      before(:each) do
        comment.stub!(:valid?).and_return(true)
        load_comment(comment, :from => prayer)
        put :update, :prayer_id => prayer, :id => comment
      end
      it { should redirect_to(prayer_url(prayer)) }
    end
  end
  
  def load_comment(comment, opts = {})
    association = double('association')
    Prayer.stub!(:find).and_return(opts[:from] || double('prayer'))
    prayer.stub!(:comments).and_return(association)
    association.stub!(:find).and_return(comment)
  end
  
end