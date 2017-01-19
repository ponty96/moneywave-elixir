defmodule Moneywave.Errors.NotFound do
	@moduledoc """
	Wrong Endpoint or Wrong action send to correct endpoint
	"""
	defstruct type: "not_found_error", message: nil
end
