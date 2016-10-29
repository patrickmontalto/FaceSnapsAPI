module Request
	module JsonHelpers
		def json_response
			@json_response ||= JSON.parse(response.body, symbolize_names: true)
		end
	end

	# Helpers for headers
	module HeadersHelpers
		def api_header(version = 1)
			request.headers['Accept'] = "application/vnd.facesnapsapi.v#{version}"
		end

		def api_response_format(format = Mime::JSON)
			request.headers['Accept'] = "#{request.headers['Accept']}, #{format}"
			request.headers['Content-Type'] = format.to_s
		end

		# Convenience method for default headers
		def include_default_headers
			api_header
			api_response_format
		end
	end
end