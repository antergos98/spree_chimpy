Spree::Order.class_eval do
  has_one :source, class_name: 'Spree::Chimpy::OrderSource'

  state_machine do
    after_transition :to => :complete, :do => :notify_mail_chimp
  end

  around_save :handle_cancelation
  after_save :setup_cart
  after_touch :setup_cart



  def notify_mail_chimp
    Spree::Chimpy.enqueue(:order, self) if completed? && Spree::Chimpy.configured?
  end

  def setup_cart
      Spree::Chimpy.enqueue(:cart, self) if !completed? && line_items.any? && Spree::Chimpy.configured?
  end

private
  def handle_cancelation
    canceled = state_changed? && canceled?
    yield
    notify_mail_chimp if canceled
  end
end
