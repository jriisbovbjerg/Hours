# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    sequence(:name) { |n| "category#{n}" }
    project
    to_date "2015-02-26 22:06:47"
    from_date "2014-02-26 22:06:47"
  end
end
