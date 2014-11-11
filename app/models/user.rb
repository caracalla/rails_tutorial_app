class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	before_create :create_remember_token

	#this works because the microposts table has 'user_id', rails infers
	#association by <class>_id (called a foreign key)
	has_many :microposts, dependent: :destroy

	#for relationships, must specify connection to User since the foreign key is
	#'follower_id' and not 'user_id'
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed

	#by passing in "followed_id" instead of "follower_id", we can reverse the
	#connection and create reverse_relationships
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	validates :name, presence: true, length: { maximum: 78 }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 8 }


	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def feed
		Micropost.from_users_followed_by(self)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
