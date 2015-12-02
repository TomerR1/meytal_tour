class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
        resource.save_with_payment
    end
  end
end