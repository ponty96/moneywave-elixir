defmodule MissingSecretKeyError do
    defexception message: """
      The secret_key and api_key settings is required to use moneywave. Please include your
      moneywave api key in your application config file like so:

        config :moneywave, 
        secret_key: YOUR_SECRET_KEY,
        api_key, YOUR_API_KEY

      Alternatively, you can also set the secret key as an environment variable:

        MONEYWAVE_SECRET_KEY=YOUR_SECRET_KEY
        MONEYWAVE_API_KEY=YOUR_API_KEY
    """
end

defmodule Moneywave.Base do
  @moduledoc """
    Main module for handling sending/receiving messages from Moneywave's Api
  """

  @client_version Mix.Project.config[:version]
  @api_base "https://moneywave.herokuapp.com/"
  @api_key Application.get_env(:moneywave, :api_key, System.get_env("MONEYWAVE_API_KEY"))
    || raise MissingSecretKeyError

  @secret_key Application.get_env(:moneywave, :secret_key, System.get_env("MONEYWAVE_SECRET_KEY"))
    || raise MissingSecretKeyError

  def start_link do
    {:ok, pid} = Agent.start_link(fn -> %{merchant_token: ""} end, name: __MODULE__)
    updated = get_merchant_token
    {:ok, pid}
  end

  defp create_headers do
    %{merchant_token: token} = Agent.get(__MODULE__, fn state -> state end)

    [{"Authorization", "#{token}"},
    {"User-Agent", "Moneywave/v1 moneywave-elixir/#{@client_version}"},
     {"Content-Type", "application/json"}]
  end

  defp get_merchant_token do
    %{merchant_token: token} = Agent.get(__MODULE__, fn state -> state end)
    if(String.length(token) == 0) do
      data = %{apiKey: @api_key, secret: @secret_key}
      {:ok, %{"token" => token}} = request(:post, "v1/merchant/verify/", data)
      Agent.update(__MODULE__, fn _ -> %{merchant_token: token} end)
    end
  end

  defp process_url(endpoint) do
    @api_base <> endpoint
  end

  def request(action, endpoint) when action in [:get, :post, :delete],  do: request(action, endpoint, %{})
  def request(action, endpoint, form) do
    data = 
      form
      |> Poison.encode!
    HTTPoison.request(action, process_url(endpoint), data, create_headers())
    |> handle_response
  end

  defp handle_response({:ok, %{body: body, status_code: code}}) when code in 200..299 do
    IO.inspect process_response_body(body)
    {:ok, process_response_body(body)}
  end

  defp process_response_body(body) do
    Poison.decode! body
  end

end
