defmodule DemoStatix.Instrumentation do
  alias Phoenix.Controller

  def phoenix_controller_call(:start, _compile_time_info, %{conn: conn}) do
    action = conn |> Controller.action_name() |> Atom.to_string()
    module = conn |> Controller.controller_module() |> Atom.to_string()
    %{module: module, method: conn.method, action: action}
  end

  def phoenix_controller_call(:stop, time_diff, %{
        module: module,
        method: method,
        action: action
      }) do
    time_ms =
      time_diff
      |> System.convert_time_unit(:native, :milliseconds)
      |> :erlang.float()

    tags = Application.get_env(:cl_gemini_web, DemoStatix.Instrumentation, [])

    method_metric_name = "backend.web" <> method
    module_action_name = module <> "." <> action

    DemoStatix.Statix.histogram(method_metric_name, time_ms, tags: tags)
    DemoStatix.Statix.histogram(module_action_name, time_ms, tags: tags)
  end

  # def phoenix_controller_render(:start, _compile_time, %{conn: conn}) do
  # end
end
