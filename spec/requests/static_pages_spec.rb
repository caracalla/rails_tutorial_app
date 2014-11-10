require 'spec_helper'

describe "StaticPages" do
	subject { page }

	describe "Home page" do
		before { visit root_path }

		it { should have_content('Sample App') }
		it { should have_title(full_title('')) }
		it { should_not have_title(' | Home') }

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			before do
				FactoryGirl.create(:micropost, user: user, content: "stupid crap")
				FactoryGirl.create(:micropost, user: user, content: "lame junk")
				valid_signin user
				visit root_path
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					expect(page).to have_selector("li##{item.id}", text: item.content)
				end
			end

			describe "follower/following counts" do
				let(:other_user) { FactoryGirl.create(:user) }
				before do
					other_user.follow!(user)
					visit root_path
				end

				it { should have_link("0 following", href: following_user_path(user)) }
				it { should have_link("1 follower", href: followers_user_path(user)) }
			end
		end
	end

	describe "Help page" do
		before { visit help_path }

		it { should have_content('Help') }
		it { should have_title(full_title('Help')) }
	end

	describe "About page" do
		before { visit about_path }

		it { should have_content('About Us') }
		it { should have_title(full_title('About Us')) }
	end

	describe "Contact page" do
		before { visit contact_path }

		it { should have_selector('h1', text: 'Contact Us') }
		it { should have_title(full_title('Contact Us')) }
	end

	it "should have the right links on the layout" do
		visit root_path
		click_link "About"
		expect(page).to have_title(full_title('About Us'))
		click_link "Help"
		expect(page).to have_title(full_title('Help'))
		click_link "Contact"
		expect(page).to have_title(full_title('Contact Us'))
		click_link "Home"
		click_link "Sign Up Now!"
		expect(page).to have_title(full_title('Sign Up'))
		click_link "sample app"
		expect(page).to have_title(full_title(''))
	end
end