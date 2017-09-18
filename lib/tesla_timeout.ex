defmodule Tesla.Middleware.Timeout do
  @moduledoc """
  Documentation for TeslaTimeout.
  """

  @timeout_error %Tesla.Error{
    reason: :timeout,
    message: "#{__MODULE__}: Request timeout."
  }

  @default_timeout :timer.seconds(6) #greather than default 5 seconds of GenServer timeout

  def call(env, next, timeout \\ @default_timeout) do
    task = safe_async(fn -> Tesla.run(env, next) end)
    try do
      task
      |> Task.await(timeout)
      |> repass_error
    catch :exit, {:timeout, _} ->
      Task.shutdown(task, 0)
      raise @timeout_error
    end
  end

  defp safe_async(func) do
    Task.async(fn ->
      try do
        {:ok, func.()}
      rescue e in _ ->
        {:error, e}
      catch type, value ->
        {type, value}
      end
    end)
  end

  defp repass_error({:error, error}),
  do: raise error

  defp repass_error({:throw, value}),
  do: throw value

  defp repass_error({:exit, value}),
  do: exit value

  defp repass_error({:ok, result}),
  do: result
end
