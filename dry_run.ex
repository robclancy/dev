defmodule DryRun do
  defmacro __using__(_opts) do
    quote do
      import DryRun
      require DryRun
    end
  end

  def init(args) do
    dry = "--apply" not in args
    System.put_env("DRY", to_string(dry))
    dry
  end

  def enabled? do
    System.get_env("DRY") == "true"
  end

  defmacro apply(do: block) do
    quote do
      if DryRun.enabled?() do
        IO.puts("would execute: #{unquote(Macro.to_string(block))}")
      else
        unquote(block)
      end
    end
  end
end
