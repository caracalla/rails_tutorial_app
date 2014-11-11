class RelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		#redirect_to @user

		#respond to http request with redirect, ajax request with js
		#only one line is executed based on request type
		respond_to do |format|
			format.html { redirect_to @user }

			#in the case of js, "create.js.erb" is called
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		#redirect_to @user

		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end