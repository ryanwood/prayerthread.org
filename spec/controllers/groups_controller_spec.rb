require 'spec_helper'

describe GroupsController do
  let(:user) { User.make!(:confirmed) }
  let(:group) { Group.make!(:owner => user) }
  
  before(:each) do
    sign_in_as user
  end
  
  describe "on GET to :index" do
    before(:each) do
      get :index
    end
    it { should assign_to(:groups) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
    it { should_not set_the_flash }
  end
  
  describe "on GET to :show" do
    before(:each) do
      get :show, :id => group
    end
    it { should assign_to(:group) }
    it { should respond_with(:success) }
    it { should render_template(:show) }
    it { should_not set_the_flash }
  end
  
  describe "on GET to :new" do
    before(:each) do
      get :new
    end
    it { should assign_to(:group) }
    it { should respond_with(:success) }
    it { should render_template(:new) }
    it { should_not set_the_flash }
  end
  
  describe "on POST to :create" do
    context "when valid" do
      before(:each) do
        group.stub!(:valid?).and_return(true)
        Group.should_receive(:new).and_return(group)
        post :create
      end
      it { should redirect_to(group_memberships_url(group)) }
      it { should set_the_flash.to(/Successfully created group/) }
    end
    
    context "when invalid" do
      before(:each) do
        group.stub!(:valid?).and_return(false)
        Group.should_receive(:new).and_return(group)
        post :create
      end
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end
  end
  
  describe "on GET to :edit" do
    context "with a group you own" do
      before(:each) do
        get :edit, :id => group
      end
      it { should assign_to(:group) }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
      it { should_not set_the_flash }
    end
    
    context "with a group you don't own" do
      before(:each) do
        sign_in
        get :edit, :id => group
      end
      it { should respond_with(:success) }
      it { should render_template(:no_access) }
    end
  end
  
  describe "on PUT to :update" do
    context "when valid" do
      before(:each) do
        group.stub!(:valid?).and_return(true)
        Group.should_receive(:find).and_return(group)
        put :update, :id => group
      end
      it { should redirect_to(group_url(group)) }
      it { should set_the_flash.to(/Successfully updated group/) }
    end
    
    context "when invalid" do
      before(:each) do
        group.stub!(:valid?).and_return(false)
        Group.should_receive(:find).and_return(group)
        put :update, :id => group
      end
      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end
  end
  
  describe "on DELETE to :destroy" do
    context "with a group you own" do
      before(:each) do
        delete :destroy, :id => group
      end
      it { should assign_to(:group) }
      it { should respond_with(:redirect) }
      it { should redirect_to(groups_url) }
      it { should set_the_flash.to(/Success/) }
    end
    
    context "with a group you don't own" do
      before(:each) do
        sign_in_as User.make!(:confirmed)
        delete :destroy, :id => group
      end
      it { should respond_with(:success) }
      it { should render_template(:no_access) }
    end
  end
end