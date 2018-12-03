FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "project#{n}" }
    billable false
    archived false
    valid_from "2015-02-26 22:06:47"
    valid_to "2018-02-26 22:06:47"
    administrative true

    factory :project_with_hours do
      after(:create) do |project, _evaluator|
        create_list(:hour, 2, project: project)
      end
    end

    factory :project_with_more_than_maximum_hours do
      after(:create) do |project, _evaluator|
        create_list(:hour, 7, project: project)
      end
    end
  end
end