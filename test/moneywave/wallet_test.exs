defmodule Moneywave.WalletTest do
	use ExUnit.Case, async: true

	alias Moneywave.{Wallet,Util}

	setup do
		lock = "19012017"
		account1 = %{
			amount: 5,
      bankcode: "044",
      accountNumber: "0690000004",
      currency: "NGN",
      senderName: "Ponty Ayomide",
      ref: Util.generate_random_ref()
		}

		account2 = %{
			amount: 5,
      bankcode: "058",
      accountNumber: "0921318712",
      currency: "NGN",
      senderName: "Ponty Ayomide",
      ref: Util.generate_random_ref()
		}

		list_of_accounts = %{
			lock: lock,
			recipients: [account1, account2],
			currency: "NGN",
			ref: Util.generate_random_ref(),
			senderName: "Ponty Ayomide",
		}
		{:ok, %{account1: account1, account2: account2, list: list_of_accounts, lock: lock}}
	end

	test "transfer from wallet to account", context do
		account = Map.put(context[:account2], :lock, context[:lock])
		assert {:ok, %{"responsecode" => "00"}} =  Wallet.wallet_to_account(account)
	end

	test "transfer from wallet to multiple accounts", context do
		accountNumber = context[:account1].accountNumber

		response = Wallet.wallet_to_accounts(context[:list])
		assert {:ok, %{"passed" => 2, "failed" => 1}} = response
	end

	test "get balance" do
		assert {:ok, [ %{"name" => "Ponty Ayomide"}| _]} = Wallet.balance()
	end
end