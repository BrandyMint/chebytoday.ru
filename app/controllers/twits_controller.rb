class TwitsController < ApplicationController
  def index
    @twits=Twit.ordered.paginate :page=>(params[:page] || 3)
    # @twits = Twit.all
  end
  
  def show
    @twit = Twit.find(params[:id])
  end
  
  def new
    @twit = Twit.new
  end
  
  def create
    @twit = Twit.new(params[:twit])
    if @twit.save
      flash[:notice] = "Successfully created twit."
      redirect_to @twit
    else
      render :action => 'new'
    end
  end
  
  def edit
    @twit = Twit.find(params[:id])
  end
  
  def update
    @twit = Twit.find(params[:id])
    if @twit.update_attributes(params[:twit])
      flash[:notice] = "Successfully updated twit."
      redirect_to @twit
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @twit = Twit.find(params[:id])
    @twit.destroy
    flash[:notice] = "Successfully destroyed twit."
    redirect_to twits_url
  end
end
