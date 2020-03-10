class User
  include ActiveModel::Model
  attr_accessor :first_name,
                :last_name,
                :email,
                :password,
                :password_confirmation,
                :accepted_condition,
                :number1,
                :number2,
                :total,
                :reset_password_token
end
