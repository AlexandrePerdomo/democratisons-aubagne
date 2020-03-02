class User
  include ActiveModel::Model
  attr_accessor :first_name,
                :last_name,
                :email,
                :password,
                :accepted_condition,
                :number1,
                :number2,
                :total
end
