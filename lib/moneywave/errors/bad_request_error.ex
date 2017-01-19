defmodule Moneywave.Errors.BadRequest do
	@moduledoc """
	Bad request errors arise when your request has invalid parameters
	"""
	defstruct type: "bad_request_error", message: nil, param: nil
end
