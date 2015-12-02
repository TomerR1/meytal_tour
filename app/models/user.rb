class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :stripe_card_token
  
  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(
        :source => stripe_card_token,
        :description => email
      )
      self.stripe_customer_token = customer.id
      begin
        charge = Stripe::Charge.create(
          :amount => 1000,
          :currency => "usd",
          :customer => customer.id,
          :description => "Example charge"
        )
        save!
      rescue Stripe::CardError => e
        # The card has been declined
      end
    end
  end
end
