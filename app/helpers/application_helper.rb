module ApplicationHelper
	def avatar_url(user)
		#gravatar_id = Digest::MD5::hexdigest(user.email).downcase
		if user.avatar
			user.avatar_url
		else
			"default.png"
		end
	end
end
