FactoryGirl.define do
	factory :user do
		email "test-#{Time.now.hour}:#{Time.now.min}@testing.com"
		password "password"
		password_confirmation "password"
	end
end