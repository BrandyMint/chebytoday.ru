require 'carrierwave/orm/activerecord'

class Purchase < ActiveRecord::Base
  belongs_to :user

  mount_uploader :image, ImageUploader


  STATE = %w( open closed )
  state_machine :initial => :open do
    state :open, :closed
  end

  KIND = %w( rebate group )
  state_machine :initial => :rebate do
    state :rebate, :group
  end


  def rebate_in_percents
    rebate*100/(price + rebate)
  end

end
