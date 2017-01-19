defmodule Moneywave.Bank do
	defstruct [code: 0, name: ""]
	alias Moneywave.Base
	import String, only: [to_integer: 1]

	@moduledoc """
		Bank is a simple module for fetching a list of banks (code and name)
	"""

	def start_link do
		Agent.start_link(fn -> [] end, name: __MODULE__)
	end

	def endpoint, do: "banks"

	def by_code(code) do
		banks = Agent.get(__MODULE__, fn state -> state end)
		bank = 
			Enum.find(banks, fn (bank) -> 
				if bank.code == code, do: true
			end)
		{:ok, bank}
	end

	def get_all do
		{:ok, %{"data" => data}} = Base.request(:post, endpoint())
		banks = 
			for bank <- data do
				put_bank(bank)
			end
		{:ok, banks}
	end

	defp put_bank({code, name}) do
		bank = %__MODULE__{code: to_integer(code), name: name}
		updated = Agent.update(__MODULE__, fn state -> state ++ [bank] end)
		bank
	end
end
