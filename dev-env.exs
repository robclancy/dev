#!/usr/bin/env elixir

defmodule Setup do
  defmacro apply(do: block) do
    if System.get_env("DRY", "true") == "true" do
      quote do
        IO.puts("would execute: #{unquote(Macro.to_string(block))}")
      end
    else
      block
    end
  end

  def main(args) do
    dry = "--apply" not in args
    System.put_env("DRY", to_string(dry))

    if dry do
      IO.puts("DRY RUN - use --apply to execute")
    else
      IO.puts("EXECUTING")
    end

    config_home = System.get_env("XDG_CONFIG_HOME")

    {config_home, message} = if config_home do
      {config_home, "using #{config_home}"}
    else
      home = System.get_env("HOME")
      config_home = Path.join(home, ".config")
      System.put_env("XDG_CONFIG_HOME", config_home)
      {config_home, "XDG_CONFIG_HOME not set\nusing #{config_home}"}
    end

    IO.puts(message)

    copy_files("./env/.config", config_home)

    apply do
      System.cmd("hyprctl", ["reload"], into: :io)
    end
  end

  defp copy_file(from, to) do
    IO.puts("\e[35mcopying file: #{from} -> #{to}\e[0m")
    File.cd!(from)

  IO.puts("copying: cp ./#{from} #{to}")
  apply do
	File.cp("./#{from}", to)
  end
end

  defp copy_files(from, to) do
    IO.puts("\e[35mcopying files: #{from} -> #{to}\e[0m")
    File.cd!(from)

    configs = File.ls!()
    IO.inspect(configs)

    for config <- configs do
      dir = Path.join(to, config)

      IO.puts("removing: rm -rf #{dir}")
      apply do
        File.rm_rf(dir)
      end

      IO.puts("copying: cp -r ./#{config} #{dir}")
      apply do
        File.cp_r("./#{config}", dir)
      end
    end
  end
end

Setup.main(System.argv())
