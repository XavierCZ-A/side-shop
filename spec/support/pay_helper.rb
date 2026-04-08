module PayHelper
  def subscribe_user(user, plan: "emprendedor")
    user.set_payment_processor(:fake_processor)
    user.payment_processor.subscribe(name: plan)
  end
end