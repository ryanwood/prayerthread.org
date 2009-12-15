require 'test_helper'

class PrayersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Prayer.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Prayer.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Prayer.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to prayer_url(assigns(:prayer))
  end
  
  def test_edit
    get :edit, :id => Prayer.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Prayer.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Prayer.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Prayer.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Prayer.first
    assert_redirected_to prayer_url(assigns(:prayer))
  end
  
  def test_destroy
    prayer = Prayer.first
    delete :destroy, :id => prayer
    assert_redirected_to prayers_url
    assert !Prayer.exists?(prayer.id)
  end
end
