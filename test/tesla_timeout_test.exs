defmodule Tesla.Middleware.TimeoutTest do
  use ExUnit.Case
  doctest Tesla.Middleware.Timeout

  import Mock
  alias Tesla.Middleware.Timeout

  @timeout 100

  defmacro mock_tesla_response(func, expression) do
    quote do
      with_mock(Tesla, [:passthrough], [run: fn _, _ -> unquote(func) end]) do
        unquote(expression)
      end
    end
  end

  test "repass rescued errors from Tesla.run" do
    mock_tesla_response raise "custom_exception" do
      assert_raise RuntimeError, "custom_exception", fn ->
        Timeout.call(:env, :next, @timeout)
      end
    end
  end

  test "repass thrown value from Tesla.run" do
    mock_tesla_response throw(:value) do
      assert catch_throw(Timeout.call(:env, :next, @timeout)) == :value
    end
  end

  test "repass exit value from Tesla.run" do
    mock_tesla_response exit(:value) do
      assert catch_exit(Timeout.call(:env, :next, @timeout)) == :value
    end
  end

  test "repass successful Tesla.run result" do
    mock_tesla_response :tesla_result do
      assert Timeout.call(:env, :next, @timeout) == :tesla_result
    end
  end

  test "raise a Tesla.Error when the stack timeout" do
    mock_tesla_response Process.sleep(5_000) do
      error = assert_raise Tesla.Error, fn ->
        Timeout.call(:env, :next, @timeout)
      end
      assert error.reason == :timeout
    end
  end
end
