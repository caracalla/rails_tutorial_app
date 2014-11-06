namespace :db do
	desc "Fill database with sample users"

	task populate: :environment do
		User.create!(name: "Marcus Aurelius Severus Antoninus Augustus",
								 email: "caracallarex@gmail.com",
								 password: "superfly",
								 password_confirmation: "superfly")

		User.create!(name: "Example User",
								 email: "example@railstutorial.org",
								 password: "foobarisstupid",
								 password_confirmation: "foobarisstupid")

		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(name: name,
									 email: email,
									 password: password,
									 password_confirmation: password)
		end

		users = User.all(limit: 6)

		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end