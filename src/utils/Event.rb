class Event
  def initialize
    @listeners = []
  end

  def subscribe(listener = nil, &block)
    @listeners << (listener || block)
  end

  def unsubscribe(listener)
    @listeners.delete(listener)
  end

  def emit(*args)
    @listeners.each { |listener| listener.call(*args) }
  end
end