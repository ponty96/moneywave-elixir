defmodule Moneywave.Wallet do
	alias Moneywave.Base

	def wallet_to_account(account_to_fund) do
		{:ok, %{"data" => data}} = Base.request(:post, "v1/disburse", account_to_fund)
		{:ok, Map.get(data, "data")}
	end

	def wallet_to_accounts(accounts_to_fund) do
		{:ok, res} = Base.request(:post, "v1/disburse/bulk", accounts_to_fund)
		{:ok, res}
	end

	def balance do
		{:ok, res} = Base.request(:get, "v1/wallet")
		{:ok, Map.get(res,"data")}
	end
end
