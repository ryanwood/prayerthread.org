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
  end
  
  context "on DELETE to :destroy" do
    setup do
       @invitation = Factory(:invitation)
       sign_in_as Factory(:user)
    end
    
    should "redirect to the invitation list" do
      delete :destroy, :id => @invitation
      assert_redirected_to invitations_url
    end
    
    context "when authenticated as the group owner" do
      setup do       
        sign_in_as @invitation.group.owner
      end
      should "cancel the invitation" do
        Invitation.any_instance.expects(:destroy)
        delete :destroy, :id => @invitation
      end
    end
    
    context "when not authenticated as the group owner or recipient" do
      should "not cancel the invitation" do
        Invitation.any_instance.expects(:destroy).never
        delete :destroy, :id => @invitation
      end
    end
  end
  
  context "on GET to :confirm" do
    setup do
      @recipient_email = 'john@doe.com'
      @invitation = Factory(:invitation, :recipient_email => @recipient_email)
    end
    
    context "when no valid invitation is found" do
      setup { get :confirm, :id => @invitation.id, :token => 'BADTOKEN' }
      should "redirect to the root path" do
        assert_not_nil flash[:error]
        assert_redirected_to root_url
      end
    end
    
    context "when the recipient is unknown" do
      setup { get :confirm, :id => @invitation.id, :token => @invitation.token }
      should_not_assign_to :user
      should_not_set_the_flash
      should_redirect_to( "sign up with a token" ) { sign_up_path( :token => @invitation.token ) }
    end
    
    context "when a user is logged in" do
      setup do
        @user = Factory(:email_confirmed_user, :email => @recipient_email)
        assert_nil @invitation.recipient_id
        sign_in_as @user
        get :confirm, :id => @invitation.id, :token => @invitation.token
      end
      should_assign_to :invitation, :user
      should 'assign the user as the invitation recipient' do
        assert_equal assigns(:user).id, assigns(:invitation).recipient_id
      end
      should_not_set_the_flash
      should_redirect_to( "the invitation list" ) { invitations_path }
    end
    
    context "when the recipient_email is matched but not logged in" do
      setup do
        @user = Factory(:email_confirmed_user, :email => @recipient_email)
        assert_nil @invitation.recipient_id
        get :confirm, :id => @invitation.id, :token => @invitation.token
      end
      should_assign_to :invitation, :user
      should 'assign the user as the invitation recipient' do
        assert_equal assigns(:user).id, assigns(:invitation).recipient_id
      end
      should_set_the_flash_to "Please sign in to accept your invitation."
      should_redirect_to( "the invitation list" ) { invitations_path }
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
  
  context "on PUT to :ignore" do
    setup do
      @user = Factory(:user)
      @other_user = Factory(:user)
      @invitation = Factory(:invitation, :recipient => @user)
      sign_in_as @user
    end
    context "if owned by the user" do
      should "ignore the invitation" do
        assert_equal false, @invitation.ignored?
        put :ignore, :id => @invitation
        assert_equal true, assigns(:invitation).ignored?
      end
    end
    context "if NOT owned by the user" do
      setup do
        Invitation.any_instance.stubs(:valid?).returns(true)
        @invitation = Factory(:invitation, :recipient => @other_user )
      end
      should "not change the invitation" do
        Invitation.any_instance.expects(:update_attributes).never
        put :ignore, :id => @invitation
      end
      should "set the error flash" do
        put :ignore, :id => @invitation
        assert_nil assigns(:invitation)
        assert_not_nil flash[:error]
      end
    end
    should "redirect to the invitations list" do
      put :ignore, :id => @invitation
      assert_redirected_to invitations_url
    end
  end
end
