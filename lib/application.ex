defmodule DemoStatix.Application do
  use Application

  def start(_type, _args) do
    {:ok, hostname} = :inet.gethostname()

    Application.put_env(
      :cl_gemini_web,
      DemoStatix.Instrumentation,
      [
        "region:" <> get_from_env("AWS_REGION"),
        "hostname:" <> to_string(hostname)
      ],
      []
    )

    DemoStatix.Statix.connect()
    # Define workers and child supervisors to be supervised
    children = []
    opts = [strategy: :one_for_one, name: DemoStatix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_from_env(env_var) do
    System.get_env(env_var) || "nil"
  end
end
