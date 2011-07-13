xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", "xmlns:lj"=>'http://www.livejournal.org/rss/lj/1.0/' do
  xml.channel do
    xml.title "Чебоксары сегодня"
    xml.description "Общая лента блогеров Чувашии"
    xml.link root_url

    for article in @articles
      xml.item do
        xml.title article.title
        xml.description article.truncated
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.link article.link
        xml.guid article.guid
      end
    end
  end
end
