FactoryGirl.define do
  factory :assignment do
    project
    user
    valid_from 5.days.ago
    valid_to 5.days.from_now

    factory :assignment_in_past do
      valid_from 20.days.ago
      valid_to 10.days.ago
    end

    factory :assignment_in_future do
      valid_from 10.days.from_now
      valid_to 20.days.from_now
    end
    
    factory :assignment_overlapping do
      valid_from 1.days.from_now
      valid_to 8.days.from_now
    end

    factory :assignment_high_rate do
      hourly_rate 1300
    end

    factory :assignment_in_eur do
      hourly_rate 100
      currency 'EUR'
    end
  end
end