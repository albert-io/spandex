defmodule Spandex.Plug.EndTrace do
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    adapter = Confex.get(:spandex, :adapter)
    _ = update_trace_with_conn_status(adapter, conn)
    _ = adapter.finish_trace()

    conn
  end

  defp update_trace_with_conn_status(adapter, %{status: status}) when status in 200..399 do
    adapter.update_top_span(%{status: status, error: 0})
  end

  defp update_trace_with_conn_status(adapter, %{status: status}) do
    adapter.update_top_span(%{status: status, error: 1})
  end
end
