# -*- coding: utf-8 -*-
module ApplicationHelper

  def user(blog)
    blog=blog.blog if blog.is_a? Article
    content_tag :span, :class=>'user' do
      link_to blog.author, blog.link
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def navigation_link(label, active, chosen, url, title=nil)
    stateful_link_to(
      active,
      chosen,
      :active => proc { content_tag :li, :class=>'active' do
          concat content_tag :span, label
        end },
      :chosen => proc { content_tag :li, :class=>'chosen' do
          link_to( label, url, :title=>title )
        end },
      :inactive => proc { content_tag :li do
          link_to( label, url, :title=>title )
        end }
      )

  end

  def today_articles
    Article.today.count.to_s + '&nbsp' + Russian.p( Article.today.count, "пост", "поста", "постов" )
  end

  def submenu(*args)
    @submenu||=[]
    @submenu+=[args]
  end


end
