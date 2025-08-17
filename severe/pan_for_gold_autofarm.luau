local Helper = loadstring(
	game:HttpGet(
		"https://raw.githubusercontent.com/DCHARLESAKAMRGREEN/Severe-Luas/refs/heads/main/Internal%20Helper.lua"
	)
)()

local swap = false
local function MAIN_keyboardEvent()
	local listeners = {}

	return {
		connect = function(callback)
			table.insert(listeners, callback)
		end,
		fire = function(...)
			for _, listener in ipairs(listeners) do
				listener(...)
			end
		end,
	}
end

local KeyboardInput = {
	keyPressed = MAIN_keyboardEvent(),
	keyReleased = MAIN_keyboardEvent(),
}

local _CURRENTKEYS = {}

thread.create("_KEYPRESSTHREAD", function()
	local lastCheck = tick()
	while wait(0.032) do
		local pressedKeys = getpressedkeys()
		local shiftHeld = table.find(pressedKeys, "Shift") ~= nil

		for _, key in pairs(pressedKeys) do
			local processedKey = shiftHeld and key or string.lower(key)
			if not _CURRENTKEYS[processedKey] then
				_CURRENTKEYS[processedKey] = true
				KeyboardInput.keyPressed.fire(processedKey)
			end
		end

		for key in pairs(_CURRENTKEYS) do
			local keyStillPressed = false
			for _, pressedKey in pairs(pressedKeys) do
				if shiftHeld and pressedKey == key or not shiftHeld and string.lower(pressedKey) == key then
					keyStillPressed = true
					break
				end
			end

			if not keyStillPressed then
				_CURRENTKEYS[key] = nil
				KeyboardInput.keyReleased.fire(key)
			end
		end
	end
end)

local toggled = false
local swap = false
local check = 1
local backpacknum = 1
KeyboardInput.keyPressed.connect(function(key)
	local keyP = string.lower(key)

	if keyP == "t" then
		toggled = not toggled
	end
	if keyP == "r" then
		check = 1
		backpacknum = 1
	end
end)

local keycodes = { 49, 50, 51, 52, 53, 54, 55, 56, 57, 48 }
while wait(0.06) do
	if workspace.VFX:FindFirstChild("PanningMinigame") and toggled == true then
		local success, err = pcall(function()
			local panningGame = workspace.VFX.PanningMinigame.BillboardGui.Main.Holder

			local panPos = Helper.getframeposition(panningGame.Bar.Object.Data).y + 0.02
			local targetPos = Helper.getframeposition(panningGame.Bar.Target.Data).y

			if math.abs(panPos - targetPos) > 0 then
				if panPos > targetPos then
					if swap == true then
						swap = false
						mousemoverel(20, 0)
						mousemoverel(20, 0)
						mousemoverel(20, 0)
						mousemoverel(-60, 0)
					else
						swap = true
						mousemoverel(-20, 0)
						mousemoverel(-20, 0)
						mousemoverel(-20, 0)
						mousemoverel(60, 0)
					end
				end
			end
		end)

		if not success then
			print(err)
		end
	elseif toggled == true then
		keypress(69)
		keyrelease(69)
		check = check + 1
		if check == 20 then
			backpacknum = backpacknum + 1
			keypress(keycodes[backpacknum])
			keyrelease(keycodes[backpacknum])
		end
	end
end
