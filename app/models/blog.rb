# -*- coding: utf-8 -*-
require "open-uri"

class Blog < ActiveRecord::Base
  attr_accessible :title, :link, :author, :rss_link

  # name - название блога

  has_many :articles
  belongs_to :user

  scope :active, where('articles_updated_at is not null').order('articles_updated_at desc').limit(60)

  def self.update_blogs
    all.each do |b|
      b.update_blog
    end
  end

  def update_blog
    update_attribute(:link,"http://#{author}.livejournal.com/") 
    pp self.rss_link
    update_from_feed
    #update_yandex_rating
  end

  def update_from_feed
    feed = Feedzirra::Feed.fetch_and_parse rss_link
    return unless feed.kind_of? Feedzirra::Parser::RSS
    add_articles feed.entries
  end

  def update_yandex_rating
    doc = Hpricot(open("http://blogs.yandex.ru/top/?username=#{author}"))
    #block = doc.search("tr[@id='#{author}']")
    block = doc.search("tr[@class='found']")
    return  if block.empty?
    update_attribute(:yandex_rating, block.search("td[@class='first-column']").inner_html.to_i)
  end
  
  private
  
  def add_articles(entries)
    entries.each do |entry|
      if entry.published < (Date.today - 30)
        print '.'
        next
      end
      if  articles.exists? :guid => entry.id
        print '-'
      else
        print 'o'
        articles.create!(
                         :title        => entry.title || 'no subject',
                         :summary      => entry.summary || '...',
                         :link         => entry.url,
                         :published_at => entry.published,
                         :guid         => entry.id,
                         :author       => author
                         )
        update_attribute(:articles_updated_at, entry.published) if articles_updated_at.nil? || entry.published>articles_updated_at
      end
    end
    puts ""
  end

end
