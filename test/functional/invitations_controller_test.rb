# require 'test_helper'
# 
# class InvitationsControllerTest < ActionController::TestCase
#   
#   def setup
#     # @invitation = Factory(:invitation)
#     # sign_in_as @invitation.sender
#   end
#   
#   context "index action" do
#     should "render index template" do
#       get :index
#       assert_template 'index'
#     end
#   end
#   
#   context "show action" do
#     should "render show template" do
#       get :show, :id => Invitation.first
#       assert_template 'show'
#     end
#   end
#   
#   context "new action" do
#     should "render new template" do
#       get :new
#       assert_template 'new'
#     end
#   end
#   
#   context "create action" do
#     should "render new template when model is invalid" do
#       Invitation.any_instance.stubs(:valid?).returns(false)
#       post :create
#       assert_template 'new'
#     end
#     
#     should "redirect when model is valid" do
#       Invitation.any_instance.stubs(:valid?).returns(true)
#       post :create
#       assert_redirected_to invitation_url(assigns(:invitation))
#     end
#   end
#   
#   context "edit action" do
#     should "render edit template" do
#       get :edit, :id => Invitation.first
#       assert_template 'edit'
#     end
#   end
#   
#   context "update action" do
#     should "render edit template when model is invalid" do
#       Invitation.any_instance.stubs(:valid?).returns(false)
#       put :update, :id => Invitation.first
#       assert_template 'edit'
#     end
#   
#     should "redirect when model is valid" do
#       Invitation.any_instance.stubs(:valid?).returns(true)
#       put :update, :id => Invitation.first
#       assert_redirected_to invitation_url(assigns(:invitation))
#     end
#   end
#   
#   context "destroy action" do
#     should "destroy model and redirect to index action" do
#       invitation = Invitation.first
#       delete :destroy, :id => invitation
#       assert_redirected_to invitations_url
#       assert !Invitation.exists?(invitation.id)
#     end
#   end
# end
