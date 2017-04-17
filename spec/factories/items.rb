FactoryGirl.define do
  factory :item do
    name { Faker::StarWars.character }
    done false
    todo_id nil
  end
end
#
# FactoryGirl.define do
#   factory :item do
#     name { Faker::Game.house }
#     done false
#     todo_id nil
#   end
# end
# =
