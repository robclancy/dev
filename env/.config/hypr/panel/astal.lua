local App = require("astal.gtk3.app")
local Bar = require("widgets.bar")

App:start({
	css = [[
		window {
			background-color: transparent;
			color: white;
		}

		icon {
			font-size: 8px;
		}

		label {
			font-size: 11px;
		}

		icon + label {
			margin-left: 2px;
		}
	]],
	main = function()
		Bar()
    end
})
