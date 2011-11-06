module Airbrake
  def self.wrapper(&block)
    block.call
  rescue Exception => e
    Airbrake.notify(e)
  end
end
