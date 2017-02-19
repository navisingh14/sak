FactoryGirl.define do
	sequence :email do |n|
		"email#{n}@factory.com"
	end

	factory :user do |f|
		f.firstname Faker::Name.first_name
		f.lastname Faker::Name.last_name
		f.email #this email field is unique for every user because of sequencing defined above
		f.password Faker::Lorem.characters(8)
	end
end
