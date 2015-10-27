FactoryGirl.define do
	factory :user do
		email "test@testing.com"
		password "password"
		password_confirmation "password"
	end
end