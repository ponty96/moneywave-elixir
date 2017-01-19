defmodule Moneywave.Errors.Authorization do
	@moduledoc """
	Failure to properly authenticate yourself in the request.
	"""
	defstruct type: "authorization_error", message: nil
end
