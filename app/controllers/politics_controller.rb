class PoliticsController < ApplicationController
  def index
    @politics = Politic.all
  end
  
  def show
    @politic = Politic.find(params[:id])
  end
  
  def new
    @politic = Politic.new
  end
  
  def create
    @politic = Politic.new(params[:politic])
    if @politic.save
      flash[:notice] = "Successfully created politic."
      redirect_to @politic
    else
      render :action => 'new'
    end
  end
  
  def edit
    @politic = Politic.find(params[:id])
  end
  
  def update
    @politic = Politic.find(params[:id])
    if @politic.update_attributes(params[:politic])
      flash[:notice] = "Successfully updated politic."
      redirect_to @politic
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @politic = Politic.find(params[:id])
    @politic.destroy
    flash[:notice] = "Successfully destroyed politic."
    redirect_to politics_url
  end
end
