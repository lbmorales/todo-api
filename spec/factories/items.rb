FactoryGirl.define do
  factory :item do
    name { Faker::Game.house }
    done false
    todo_id nil
  end  
end