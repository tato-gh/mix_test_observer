defmodule MixTestObserver.FileInput do
  @moduledoc """
  TODO
  """

  @doc """
  TODO
  """
  def parse(path) do
    with \
         {:ok, content} <- File.read(path),
         {:ok, behavior} <- parse_content(content)
    do
      {behavior, path}
    else
      case_error -> case_error
    end
  end

  defp parse_content(content) do
    content
    |> String.trim()
    |> content_behavior()
  end

  defp content_behavior(""), do: {:error, "nothing"}

  defp content_behavior(content) do
    content
    |> String.match?(~r|\Atest/|u)
    |> case do
      true -> {:ok, :test}
      false -> {:ok, :run_anyway}
    end
  end
end
