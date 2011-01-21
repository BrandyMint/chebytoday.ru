require 'test_helper'

class PoliticsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Politic.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Politic.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Politic.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to politic_url(assigns(:politic))
  end
  
  def test_edit
    get :edit, :id => Politic.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Politic.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Politic.first
    assert_template 'edit'
  end

  def test_update_valid
    Politic.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Politic.first
    assert_redirected_to politic_url(assigns(:politic))
  end
  
  def test_destroy
    politic = Politic.first
    delete :destroy, :id => politic
    assert_redirected_to politics_url
    assert !Politic.exists?(politic.id)
  end
end
