-- STANDALONE SERVER SCRIPT (Put in ServerScriptService)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- 1. PASTE YOUR RAW GITHUB LINK HERE
local githubUrl = "https://githubusercontent.com"

-- Function that handles fetching and running the code for a player
local function loadPanelForPlayer(player)
	-- Wait for the player's UI folder to load completely
	local playerGui = player:WaitForChild("PlayerGui", 10)
	if not playerGui then return end
	
	-- Fetch the raw source code text from GitHub
	local success, codeString = pcall(function()
		return HttpService:GetAsync(githubUrl)
	end)
	
	if success and codeString then
		-- Use loadstring on the server (where it is allowed)
		local compiledFunction, err = loadstring(codeString)
		
		if compiledFunction then
			-- Environment sandbox trick: Inject playerGui and player context directly into the code
			local environment = setmetatable({
				-- Overriding common client variables so your script knows where to put the UI
				game = game,
				script = script,
				print = print,
				warn = warn,
				Color3 = Color3,
				UDim2 = UDim2,
				Instance = Instance,
				TweenInfo = TweenInfo,
				Enum = Enum,
				ipairs = ipairs,
				pairs = pairs,
				task = task,
				UserInputService = game:GetService("UserInputService"),
				TweenService = game:GetService("TweenService"),
				-- Crucial context overrides:
				owner = player, 
				LocalPlayer = player,
				playerGui = playerGui
			}, {__index = _G})
			
			setfenv(compiledFunction, environment)
			
			-- Run the code!
			local executed, runError = pcall(compiledFunction)
			if executed then
				print("Successfully generated panel for: " .. player.Name)
			else
				warn("Error running the fetched code: " .. tostring(runError))
			end
		else
			warn("Syntax error in your GitHub code: " .. tostring(err))
		end
	else
		warn("Failed to reach GitHub! Check your link or HTTP Settings.")
	end
end

-- Run whenever a player joins the game
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1) -- Short pause to ensure loading is completely finished
		loadPanelForPlayer(player)
	end)
end)

-- Run for any players already in the server (useful when clicking 'Play' in Studio)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(loadPanelForPlayer, player)
end
