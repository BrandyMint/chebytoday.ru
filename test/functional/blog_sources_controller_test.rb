require 'test_helper'

class BlogSourcesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BlogSource.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BlogSource.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BlogSource.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to blog_source_url(assigns(:blog_source))
  end
  
  def test_edit
    get :edit, :id => BlogSource.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BlogSource.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BlogSource.first
    assert_template 'edit'
  end

  def test_update_valid
    BlogSource.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BlogSource.first
    assert_redirected_to blog_source_url(assigns(:blog_source))
  end
  
  def test_destroy
    blog_source = BlogSource.first
    delete :destroy, :id => blog_source
    assert_redirected_to blog_sources_url
    assert !BlogSource.exists?(blog_source.id)
  end
end
