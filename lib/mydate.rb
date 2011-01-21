class Date
  def begin_of_day
    DateTime.new(self.year,self.month,self.mday)
  end

  def end_of_day
    DateTime.new(self.year,self.month,self.mday,23,59,59)
  end

  def begin_of_month
    DateTime.new(self.year,self.month,1)
  end

  def end_of_month
    year,month = self.month == 12 ? [self.year + 1, 1] : [self.year, self.month + 1]

    DateTime.new(year,month,1,23,59,59) - 1
  end

  def begin_of_year
    DateTime.new(self.year,1,1)
  end

  def end_of_year
    DateTime.new(self.year,12,31,23,59,59)
  end

  def humanize
    current = Date.today
    case
    when self.year != current.year
      strftime("%Y-%m-%d")
    when self.yday == (current.yday + 1)
      "Tomorrow"
    when self.yday == current.yday
      "Today"
    when self.yday == (current.yday - 1)
      "Yesterday"
    else
      strftime("%d %b")
    end
  end

  def to_words
    if self == Date.today
      "Today"
    elsif self <= Date.today - 1
      if self == Date.today - 1
        "Yesterday"
      elsif ((Date.today - 7)..(Date.today - 1)).include?(self)
        "Last #{self.strftime("%A")}"
      elsif ((Date.today - 14)..(Date.today - 8)).include?(self)
        "Two #{self.strftime("%A")}s ago"
      elsif ((Date.today - 21)..(Date.today - 15)).include?(self)
        "Three #{self.strftime("%A")}s ago"
      elsif ((Date.today - 29)..(Date.today - 22)).include?(self)
        "Four #{self.strftime("%A")}s ago"
      elsif Date.today - 30 < self
        "More than a month ago"
      end
    else
      if self == Date.today + 1
        "Tomorrow"
      elsif ((Date.today + 1)..(Date.today + 6)).include?(self)
        "This coming #{self.strftime("%A")}"
      elsif ((Date.today + 7)..(Date.today + 14)).include?(self)
        "Next #{self.strftime("%A")}s away"
      elsif ((Date.today + 15)..(Date.today + 21)).include?(self)
        "Two #{self.strftime("%A")}s away"
      elsif ((Date.today + 22)..(Date.today + 29)).include?(self)
        "Three #{self.strftime("%A")}s away"
      elsif Date.today + 30 > self
        "More than a month in the future"
      end
    end
  end
  
end

class DateTime
  def humanize
    current = Date.today
    case
    when self.year != current.year
      super
    when self.yday == current.yday
      strftime("%I:%M %p")
    else
      super + " at " + strftime("%I:%M %p")
    end
  end
end

class Time
  def to_datetime
    DateTime.new(self.year,self.month,self.mday,self.hour,self.min,self.sec)
  end

  def humanize
    self.to_datetime.humanize
  end
end
