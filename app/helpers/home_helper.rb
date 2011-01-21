module HomeHelper
  def twit_filter(text)
    text=auto_link(text)
    text.gsub(/\#(\w+)/) do
      q = URI.escape($1)
      "<a href=\"http://twitter.com/#search?q=%23#{q}\" class=\"hashtag\">##{$1}</a>"
    end
  end
end
