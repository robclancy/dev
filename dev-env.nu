#!/usr/bin/env nu

def main [] {
	let $dry = false

	if ('XDG_CONFIG_HOME' in $env) {
		print "using $env.$XDG_CONFIG_HOME"
	} else {
		print "XDG_CONFIG_HOME not set"
		print $"using ($env.HOME)/.config"
		$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
	}

	copy_files ./env/.config $env.XDG_CONFIG_HOME

	print $"symlinking: ln -sf ('./env/.config/nvim/rocks.toml' | path expand) ($env.XDG_CONFIG_HOME)/nvim/rocks.toml
"
	ln -sf ('./env/.config/nvim/rocks.toml' | path expand) $"($env.XDG_CONFIG_HOME)/nvim/rocks.toml"

    ./ghostty.sh

	# Merge yambar hooks into ~/.claude/settings.json without touching anything else
	let claude_settings = $"($env.HOME)/.claude/settings.json"
	let current = if ($claude_settings | path exists) { open $claude_settings } else { {} }
	let hooks = {
		hooks: {
			UserPromptSubmit: [{matcher: "", hooks: [{type: "command", command: "~/.config/yambar/claude_hook.sh responding"}]}]
			Stop:             [{matcher: "", hooks: [{type: "command", command: "~/.config/yambar/claude_hook.sh needs_attention"}]}]
			Notification:     [{matcher: "permission_prompt", hooks: [{type: "command", command: "~/.config/yambar/claude_hook.sh permission"}]}]
		}
	}
	print $"updating claude settings: ($claude_settings)"
	$current | merge $hooks | save -f $claude_settings

	hyprctl reload
}

def copy_files [from, to] {
	print $"(ansi purple)copying files: ($from) -> ($to) (ansi reset)"
	cd $from

	
	let configs = ls
	print $configs

	for $config in $configs {
		let $dir = $"($to)/($config.name)"	

		print $"removing: rm -rf ($dir)"
		rm -rf $dir

		print $"copying: cp -r ./($config.name) ($dir)"
		cp -r $"./($config.name)" $dir
	}
}

