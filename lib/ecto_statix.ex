defmodule DemoStatix.EctoStatix do
  @spec monitor(Ecto.LogEntry.t()) :: Ecto.LogEntry.t()
  def monitor(event) do
    monitor(event, :debug)
  end

  @spec monitor(Ecto.LogEntry.t()) :: Ecto.LogEntry.t()
  def monitor(
        %{
          query_time: query_time_native,
          decode_time: decode_time_native,
          queue_time: queue_time_native
        } = entry,
        _level
      )
      when is_integer(query_time_native) and is_integer(decode_time_native) and
             is_integer(queue_time_native) do
    query_time = System.convert_time_unit(query_time_native, :native, :milliseconds)
    decode_time = System.convert_time_unit(decode_time_native, :native, :milliseconds)
    queue_time = System.convert_time_unit(queue_time_native, :native, :milliseconds)

    tags = Application.get_env(:cl_gemini, DemoStatix.Instrumentation, [])

    DemoStatix.Statix.histogram("ecto.query_time", query_time, tags: tags)
    DemoStatix.Statix.histogram("ecto.decode_time", decode_time, tags: tags)
    DemoStatix.Statix.histogram("ecto.queue_time", queue_time, tags: tags)

    entry
  end

  def monitor(entry, _level) do
    entry
  end
end
