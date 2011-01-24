# -*- coding: utf-8 -*-
class TwittersController < ApplicationController

  helper_method :sort_column, :sort_direction
  
  def index
    @twitters = Twitter.cheboksary.order(sort_column + " " + sort_direction)
    @twitter = Twitter.new
    @newbies = Twitter.newbies
  end
  
  # def show
  #   @twitter = Twitter.find(params[:id])
  # end
  
  def new
    @twitter = Twitter.new  
  end
  
  def create
    @twitter = Twitter.new(params[:twitter])
    if @twitter.save
      flash[:notice] = "Пользователь добавлен."
      # render :template => 'twitters/added'
    #else
      # render :action => 'new'
    end
    render :action => 'new'
  end
  
  # def edit
  #   @twitter = Twitter.find(params[:id])
  # end
  
  # def update
  #   @twitter = Twitter.find(params[:id])
  #   if @twitter.update_attributes(params[:twitter])
  #     flash[:notice] = "Successfully updated twit user."
  #     redirect_to @twitter
  #   else
  #     render :action => 'edit'
  #   end
  # end
  
  # def destroy
  #   @twitter = Twitter.find(params[:id])
  #   @twitter.destroy
  #   flash[:notice] = "Successfully destroyed twit user."
  #   redirect_to twitters_url
  # end


    
  private

  def sort_column
    Twitter.column_names.include?(params[:sort]) ? params[:sort] : "followers_count"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
