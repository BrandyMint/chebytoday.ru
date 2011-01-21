# -*- coding: utf-8 -*-
class Article < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 10
  
  attr_accessible :title, :author, :guid, :blog, :link, :published_at, :summary

  belongs_to :blog, :counter_cache=>true

  scope :main, order('published_at desc')
  scope :feed, where("created_at>=?",Date.today()-1)
  scope :today, where("created_at>=?",Date.today())

  default_scope order('published_at desc')

  def truncated
    html_string = TruncateHtml::HtmlString.new summary
    TruncateHtml::HtmlTruncator.new(html_string).truncate(:length=>1000, :images=>1, :omission => "<p><a href=\"#{link}\">далее&hellip;</a></p>").html_safe
  end

end
