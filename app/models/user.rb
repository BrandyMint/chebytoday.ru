# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :nick, :email, :password, :password_confirmation, :remember_me

  validates_uniqueness_of :nick
  
  has_many :blogs
  has_many :articles, :through=>:blog
  
end
