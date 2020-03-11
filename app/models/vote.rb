class Vote
  include ActiveModel::Model
  CHOICES = ["Très bien", "Bien", "Assez bien", "Passable", "Insuffisant", "A Rejeter"]
  attr_accessor :id,
                :proposition_id,
                :choice
end
