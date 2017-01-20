defmodule Moneywave.Util do

	def generate_random_ref() do
		length = 10
		:crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
	end
	
end