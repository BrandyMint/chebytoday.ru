class Politic < ActiveRecord::Base
  attr_accessible :name, :title, :desc
end

# == Schema Information
#
# Table name: politics
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  title      :string(255)
#  desc       :text
#  created_at :datetime
#  updated_at :datetime
#

