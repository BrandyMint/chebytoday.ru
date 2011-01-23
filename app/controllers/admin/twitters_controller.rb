class Admin::TwittersController < Admin::ResourcesController
  #before_filter :get_object, :only => [:go_to_twitter]

  def go_to_twitter
    get_object
    redirect_to "http://twitter.com/#{@item.screen_name}"
  end

  def to_cheboksary
    get_object
    @item.to_cheboksary
    redirect_to  :back
  end

  def to_foreign
    get_object
    @item.to_cheboksary
    redirect_to :back
  end

end
