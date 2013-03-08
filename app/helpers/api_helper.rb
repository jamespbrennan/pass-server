module ApiHelper
	
	#
	# Verify a message authentication code signature.
	#
	
	def verify_signature(auth_token, message, signature)
		sha1 = OpenSSL::Digest::Digest.new('sha1')
		expected = OpenSSL::HMAC.hexdigest(sha1, auth_token, message)
		signature == expected
	end

end