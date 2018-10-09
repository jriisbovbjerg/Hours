
FactoryGirl.define do
  factory :expense do
    project
    amount 1
    value 7
    date "2014-02-26 22:06:47"
    user
    currency "DKK"
    supplier "supplier1"
    exchangerate 7.46
    description "description"

    factory :expense_with_client do
      project { create(:project, client: create(:client)) }
    end
  end
end