require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase

  context "when authenticated" do
    setup do
      @invitation = Factory(:invitation)
      @group = @invitation.group
      @user = @invitation.sender
      sign_in_as @user
    end

    context "on GET to :new" do
      setup do
        get :new, :group_id => @group.id
      end
      should_respond_with :success
    end

    context "on POST to :create" do
      context "when model is invalid" do
        setup do
          Invitation.any_instance.stubs(:valid?).returns(false)
          post :create, :group_id => @group.id
        end
        should_render_template :new
      end

      context "when model is valid" do
        setup do
          Invitation.any_instance.stubs(:valid?).returns(true)
          post :create, :group_id => @group.id
        end
        should_change( "the number of invitations", :by => 1 ) { Invitation.count }
        should_redirect_to( "the group" ) { group_path(@group) }
        should "set the group" do
          assert_equal @group, assigns(:invitation).group
        end        
        should "set the sender" do
          assert_equal @user, assigns(:invitation).sender
        end
      end
    end

    context "on DELETE to :destroy" do
      setup { delete :destroy, :group_id => @group.id, :id => @invitation }
      should_change( "the number of invitations", :by => -1 ) { Invitation.count }
      should_redirect_to( "the invitation list" ) { group_url(@group) }
    end 
  end
  
  context "on GET to :confirm" do
    setup do
      @recipient_email = 'john@doe.com'
      @invitation = Factory(:invitation, :recipient_email => @recipient_email)
    end
    
    context "when the recipient is unknown" do
      setup { get :confirm, :id => @invitation.id, :token => @invitation.token }
      should_not_set_the_flash
      should_redirect_to( "sign up" ) { sign_up_path( :token => @invitation.token ) }
    end
    
    context "when the recipient is known" do
      setup do 
        Factory(:user, :email => @recipient_email)
        get :confirm, :id => @invitation.id, :token => @invitation.token
      end
      should_redirect_to( "accept the invitation" ) { accept_invitation_path(@invitation, :token => @invitation.token) }
    end
  end
  
  context "on GET to :accept" do
    setup do
      @invitation = Factory(:invitation)
      sign_in_as Factory(:user, :email => 'john@doe.com' )
    end
    
    context "when invitation exists" do
      setup do
        get :accept, :id => @invitation.id, :token => @invitation.token
      end
      should_redirect_to( "the group" ) { group_path( @invitation.group ) }
    end
    
    context "when invitation does not exist" do
      setup do
        get :accept, :id => 0, :token => 123
      end
      should_redirect_to( "home" ) { root_path }
    end
  end
end
