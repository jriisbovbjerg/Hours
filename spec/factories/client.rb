FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "client#{n}" }
    description "this is a description"
    companyname "companyname"
    adress "adress"
    postalcode "postalcode"
    otherinfo "otherinfo"
    invoiceemail "invoiceemail"
    paymentterms "paymentterms"
  end
end
