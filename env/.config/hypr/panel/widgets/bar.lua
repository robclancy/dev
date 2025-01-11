local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Anchor = require("astal.gtk3").Astal.WindowAnchor

local function get_battery_icon(percentage, charging) 
	if percentage >= 95 and charging then
		return 'battery-level-100-charged-symbolic'
	end

	local level = math.floor(percentage / 10) * 10

	return "battery-level-" .. level .. (charging and '-charging' or '') .. "-symbolic"
end

local function get_battery()
	local capacity = io.open("/sys/class/power_supply/BAT0/capacity", "r")

	local bat = {
		icon = 'battery-missing-symbolic',
		percentage = 0,
	}

	if capacity then
		local percentage = tonumber(capacity:read("*a"))
		local status = io.open("/sys/class/power_supply/BAT0/status", "r")
		local statusText = status:read("*a"):gsub("\n", "")

		bat = {
			icon = get_battery_icon(percentage, status == "Charging" or status == "Not charging"),
			percentage = percentage,
		}

		capacity:close()
		status:close()
	end

	return bat
end

local function BatteryLevel()
	local bat = astal.Variable(get_battery()):poll(1000, function() return get_battery() end)

	return Widget.Box({
		class_name = "Battery",
		Widget.Icon({
			css = astal.bind(bat, 'percentage'):as(function (bat)
				if bat.percentage <= 10 then
					return "color: red; font-size: 110%"
				end
				if bat.percentage < 20 then
					return "color: red"
				end
			end),
			icon = astal.bind(bat, 'icon'):as(function (bat) return bat.icon end),
		}),
		Widget.Label({
			css = astal.bind(bat, 'percentage'):as(function (bat)
				if bat.percentage <= 10 then
					return "color: red; font-size: 115%"
				end
				if bat.percentage < 30 then
					return "color: red"
				end
				if bat.percentage < 50 then
					return "color: orange"
				end
			end),
			label = astal.bind(bat, 'percentage'):as(function(bat)
				return string.format("%d%%", bat.percentage)
			end)
		}),
	})
end

return function(monitor)
    return Widget.Window({
        monitor = monitor,
        anchor = Anchor.TOP + Anchor.LEFT + Anchor.RIGHT,
        exclusivity = "EXCLUSIVE",
		Widget.Box({
			halign = "END",
			BatteryLevel(),
		})
    })
end
