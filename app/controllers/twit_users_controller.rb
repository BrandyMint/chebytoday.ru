# -*- coding: utf-8 -*-
class TwitUsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def index
    @twit_users = TwitUser.cheboksary_and_blocked.order(sort_column + " " + sort_direction)
    @twit_user = TwitUser.new
  end
  
  def show
    @twit_user = TwitUser.find(params[:id])
  end
  
  def new
    @twit_user = TwitUser.new  
  end
  
  def create
    @twit_user = TwitUser.new(params[:twit_user])
    if @twit_user.save
      flash[:notice] = "Пользователь добавлен."
      # render :template => 'twit_users/added'
    #else
      # render :action => 'new'
    end
    render :action => 'new'
  end
  
  def edit
    @twit_user = TwitUser.find(params[:id])
  end
  
  def update
    @twit_user = TwitUser.find(params[:id])
    if @twit_user.update_attributes(params[:twit_user])
      flash[:notice] = "Successfully updated twit user."
      redirect_to @twit_user
    else
      render :action => 'edit'
    end
  end
  
  # def destroy
  #   @twit_user = TwitUser.find(params[:id])
  #   @twit_user.destroy
  #   flash[:notice] = "Successfully destroyed twit user."
  #   redirect_to twit_users_url
  # end


    
  private

  def sort_column
    TwitUser.column_names.include?(params[:sort]) ? params[:sort] : "followers_count"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
