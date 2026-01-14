#!/usr/bin/env elixir

Code.require_file("dry_run.ex", __DIR__)

defmodule Setup do
  use DryRun

  def main(args) do
    DryRun.init(args)

    if DryRun.enabled?() do
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
      System.cmd("hyprctl", ["reload"], into: IO.stream(:stdio, :line))
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
