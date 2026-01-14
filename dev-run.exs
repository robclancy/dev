#!/usr/bin/env elixir

Code.require_file("dry_run.ex", __DIR__)

defmodule Run do
  use DryRun

  def main(args) do
    DryRun.init(args)

    if DryRun.enabled?() do
      IO.puts("DRY RUN - use --apply to execute")
    else
      IO.puts("EXECUTING")
      IO.puts("Requesting sudo access...")
      System.cmd("sudo", ["-v"])
    end

    runners_dir = "./runners"

    unless File.dir?(runners_dir) do
      IO.puts("Error: #{runners_dir} directory not found")
      System.halt(1)
    end

    runners = 
      File.ls!(runners_dir)
      |> Enum.sort()

    for runner <- runners do
      path = Path.join(runners_dir, runner)
      IO.puts("\n\e[35mRunning: #{runner}\e[0m")

      result = apply do
        System.shell("bash #{path}")
      end

      case result do
        :ok -> :ok

        {_, 0} ->
          IO.puts("\e[32m✓ #{runner} completed\e[0m")

        {_, exit_code} ->
          IO.puts("\e[31m✗ #{runner} failed with exit code #{exit_code}\e[0m")
          System.halt(exit_code)
      end
    end

    IO.puts("\n\e[32mAll runners completed\e[0m")
  end
end

Run.main(System.argv())
