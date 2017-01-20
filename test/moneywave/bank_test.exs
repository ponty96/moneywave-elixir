defmodule Moneywave.BankTest do
	use ExUnit.Case, async: true

	alias Moneywave.Bank

	setup do
		{:ok, pid} = Bank.start_link
		{:ok, [pid: pid]}
	end

	test "get all banks", context do
		assert {:ok, [ %Bank{code: code, name: name}| _]} = Bank.get_all
	end

	test "get bank by code", context do
		{:ok, banks} = Bank.get_all
		assert {:ok, %Bank{code: 044, name: "ACCESS BANK NIGERIA"}} = Bank.by_code(044)
	end
end