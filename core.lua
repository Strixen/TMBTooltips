ThatsMyBis = LibStub("AceAddon-3.0"):NewAddon("ThatsMyBis", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0")
local LibAceSerializer = LibStub:GetLibrary("AceSerializer-3.0")
local libc = LibStub:GetLibrary("LibCompress")


local frame = CreateFrame( "Frame" )
local AceGUI = LibStub("AceGUI-3.0")
local TMBIcon = LibStub("LibDBIcon-1.0")

local classColorsTable = {
	"\124cFFC79C6E",
	"\124cFFF58CBA",
	"\124cFF0070DE",
	"\124cFFABD473",
	"\124cFFFF7D0A",
	"\124cFFFFF569",
	"\124cFFFFFFFF",
	"\124cFF9482C9",
	"\124cFF69CCF0",
	"\124cFFC41E3A"
	}
	local classToID = {
		Warrior = 1,
		Paladin = 2,
		Shaman = 3,
		Hunter = 4,
		Druid = 5,
		Rogue = 6,
		Priest = 7,
		Warlock = 8,
		Mage = 9,
		["Death Knight"] = 10
		}
local rankColorsTable = {
	S = "\124cFF02F3FF",
	A = "\124cFF20FF00",
	B = "\124cFFF7FF00",
	C = "\124cFFFF8800", 
	D = "\124cFFFF0078",
	F = "\124cFFFF0000",
	N = "\124cFFFF0000"
	}

	local rankColorsTableConvert = {
	"S",
	"A",
	"B",
	"C", 
	"D",
	"F",
	"N"
	}

local altColor = "\124cFFb8b8b8"

local origChatFrame_OnHyperlinkShow = ChatFrame_OnHyperlinkShow

local statusEnableText = "TMB Tooltips is currently: Disabled"

local currentPlayer = UnitName("player")





local TMBLDB = LibStub("LibDataBroker-1.1"):NewDataObject("TMBTooltips", {
type = "data source",
text = "TMB Tooltips",
icon = "Interface\\Icons\\inv_misc_note_01",
OnClick = function(self,button,down)
	if button == "LeftButton" then
		if ItemListsDB.enabled then 
			statusEnableText = "TMB Tooltips is currently: Disabled"
			ItemListsDB.enabled = false
		else
			statusEnableText = "TMB Tooltips is currently: Enabled"
			ItemListsDB.enabled = true
		end
	ThatsMyBis:Print(statusEnableText)
	elseif button == "RightButton" then
		popupConfig()
	end
end,
OnTooltipShow = function(tooltip) -- Icon tooltip
	tooltip:AddLine("That's My BIS Tooltips")
	tooltip:AddLine("Revision    : 106-Wrath") -- EDIT TOC and PKMETA
	tooltip:AddLine("Left click : Enable/Disable display")
	tooltip:AddLine("Right click: Open config")
	tooltip:AddLine("Hold Alt   : Change tooltip display")
	tooltip:AddLine("Chat CMD   : /tmb")
	tooltip:AddLine("Database ID: " .. ItemListsDB.itemNotes.ID)
end,
})

function showSync()
	if syncShown then
		return
	end

	syncShown = true

	syncFrame = AceGUI:Create("Frame")
	syncFrame:SetTitle("Sync TMB Data")
	syncFrame.sizer_se:Hide()
	syncFrame.sizer_s:Hide()
	syncFrame.sizer_e:Hide()
	syncFrame:SetWidth(270)
	syncFrame:SetHeight(160)
	syncFrame:SetLayout("Flow")
	syncFrame:SetStatusText("Ready")
	local targetField = AceGUI:Create("EditBox")
	targetField:SetLabel("Who do you want to send data to?")
	targetField:DisableButton(true)
	syncFrame:AddChild(targetField)
	
	local SyncButton = AceGUI:Create("Button")
	SyncButton:SetText("Sync")
	syncFrame:AddChild(SyncButton)
	SyncButton:SetCallback("OnClick", function (obj, button, down)
		-- Start sync operation
		ThatsMyBis:SendComm(targetField:GetText(), "RTS", ItemListsDB.itemNotes.ID)
		
	end)







	syncFrame:SetCallback("OnClose", 
	function(widget)
	  AceGUI:Release(widget)
	  syncShown = false
	end
   )
end

local function newConfigPanel()
	if configShown then
		return
	end

	configShown = true

	syncFrame = AceGUI:Create("Frame")
	syncFrame:SetTitle("Thats my bis Tooltips")
	syncFrame.sizer_se:Hide()
	syncFrame.sizer_s:Hide()
	syncFrame.sizer_e:Hide()
	syncFrame:SetWidth(600)
	syncFrame:SetHeight(500)




	syncFrame:SetCallback("OnClose", 
	function(widget)
	  AceGUI:Release(widget)
	  configShown = false
	end
   )
end


function popupConfig()

	if frameShown then
		return
	end
	
	frameShown = true



	popup = AceGUI:Create("Frame")
	popup:SetTitle("Thats My BIS Tooltips")
	popup:SetStatusText(statusEnableText)

	popup.sizer_se:Hide()
	popup.sizer_s:Hide()
	popup.sizer_e:Hide()
	popup:SetWidth(600)
	popup:SetHeight(370)
	local checkboxGroup = AceGUI:Create("SimpleGroup")
	checkboxGroup:SetRelativeWidth(0.4)
	local textboxGroup = AceGUI:Create("SimpleGroup")
	textboxGroup:SetRelativeWidth(0.6)

	local checkLabel = AceGUI:Create("Label")
    checkLabel:SetText("Tooltip display settings")
	checkboxGroup:AddChild(checkLabel)

	local check1 = AceGUI:Create("CheckBox")
	check1:SetLabel("Show Priority Note")
	check1:SetValue(ItemListsDB.displayPrioNote)
	checkboxGroup:AddChild(check1)

--[[ 	local check6 = AceGUI:Create("CheckBox")
	check6:SetLabel("Guild Note")
	check6:SetValue(ItemListsDB.displayGuildNote)
	checkboxGroup:AddChild(check6) ]]

	local check2 = AceGUI:Create("CheckBox")
	check2:SetLabel("Show Ranks")
	check2:SetValue(ItemListsDB.displayRank)
	checkboxGroup:AddChild(check2)

	local check3 = AceGUI:Create("CheckBox")
	check3:SetLabel("Show Wishlists")
	check3:SetValue(ItemListsDB.displayWishes)
	checkboxGroup:AddChild(check3)

	local check4 = AceGUI:Create("CheckBox")
	check4:SetLabel("Show Priolists")
	check4:SetValue(ItemListsDB.displayPrios)
	checkboxGroup:AddChild(check4)

	local check5 = AceGUI:Create("CheckBox")
	check5:SetLabel("Color alt's gray")
	check5:SetValue(ItemListsDB.displayAlts)
	checkboxGroup:AddChild(check5)

	local check7 = AceGUI:Create("CheckBox")
	check7:SetLabel("Hide received wishes")
	check7:SetValue(ItemListsDB.hideReceivedWishes)
	checkboxGroup:AddChild(check7)

	local check8 = AceGUI:Create("CheckBox")
	check8:SetLabel("Hide received prios")
	check8:SetValue(ItemListsDB.hideReceivedPrios)
	checkboxGroup:AddChild(check8)

	local check9 = AceGUI:Create("CheckBox")
	check9:SetLabel("Always show received")
	check9:SetValue(ItemListsDB.forceReceivedList)
	checkboxGroup:AddChild(check9)

	local check10 = AceGUI:Create("CheckBox")
	check10:SetLabel("Disable when not in raid")
	check10:SetValue(ItemListsDB.onlyInRaid)
	checkboxGroup:AddChild(check10)

	local check11 = AceGUI:Create("CheckBox")
	check11:SetLabel("Exclude non-raid members")
	check11:SetValue(ItemListsDB.onlyRaidMembers)
	checkboxGroup:AddChild(check11)

	local check12 = AceGUI:Create("CheckBox")
	check12:SetLabel("Show Offspec Tag")
	check12:SetValue(ItemListsDB.displayOS)
	checkboxGroup:AddChild(check12)

	-- END OF CHECKBOXES

	local slider1 = AceGUI:Create("Slider")
	slider1:SetValue(ItemListsDB.maxNames)
	slider1:SetSliderValues(1,10,1)
	slider1:SetLabel("How many names to display")
	slider1:SetRelativeWidth(1)
	textboxGroup:AddChild(slider1)

	inputfield = AceGUI:Create("MultiLineEditBox")
	inputfield:SetLabel("Paste CSV here")
	inputfield:SetNumLines(12)
	inputfield:SetWidth(320)

	local textBuffer, i, lastPaste = {}, 0, 0
	local pasted = ""
	inputfield.editBox:SetScript("OnShow", function(obj)
		obj:SetText("")
		pasted = ""
	end)
	local function clearBuffer(obj1)
		obj1:SetScript('OnUpdate', nil)
		pasted = strtrim(table.concat(textBuffer))
		inputfield.editBox:ClearFocus()
	end
	inputfield.editBox:SetScript('OnChar', function(obj2, c)
		if lastPaste ~= GetTime() then
			textBuffer, i, lastPaste = {}, 0, GetTime()
			obj2:SetScript('OnUpdate', clearBuffer)
		end
		i = i + 1
		textBuffer[i] = c
	end)
	inputfield.editBox:SetMaxBytes(2500)
	inputfield.editBox:SetScript("OnMouseUp", nil);

	inputfield:DisableButton(true)
	textboxGroup:AddChild(inputfield)

	local parseData = AceGUI:Create("Button")
	parseData:SetText("Save CSV Data")
	textboxGroup:AddChild(parseData)

	popup:SetLayout("Flow")

	popup:AddChild(checkboxGroup)
	popup:AddChild(textboxGroup)


	check1:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayPrioNote = check1:GetValue()
	end)
	check2:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayRank = check2:GetValue()
	end)
	check3:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayWishes = check3:GetValue()
	end)
	check4:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayPrios = check4:GetValue()
	end)
	check5:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayAlts = check5:GetValue()
	end)
--[[ 	check6:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayGuildNote = check6:GetValue()
	end) ]]
	check7:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.hideReceivedWishes = check7:GetValue()
	end)
	check8:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.hideReceivedPrios = check8:GetValue()
	end)
	check9:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.forceReceivedList = check9:GetValue()
	end)

	check10:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.onlyInRaid = check10:GetValue()
	end)

	check11:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.onlyRaidMembers = check11:GetValue()
	end)

	check12:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayOS = check12:GetValue()
	end)

	slider1:SetCallback("OnMouseUp", function(slid)
		ItemListsDB.maxNames = slid:GetValue()
	end)

	parseData:SetCallback("OnClick", function (obj, button, down)
		--message(pasted)
		if pasted == "" then return end
		obj:SetText(ParseText(pasted))
		inputfield:SetText("")
	end)




	popup:SetCallback("OnClose", 
	function(widget)
	  AceGUI:Release(widget)
	  frameShown = false
	end
   )
end


function ThatsMyBis:OnInitialize() --Fires when the addon is being set up.
	self.db = LibStub("AceDB-3.0"):New("TMBDB", { profile = { minimap = { hide = false, }, }, })
	TMBIcon:Register("TMBTooltips", TMBLDB,  self.db.profile.minimap) 
	self:RegisterChatCommand("tmb", "ChatCommands") 
	self:RegisterComm("TMBSync", ThatsMyBis:OnCommReceived())

end



function ThatsMyBis:OnEnable() --Fires when the addon loads, makes sure there is a db to look at.

	if ItemListsDB == nil then ItemListsDB = {} end
	if ItemListsDB.itemNotes == nil then ItemListsDB.itemNotes = {} end
	if ItemListsDB.enabled == nil then ItemListsDB.enabled = true end
	if ItemListsDB.displayPrioNote == nil then ItemListsDB.displayPrioNote = true end
	if ItemListsDB.displayGuildNote == nil then ItemListsDB.displayGuildNote = true end
	if ItemListsDB.displayRank == nil then ItemListsDB.displayRank = true end
	if ItemListsDB.displayWishes == nil then ItemListsDB.displayWishes = true end
	if ItemListsDB.displayPrios == nil then ItemListsDB.displayPrios = true end
	if ItemListsDB.displayAlts == nil then ItemListsDB.displayAlts = true end
	if ItemListsDB.maxNames == nil then ItemListsDB.maxNames = 3 end
	if ItemListsDB.hideReceivedWishes == nil then ItemListsDB.hideReceivedWishes = false end
	if ItemListsDB.hideReceivedPrios == nil then ItemListsDB.hideReceivedPrios = false end
	if ItemListsDB.forceReceivedList == nil then ItemListsDB.forceReceivedList = false end
	if ItemListsDB.onlyInRaid == nil then ItemListsDB.onlyInRaid = false end
	if ItemListsDB.onlyRaidMembers == nil then ItemListsDB.onlyRaidMembers = false end
	if ItemListsDB.itemNotes.ID == nil then ItemListsDB.itemNotes.ID = 0 end
	if ItemListsDB.showMemberNotess == nil then ItemListsDB.showMemberNotes = false end
	if ItemListsDB.displayOS == nil then ItemListsDB.displayOS = true end
	if ItemListsDB.lootTableTest == nil then ItemListsDB.lootTableTest = {} end


	if ItemListsDB.enabled then 
		statusEnableText = "TMB Tooltips is currently: Enabled"
	end
	self:RegisterEvent("CHAT_MSG_LOOT", "HandleEvent")
	
end

local function exportLootTable()
	local exportString = "dateTime,player,itemID,itemName\n"
	for k,v in pairs(ItemListsDB.lootTableTest) do
		exportString = exportString .. k .. ","
		for garbage,data in pairs(v) do
			exportString = exportString .. data .. ","
		end
		exportString = exportString:sub(1, #exportString - 1) .. "\n"

	end
	inputfield:SetText(exportString)
	inputfield:SetFocus()
	inputfield:HighlightText()
end



function ThatsMyBis:HandleEvent(self, event, ...)
	local tempLootEntry = {}
	--local zone = GetRealZoneText();
	local itemLink = string.match(event,"|%x+|Hitem:.-|h.-|h|r")
	local itemId, itemName, quality = ParseItemIdOrLink(itemLink)
	local LootersName = string.match(event,"%u%l+")
	

	if (LootersName == "You") then
		LootersName = UnitName("player");
	end
	tempLootEntry = {LootersName, itemId, itemName}
	if quality and quality >= 6 then
		ItemListsDB.lootTableTest[GetServerTime()] = tempLootEntry
		ThatsMyBis:Print(GetServerTime(), LootersName, itemId, itemName)
	end
end

function ThatsMyBis:ChatCommands(arg)
	if arg == "" then 
		popupConfig()
	elseif arg == "minimap" then
		self.db.profile.minimap.hide = not self.db.profile.minimap.hide 
		if self.db.profile.minimap.hide then
			TMBIcon:Hide("TMBTooltips") 
		else 
			TMBIcon:Show("TMBTooltips") 
		end 
	elseif arg == "toggle" then
		if ItemListsDB.enabled then 
			statusEnableText = "TMB Tooltips is currently: Disabled"
			ItemListsDB.enabled = false
		else
			statusEnableText = "TMB Tooltips is currently: Enabled"
			ItemListsDB.enabled = true
		end
		ThatsMyBis:Print(statusEnableText)
	elseif arg == "sync" then
		showSync()
	elseif arg == "test" then
		exportLootTable()
	elseif arg == "notes" then
		ItemListsDB.showMemberNotes = not ItemListsDB.showMemberNotes
	else 
		ThatsMyBis:Print("Thats my BIS command arguments\nminimap - toggle minimap icon\ntoggle - enable/disable function\nno argument - open config\nanything else - show this text")
	end

end 

local function ModifyItemTooltip( tt ) -- Function for modifying the tooltip
	if not ItemListsDB.enabled then return end
	if ItemListsDB.onlyInRaid then
		if not IsInRaid() then return end
	end
	local itemName, itemLink = tt:GetItem() 
	if not itemName then return end
	local itemID = select( 1, GetItemInfoInstant( itemName ) )
	
	if itemID == nil then 
		itemID = tonumber( string.match( itemLink, "item:?(%d+):" ) )
		if itemID == nil then
			return
		end
	end

	if itemID == 18423 then
		itemID = 18422
	elseif itemID == 19003 then
		itemID = 19002
	elseif itemID == 32386 then 
		itemID = 32385
	end

	local itemNotes = ItemListsDB.itemNotes[itemID]
	if itemNotes == nil then return end -- Item not in DB, escape out of function.

	if IsAltKeyDown() == false then --Display something different if alt is held down.
		-- %%%%%%%%%%%%%%%%% PRIO NOTES
		if ItemListsDB.displayPrioNote or ItemListsDB.displayRank then
			local rankData = ""
			local rankColorSelect = itemNotes.rank
			if (tonumber(rankColorSelect) ~= nil) then
				rankColorSelect = rankColorsTableConvert[tonumber(rankColorSelect)]
			end

			local itemPrioNotes = itemNotes.prioNote or ""
			if not ItemListsDB.displayPrioNote then itemPrioNotes = "" end
			if itemPrioNotes ~= "" then itemPrioNotes = itemPrioNotes .. " | " end

			if ItemListsDB.displayRank and (itemNotes.rank ~= "" and itemNotes.rank ~= nil) then
				rankData = "\124cFFD97025Rank: " .. rankColorsTable[rankColorSelect]..itemNotes.rank
			end
			if rankData ~= "" or itemPrioNotes ~= "" then
				tt:AddLine("Prio Notes:")
				tt:AddLine("\124cFFFFFFFF" .. itemPrioNotes .. rankData)
			else
			end
		end

		-- %%%%%%%%%%%%%%%%% GUILD NOTES

		if ItemListsDB.displayGuildNote then
			local itemGuildNotes = itemNotes.guildNote
			if itemGuildNotes ~= nil and itemGuildNotes ~= "" then
				tt:AddLine("Guild Notes:")
				tt:AddLine("\124cFFFFFFFF" .. itemGuildNotes )
			end
		end
		-- %%%%%%%%%%%%%%%%% WISHLIST

		if ItemListsDB.displayWishes then
			local itemWishes = {}
			local wishlistString = ""
			local smallestKey = 0
			local smallestWish = {}
			local keyIndex = 1
			local totalHiddenWishes = 0
			local totalReceivedWishes = 0
			
			if itemNotes.wishlist ~= nil then
				for k,v in pairs(itemNotes.wishlist) do
					add = false
					if ItemListsDB.onlyRaidMembers then
						if UnitInRaid(v.character_name) ~= nil then
							add = true
						end
					else
						add = true
					end

					if itemNotes.received ~= null and ItemListsDB.hideReceivedWishes then 
						for key,value in pairs(itemNotes.received) do
							if value.character_name == v.character_name then
								add = false
								totalReceivedWishes = totalReceivedWishes + 1
							end
						end
					end 
					if add == true then
						itemWishes[keyIndex] = v 
						keyIndex = keyIndex + 1
					else
						totalHiddenWishes = totalHiddenWishes + 1
					end
					

				end
				-- Construct the string to be displayed
				for i = 1,ItemListsDB.maxNames,1 do
					local smallestOrder = 99999
					for k,v in pairs(itemWishes) do

						if v.sort_order <= smallestOrder then
							smallestKey = k
							smallestOrder = v.sort_order
						end
					end
					smallestWish = table.remove(itemWishes,smallestKey)
					if smallestWish == nil then break end
					local altStatus = ""
					local linebreaker = " "
					local noteHolder = ""
					local OSText = ""
					if ItemListsDB.showMemberNotes then 
						if smallestWish.character_note ~= nil then 
							noteHolder = " {"..smallestWish.character_note.."} "
						end
					end
					if i % 5 == 0 then linebreaker = "\n" end
					if ItemListsDB.displayAlts and smallestWish.character_is_alt == 1 then altStatus = altColor end
					if ItemListsDB.displayOS and smallestWish.is_offspec == 1 then OSText = "-OS" end
					wishlistString = wishlistString .. classColorsTable[ smallestWish.character_class ] .. smallestWish.character_name .. altStatus .. "[" .. smallestWish.sort_order .. OSText .. "]\124r" .. noteHolder .. linebreaker
				end
				local optionalString = ""
				if totalHiddenWishes-totalReceivedWishes > 0 then 
					optionalString = optionalString .. totalHiddenWishes-totalReceivedWishes .. " Hidden "
				end
				if totalReceivedWishes > 0 then
					optionalString = optionalString .. totalReceivedWishes .. " Received "
				end
				if optionalString ~= "" then 
					tt:AddLine("\124cFFFF8000" .. "Wishes: ( ".. optionalString .. ")" )	
				else
					tt:AddLine("\124cFFFF8000" .. "Wishes:")
				end	
				tt:AddLine( wishlistString )
			end
		end
		-- %%%%%%%%%%%%%%%%% PRIOS

		if ItemListsDB.displayPrios then
			local itemPrios = {}
			local prioListString = ""
			local smallestPrioKey = 0
			local smallestPrio = {}
			local totalHiddenPrios = 0
			local totalReceivedPrios = 0
			keyIndex = 1
			if itemNotes.priolist ~= nil then
				for k,v in pairs(itemNotes.priolist) do
					add = false
					if ItemListsDB.onlyRaidMembers then
						if UnitInRaid(v.character_name) ~= nil then
							add = true
						end
					else
						add = true
					end

					if itemNotes.received ~= null and ItemListsDB.hideReceivedPrios then 
						for key,value in pairs(itemNotes.received) do
							if value.character_name == v.character_name then
								add = false
								totalReceivedPrios = totalReceivedPrios + 1
							end
						end
					end 
					if add == true then
						itemPrios[keyIndex] = v 
						keyIndex = keyIndex + 1
					else
						totalHiddenPrios = totalHiddenPrios + 1
					end
					

				end
				-- Construct the string to be displayed
				for i = 1,ItemListsDB.maxNames,1 do
					local smallestPrioOrder = 99999
					for k,v in pairs(itemPrios) do
						if v.sort_order <= smallestPrioOrder then
							smallestPrioKey = k
							smallestPrioOrder = v.sort_order
						end
					end
					smallestPrio = table.remove(itemPrios,smallestPrioKey)
					if smallestPrio == nil then break end
					local altStatus = ""
					local linebreaker = " "
					local noteHolder = ""
					local OSText = ""
					if ItemListsDB.showMemberNotes then 
						if smallestPrio.character_note ~= nil then 
							noteHolder = " {"..smallestPrio.character_note.."} "
						end
					end
					if i % 5 == 0 then linebreaker = "\n" end
					if ItemListsDB.displayAlts and smallestPrio.character_is_alt == 1 then altStatus = altColor end
					if ItemListsDB.displayOS and smallestPrio.is_offspec == 1 then OSText = "-OS" end
					prioListString = prioListString .. classColorsTable[ smallestPrio.character_class ]  .. smallestPrio.character_name .. altStatus .. "[" .. smallestPrio.sort_order .. OSText .. "]\124r" .. noteHolder .. linebreaker
				end
	
				optionalString = ""
				if totalHiddenPrios-totalReceivedPrios > 0 then 
					optionalString = optionalString .. totalHiddenPrios-totalReceivedPrios .. " Hidden "
				end
				if totalReceivedPrios > 0 then
					optionalString = optionalString .. totalReceivedPrios .. " Received "
				end
				if optionalString ~= "" then 
					tt:AddLine("\124cFFFF8000" .. "Prios: ( ".. optionalString .. ")" )	
				else
					tt:AddLine("\124cFFFF8000" .. "Prios:")
				end	
				tt:AddLine( prioListString )
			end
		end

		if ItemListsDB.forceReceivedList == true then
			recievedLogic(itemNotes,tt)
		end

	else 
		recievedLogic(itemNotes,tt)
	end
end

function recievedLogic(inputData,tt)
	local itemReceived = inputData.received
	local receivedString = ""

	if itemReceived ~= nil then
		tt:AddLine("Received item:")
		-- Construct the string to be displayed
		for k,v in pairs(itemReceived) do
			if k > ItemListsDB.maxNames then break end
			local altStatus = ""
			if ItemListsDB.displayAlts and v.character_is_alt == 1 then altStatus = "[Alt]" end
			local OSText = ""
			if ItemListsDB.displayOS and v.is_offspec == 1 then OSText = "\124cFFFFFFFF[OS]" end

			receivedString = receivedString .. altStatus.. OSText .. classColorsTable[ v.character_class ] .. v.character_name .. " "
		end
		tt:AddLine( receivedString )
	end
end


-- //TODO: Affects more than the static item frame. Need to look into this later
--[[ ChatFrame_OnHyperlinkShow = function(...) -- Hook into the static item info window, not the tooltip.
    local chatFrame, link, text, button = ...
    local result = origChatFrame_OnHyperlinkShow(...)
    
        ShowUIPanel(ItemRefTooltip)
        if (not ItemRefTooltip:IsVisible()) then
            ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
        end
        
       	ModifyItemTooltip(ItemRefTooltip)

        ItemRefTooltip:Show(); ItemRefTooltip:Show()

    --return result
end ]]



local function InitFrame() --Starts the listener for tooltips
	GameTooltip:HookScript( "OnTooltipSetItem", ModifyItemTooltip )
	
end

function ParseText(input)
	if input == nil then return "NoData" end
	local headers = {
	--All export
		"type,raid_group_name,member_name,character_name,character_class,character_is_alt,character_inactive_at,character_note,sort_order,item_name,item_id,is_offspec,note,received_at,import_id,item_note,item_prio_note,item_tier,item_tier_label,created_at,updated_at,",
	-- Tailored tmb export
		"type,character_name,character_class,character_is_alt,character_inactive_at,character_note,sort_order,item_id,is_offspec,received_at,item_prio_note,item_tier_label," 
	}


	local parsedLines = {}
	local parsedEntries = {}
	
	for line in input:gmatch("([^\n]*)\n?") do -- Extract the lines into seperate entries in an array.
		table.insert(parsedLines, line..",")
	end
	if (not(parsedLines[1] == headers[1] or parsedLines[1] == headers[2])) then return "Wrong CSV header" end -- Validate the header
	
	local headerData = {}
	for lineKey,line in pairs(parsedLines) do
		entry = {}
		if lineKey == 1 then
			headerData = ParseCSVLine(parsedLines[lineKey])
		else
			for key,value in pairs(ParseCSVLine(line)) do
				if key == 1 and value == "item_note" then
				end
				entry[ headerData[key] ] = value
			end
			table.insert(parsedEntries, entry)
		end
	end
	table.remove(parsedEntries) -- Pop of the malformed last entry.
	local noteTable = {}
	

	for k,e in pairs(parsedEntries) do
		local tempTable = {}
		local tempCharTable = {}
		local checkToken = {}
		local currentItemID = nil
		if e.character_inactive_at == "" then
			currentItemID = tonumber(e.item_id)
			checkToken = tokens[currentItemID]  
			if checkToken ~= nil then currentItemID = checkToken end
			tempTable = noteTable[ currentItemID ] --Try and load the item element
			if tempTable == nil then noteTable[ currentItemID ] = {} end -- Make an array because this is the first time the item is seen

			if e.received_at ~= "" then 
				e.type = "received"
			end

			if e.type == "wishlist" then
				tempCharTable.character_class = classToID[e.character_class]
				tempCharTable.character_name = e.character_name
				tempCharTable.sort_order = tonumber(e.sort_order)
				tempCharTable.character_is_alt = tonumber(e.character_is_alt)
				tempCharTable.is_offspec = tonumber(e.is_offspec)
				if ItemListsDB.showMemberNotes then
					tempCharTable.character_note = e.character_note
				end

				if tempTable ~= nil then tempTable = tempTable.wishlist end -- Look at the wishlist element if it exist then load it
				if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
					tempTable = {}
					table.insert(tempTable,tempCharTable)
				else -- Else insert it into the old one before saving.
					table.insert(tempTable,tempCharTable)
				end
				noteTable[currentItemID].wishlist = tempTable
			elseif e.type == "prio" then
				tempCharTable.character_class = classToID[e.character_class]
				tempCharTable.character_name = e.character_name
				tempCharTable.sort_order = tonumber(e.sort_order)
				tempCharTable.character_is_alt = tonumber(e.character_is_alt)
				tempCharTable.is_offspec = tonumber(e.is_offspec)
				if ItemListsDB.showMemberNotes then
					tempCharTable.character_note = e.character_note
				end

				if tempTable ~= nil then tempTable = tempTable.priolist end -- Look at the priolist element if it exist then load it
				if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
					tempTable = {}
					table.insert(tempTable,tempCharTable)
				else -- Else insert it into the old one before saving.
					table.insert(tempTable,tempCharTable)
				end
				noteTable[currentItemID].priolist = tempTable
			elseif e.type == "received" then 
				local skip = false
				if noteTable[currentItemID].received ~= nil then
					-- Search the array to check for duplicates
					for reKey,reEnt in pairs(noteTable[currentItemID].received) do
						if reEnt.character_name == e.character_name then
							skip = true
							break
						end
					end
				end
				if not skip then 
					tempCharTable.character_class = classToID[e.character_class]
					tempCharTable.character_name = e.character_name
					tempCharTable.character_is_alt = tonumber(e.character_is_alt)
					tempCharTable.is_offspec = tonumber(e.is_offspec)

					if tempTable ~= nil then tempTable = tempTable.received end -- Look at the recieved element if it exist then load it
					if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
						tempTable = {}
						table.insert(tempTable,tempCharTable)
					else -- Else insert it into the old one before saving.
						table.insert(tempTable,tempCharTable)
					end
					noteTable[currentItemID].received = tempTable
				end
			elseif e.type == "item_note" then 
				noteTable[currentItemID].prioNote = e.item_prio_note
				noteTable[currentItemID].guildNote = e.item_note
				noteTable[currentItemID].rank = e.item_tier_label
			end

		end
		 -- 
	end
	local checksum = ""
	local serializedTable = LibAceSerializer:Serialize(noteTable)
	checksum = libc:fcs16init()
	checksum = libc:fcs16update(checksum,serializedTable)
	checksum = libc:fcs16final(checksum)
	ThatsMyBis:Print("Added data: "..checksum)
	noteTable["ID"] = checksum
	ItemListsDB["itemNotes"] = noteTable -- Add it to peristent storage
	
	return "Success, data saved"
	end

function ParseCSVLine (line,sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(line,'^%b""',pos)
				txt = txt..string.sub(line,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(line,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then temp it
				-- this is the way to "escape" the quote char in a quote. example:
				--   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(line,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(line,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(line,pos))
				break
			end 
		end
	end
	return res
end

function ThatsMyBis:OnCommReceived(prefix, serializedMsg, distri, sender)
	if prefix == "TMBSync" then
		if sender ~= currentPlayer then 
			if syncShown then 
				local decompress = libc:Decompress(serializedMsg)
				local valid, command, data = LibAceSerializer:Deserialize(decompress)
				if valid then
					if command == "INFO" then
						ThatsMyBis:Print(data)
						syncFrame:SetStatusText("Ready")
					elseif command == "RTS" then
						--Someone is asking if we're ready to recieve, check their id against ours.
						if ItemListsDB.itemNotes.ID == data then
							ThatsMyBis:SendComm(sender,"INFO", currentPlayer .. " already have this data")
						else
							ThatsMyBis:SendComm(sender,"RTR","Please donate if you like this addon") 
						end
					elseif command == "RTR" then
						--Sender is ready to recieve, Transmit data.
						ThatsMyBis:Print("Sending data to " .. sender)
						ThatsMyBis:SendComm(sender, "INFO", "You are about to receive TMB data from ".. currentPlayer)
						ThatsMyBis:SendComm(sender, "DBID", ItemListsDB.itemNotes.ID)
						ThatsMyBis:SendComm(sender, "TABLES", ItemListsDB.itemNotes)

					elseif command == "TABLES" then
						ItemListsDB.itemNotes = data
						ThatsMyBis:Print("ID " .. ItemListsDB.itemNotes.ID .. " have been imported, remember to exit the game gracefully or reload to save it.")
						ThatsMyBis:SendComm(sender, "INFO", currentPlayer .. " is now on ID " .. ItemListsDB.itemNotes.ID )
					elseif command == "DBID" then
						ItemListsDB.itemNotes.ID = data
						
					end
				else
					ThatsMyBis:Print("Received invalid data, make sure you're all running the latest version.")
				end
			else
				ThatsMyBis:Print(sender .." is trying to send you data, however sync window is not open. Do /tmb sync and have them re-send")
				ThatsMyBis:SendComm(sender,"INFO", currentPlayer .." does not have sync window open. Try again")
			end
		end
	end
end

function ThatsMyBis:SendComm(target, command, data )
    local serialized = nil
    if data then
        serialized = LibAceSerializer:Serialize(command, data)
		compressed = libc:Compress(serialized)
	end
	if target == "PARTY" then 
		ThatsMyBis:SendCommMessage("TMBSync", compressed, target, "BULK",ThatsMyBis.commCallback)
	elseif target == "RAID" then 
		ThatsMyBis:SendCommMessage("TMBSync", compressed, target, "BULK",ThatsMyBis.commCallback)
	elseif target == "GUILD" then 
		ThatsMyBis:SendCommMessage("TMBSync", compressed, target, "BULK",ThatsMyBis.commCallback)
	else 
		ThatsMyBis:SendCommMessage("TMBSync", compressed, "WHISPER", target, "BULK",ThatsMyBis.commCallback)
	end
    
end

function ThatsMyBis:commCallback(num,total) 
	--syncFrame:SetStatusText("Sending: ".. math.floor(tonumber(num)/1000) .. " of ".. math.floor(tonumber(total)/1000) .. " total")
	syncFrame:SetStatusText("Sending: ".. math.floor(tonumber(num)/tonumber(total)*100).."%")
	--ThatsMyBis:Print(num,total)
end

function ParseItemIdOrLink(item_link_or_id)
	local itemName, itemLink, quality, _, _, class, subclass, _, equipSlot, texture, _, ClassID, SubClassID = GetItemInfo(item_link_or_id)
	if itemLink then
		--local itemName = string.sub(string.match(itemLink,"%[.+%]"), 2, -2)
		local itemString = string.match(itemLink, "item[%-?%d:]+");
		local itemId=string.match(itemString,"%d+");		
		return itemId,itemName,quality
	else
		return nil
	end
end




tokens = {
	[35751]=30183,
	[30038]=30183,
	[30040]=30183,
	[30042]=30183,
	[30046]=30183,
	[30034]=30183,
	[30036]=30183,
	[28427]=30183,
	[28436]=30183,
	[28485]=30183,
	[28439]=30183,
	[23565]=30183,
	[35748]=30183,
	[28430]=30183,
	[30044]=30183,
	[30032]=30183,
	[35750]=30183,
	[35749]=30183,
	[28442]=30183,
	[28433]=30183,
	[18406]=18422,
	[18403]=18422,
	[18404]=18422,
	[19383]=19002,
	[19366]=19002,
	[19384]=19002,
	[19827]=19716,
	[19846]=19716,
	[19833]=19716,
	[19830]=19717,
	[19836]=19717,
	[19824]=19717,
	[19843]=19718,
	[19848]=19718,
	[19840]=19718,
	[19829]=19719,
	[19835]=19719,
	[19823]=19719,
	[19842]=19720,
	[19849]=19720,
	[19839]=19720,
	[19826]=19721,
	[19845]=19721,
	[19832]=19721,
	[19828]=19722,
	[19825]=19722,
	[19838]=19722,
	[20033]=19723,
	[20034]=19723,
	[19822]=19723,
	[19841]=19724,
	[19834]=19724,
	[19831]=19724,
	[19948]=19802,
	[19950]=19802,
	[19949]=19802,
	[21408]=20884,
	[21414]=20884,
	[21396]=20884,
	[21399]=20884,
	[21393]=20884,
	[21406]=20885,
	[21394]=20885,
	[21415]=20885,
	[21412]=20885,
	[21395]=20886,
	[21404]=20886,
	[21398]=20886,
	[21401]=20886,
	[21392]=20886,
	[21405]=20888,
	[21411]=20888,
	[21417]=20888,
	[21402]=20888,
	[21397]=20889,
	[21400]=20889,
	[21403]=20889,
	[21409]=20889,
	[21418]=20889,
	[21413]=20890,
	[21410]=20890,
	[21416]=20890,
	[21407]=20890,
	[21329]=20926,
	[21337]=20926,
	[21347]=20926,
	[21348]=20926,
	[21332]=20927,
	[21362]=20927,
	[21346]=20927,
	[21352]=20927,
	[21333]=20928,
	[21330]=20928,
	[21359]=20928,
	[21361]=20928,
	[21349]=20928,
	[21350]=20928,
	[21365]=20928,
	[21367]=20928,
	[21389]=20929,
	[21331]=20929,
	[21364]=20929,
	[21374]=20929,
	[21370]=20929,
	[21387]=20930,
	[21360]=20930,
	[21353]=20930,
	[21372]=20930,
	[21366]=20930,
	[21390]=20931,
	[21336]=20931,
	[21356]=20931,
	[21375]=20931,
	[21368]=20931,
	[21388]=20932,
	[21391]=20932,
	[21338]=20932,
	[21335]=20932,
	[21344]=20932,
	[21345]=20932,
	[21355]=20932,
	[21354]=20932,
	[21373]=20932,
	[21376]=20932,
	[21334]=20933,
	[21343]=20933,
	[21357]=20933,
	[21351]=20933,
	[21504]=21220,
	[21507]=21220,
	[21505]=21220,
	[21506]=21220,
	[21712]=21221,
	[21710]=21221,
	[21709]=21221,
	[22477]=22352,
	[22417]=22352,
	[22478]=22353,
	[22418]=22353,
	[22479]=22354,
	[22419]=22354,
	[22483]=22355,
	[22423]=22355,
	[22482]=22356,
	[22422]=22356,
	[22481]=22357,
	[22421]=22357,
	[22480]=22358,
	[22420]=22358,
	[22437]=22359,
	[22489]=22359,
	[22465]=22359,
	[22427]=22359,
	[22438]=22360,
	[22490]=22360,
	[22466]=22360,
	[22428]=22360,
	[22439]=22361,
	[22491]=22361,
	[22467]=22361,
	[22429]=22361,
	[22443]=22362,
	[22495]=22362,
	[22471]=22362,
	[22424]=22362,
	[22442]=22363,
	[22494]=22363,
	[22470]=22363,
	[22431]=22363,
	[22441]=22364,
	[22493]=22364,
	[22469]=22364,
	[22426]=22364,
	[22440]=22365,
	[22492]=22365,
	[22468]=22365,
	[22430]=22365,
	[22497]=22366,
	[22513]=22366,
	[22505]=22366,
	[22514]=22367,
	[22498]=22367,
	[22506]=22367,
	[22499]=22368,
	[22507]=22368,
	[22515]=22368,
	[22519]=22369,
	[22503]=22369,
	[22511]=22369,
	[22518]=22370,
	[22502]=22370,
	[22510]=22370,
	[22501]=22371,
	[22517]=22371,
	[22509]=22371,
	[22500]=22372,
	[22508]=22372,
	[22516]=22372,
	[23206]=22520,
	[23207]=22520,
	[29096]=29753,
	[29087]=29753,
	[29091]=29753,
	[29050]=29753,
	[29056]=29753,
	[29012]=29753,
	[29019]=29753,
	[29066]=29754,
	[29071]=29754,
	[29062]=29754,
	[29045]=29754,
	[29038]=29754,
	[29029]=29754,
	[29033]=29754,
	[29082]=29755,
	[29077]=29755,
	[28964]=29755,
	[29085]=29756,
	[29080]=29756,
	[28968]=29756,
	[29067]=29757,
	[29072]=29757,
	[29065]=29757,
	[29048]=29757,
	[29039]=29757,
	[29032]=29757,
	[29034]=29757,
	[29097]=29758,
	[29090]=29758,
	[29092]=29758,
	[29055]=29758,
	[29057]=29758,
	[29020]=29758,
	[29017]=29758,
	[29081]=29759,
	[29076]=29759,
	[28963]=29759,
	[29068]=29760,
	[29073]=29760,
	[29061]=29760,
	[29044]=29760,
	[29035]=29760,
	[29028]=29760,
	[29040]=29760,
	[29098]=29761,
	[29086]=29761,
	[29093]=29761,
	[29049]=29761,
	[29058]=29761,
	[29011]=29761,
	[29021]=29761,
	[29084]=29762,
	[29079]=29762,
	[28967]=29762,
	[29070]=29763,
	[29075]=29763,
	[29064]=29763,
	[29047]=29763,
	[29043]=29763,
	[29031]=29763,
	[29037]=29763,
	[29100]=29764,
	[29089]=29764,
	[29095]=29764,
	[29054]=29764,
	[29060]=29764,
	[29016]=29764,
	[29023]=29764,
	[29083]=29765,
	[29078]=29765,
	[28966]=29765,
	[29069]=29766,
	[29074]=29766,
	[29063]=29766,
	[29046]=29766,
	[29036]=29766,
	[29030]=29766,
	[29042]=29766,
	[29099]=29767,
	[29088]=29767,
	[29094]=29767,
	[29059]=29767,
	[29053]=29767,
	[29015]=29767,
	[29022]=29767,
	[30123]=30236,
	[30129]=30236,
	[30134]=30236,
	[30144]=30236,
	[30185]=30236,
	[30164]=30236,
	[30169]=30236,
	[30222]=30237,
	[30216]=30237,
	[30231]=30237,
	[30150]=30237,
	[30159]=30237,
	[30113]=30237,
	[30118]=30237,
	[30139]=30238,
	[30196]=30238,
	[30214]=30238,
	[30124]=30239,
	[30130]=30239,
	[30135]=30239,
	[30145]=30239,
	[30189]=30239,
	[30165]=30239,
	[30170]=30239,
	[30223]=30240,
	[30217]=30240,
	[30232]=30240,
	[30151]=30240,
	[30160]=30240,
	[30114]=30240,
	[30119]=30240,
	[30140]=30241,
	[30205]=30241,
	[30211]=30241,
	[30125]=30242,
	[30131]=30242,
	[30136]=30242,
	[30146]=30242,
	[30190]=30242,
	[30166]=30242,
	[30171]=30242,
	[30233]=30243,
	[30219]=30243,
	[30228]=30243,
	[30152]=30243,
	[30161]=30243,
	[30115]=30243,
	[30120]=30243,
	[30141]=30244,
	[30206]=30244,
	[30212]=30244,
	[30126]=30245,
	[30132]=30245,
	[30137]=30245,
	[30148]=30245,
	[30192]=30245,
	[30167]=30245,
	[30172]=30245,
	[30229]=30246,
	[30220]=30246,
	[30234]=30246,
	[30153]=30246,
	[30162]=30246,
	[30116]=30246,
	[30121]=30246,
	[30142]=30247,
	[30207]=30247,
	[30213]=30247,
	[30127]=30248,
	[30133]=30248,
	[30138]=30248,
	[30149]=30248,
	[30194]=30248,
	[30168]=30248,
	[30173]=30248,
	[30230]=30249,
	[30221]=30249,
	[30235]=30249,
	[30154]=30249,
	[30163]=30249,
	[30117]=30249,
	[30122]=30249,
	[30143]=30250,
	[30210]=30250,
	[30215]=30250,
	[30991]=31089,
	[30990]=31089,
	[30992]=31089,
	[31065]=31089,
	[31066]=31089,
	[31052]=31089,
	[31042]=31090,
	[31041]=31090,
	[31043]=31090,
	[31057]=31090,
	[31028]=31090,
	[31004]=31091,
	[31018]=31091,
	[31016]=31091,
	[31017]=31091,
	[30976]=31091,
	[30975]=31091,
	[30985]=31092,
	[30982]=31092,
	[30983]=31092,
	[31061]=31092,
	[31060]=31092,
	[31050]=31092,
	[31034]=31093,
	[31032]=31093,
	[31035]=31093,
	[31055]=31093,
	[31026]=31093,
	[31001]=31094,
	[31011]=31094,
	[31007]=31094,
	[31008]=31094,
	[30970]=31094,
	[30969]=31094,
	[31003]=31095,
	[31015]=31095,
	[31012]=31095,
	[31014]=31095,
	[30974]=31095,
	[30972]=31095,
	[31039]=31096,
	[31037]=31096,
	[31040]=31096,
	[31056]=31096,
	[31027]=31096,
	[30987]=31097,
	[30989]=31097,
	[30988]=31097,
	[31064]=31097,
	[31063]=31097,
	[31051]=31097,
	[30995]=31098,
	[30993]=31098,
	[30994]=31098,
	[31067]=31098,
	[31068]=31098,
	[31053]=31098,
	[31044]=31099,
	[31045]=31099,
	[31046]=31099,
	[31058]=31099,
	[31029]=31099,
	[31005]=31100,
	[31021]=31100,
	[31019]=31100,
	[31020]=31100,
	[30978]=31100,
	[30977]=31100,
	[30998]=31101,
	[30997]=31101,
	[30996]=31101,
	[31070]=31101,
	[31069]=31101,
	[31054]=31101,
	[31048]=31102,
	[31047]=31102,
	[31049]=31102,
	[31059]=31102,
	[31030]=31102,
	[31006]=31103,
	[31024]=31103,
	[31022]=31103,
	[31023]=31103,
	[30980]=31103,
	[30979]=31103,
	[28792]=32385,
	[28793]=32385,
	[28790]=32385,
	[28791]=32385,
	[30015]=32405,
	[30007]=32405,
	[30018]=32405,
	[30017]=32405,
	[34433]=34848,
	[34431]=34848,
	[34432]=34848,
	[34434]=34848,
	[34435]=34848,
	[34436]=34848,
	[34443]=34851,
	[34437]=34851,
	[34438]=34851,
	[34439]=34851,
	[34442]=34851,
	[34441]=34851,
	[34444]=34852,
	[34445]=34852,
	[34446]=34852,
	[34447]=34852,
	[34448]=34852,
	[34488]=34853,
	[34485]=34853,
	[34487]=34853,
	[34528]=34853,
	[34527]=34853,
	[34541]=34853,
	[34549]=34854,
	[34545]=34854,
	[34543]=34854,
	[34542]=34854,
	[34547]=34854,
	[34546]=34854,
	[34556]=34855,
	[34554]=34855,
	[34555]=34855,
	[34557]=34855,
	[34558]=34855,
	[34560]=34856,
	[34561]=34856,
	[34559]=34856,
	[34563]=34856,
	[34562]=34856,
	[34564]=34856,
	[34570]=34857,
	[34566]=34857,
	[34565]=34857,
	[34567]=34857,
	[34568]=34857,
	[34569]=34857,
	[34573]=34858,
	[34571]=34858,
	[34572]=34858,
	[34574]=34858,
	[34405]=34339,
	[34406]=34342,
	[34402]=34332,
	[34392]=34195,
	[34403]=34245,
	[34381]=34180,
	[34393]=34202,
	[34404]=34244,
	[34382]=34167,
	[34394]=34215,
	[34383]=34186,
	[34395]=34216,
	[34384]=34169,
	[34396]=34229,
	[34385]=34188,
	[34397]=34211,
	[34408]=34234,
	[34386]=34170,
	[34398]=34212,
	[34409]=34350,
	[34388]=34192,
	[34399]=34233,
	[34389]=34193,
	[34400]=34345,
	[34390]=34208,
	[34401]=34243,
	[34391]=34209,
	[34407]=34351,
	[34575]=34858,
	[40423]=40625,
	[40458]=40625,
	[40579]=40625,
	[40574]=40625,
	[40569]=40625,
	[40449]=40625,
	[40503]=40626,
	[40525]=40626,
	[40544]=40626,
	[40523]=40626,
	[40514]=40626,
	[40508]=40626,
	[40495]=40627,
	[40471]=40627,
	[40463]=40627,
	[40469]=40627,
	[40418]=40627,
	[40550]=40627,
	[40559]=40627,
	[46154]=45632,
	[46173]=45632,
	[46178]=45632,
	[46137]=45632,
	[46168]=45632,
	[46193]=45632,
	[46141]=45633,
	[46146]=45633,
	[46162]=45633,
	[46205]=45633,
	[46206]=45633,
	[46198]=45633,
	[46111]=45634,
	[46118]=45634,
	[46130]=45634,
	[46159]=45634,
	[46186]=45634,
	[46194]=45634,
	[46123]=45634,
	[39497]=40610,
	[39523]=40610,
	[39638]=40610,
	[39633]=40610,
	[39629]=40610,
	[39515]=40610,
	[39579]=40611,
	[39606]=40611,
	[39611]=40611,
	[39597]=40611,
	[39592]=40611,
	[39588]=40611,
	[39558]=40612,
	[39554]=40612,
	[39538]=40612,
	[39547]=40612,
	[39492]=40612,
	[39617]=40612,
	[39623]=40612,
	[45375]=45635,
	[45381]=45635,
	[45374]=45635,
	[45421]=45635,
	[45395]=45635,
	[45389]=45635,
	[45364]=45636,
	[45429]=45636,
	[45424]=45636,
	[45413]=45636,
	[45411]=45636,
	[45405]=45636,
	[45340]=45637,
	[45335]=45637,
	[45368]=45637,
	[45358]=45637,
	[45348]=45637,
	[45354]=45637,
	[45396]=45637,
	[51175]=52027,
	[51170]=52027,
	[51176]=52027,
	[51165]=52027,
	[51171]=52027,
	[51177]=52027,
	[51166]=52027,
	[51172]=52027,
	[51178]=52027,
	[51167]=52027,
	[51173]=52027,
	[51179]=52027,
	[51168]=52027,
	[51174]=52027,
	[51180]=52027,
	[51169]=52027,
	[51205]=52027,
	[51181]=52027,
	[51160]=52027,
	[51206]=52027,
	[51182]=52027,
	[51161]=52027,
	[51207]=52027,
	[51183]=52027,
	[51162]=52027,
	[51208]=52027,
	[51184]=52027,
	[51163]=52027,
	[51209]=52027,
	[51164]=52027,
	[51255]=52030,
	[51260]=52030,
	[51256]=52030,
	[51261]=52030,
	[51262]=52030,
	[51257]=52030,
	[51258]=52030,
	[51259]=52030,
	[51263]=52030,
	[51264]=52030,
	[51230]=52030,
	[51231]=52030,
	[51232]=52030,
	[51233]=52030,
	[51234]=52030,
	[51275]=52030,
	[51265]=52030,
	[51266]=52030,
	[51276]=52030,
	[51270]=52030,
	[51271]=52030,
	[51267]=52030,
	[51272]=52030,
	[51277]=52030,
	[51268]=52030,
	[51278]=52030,
	[51269]=52030,
	[51279]=52030,
	[51273]=52030,
	[51274]=52030,
	[40456]=40631,
	[40447]=40631,
	[40421]=40631,
	[40581]=40631,
	[40571]=40631,
	[40576]=40631,
	[40505]=40632,
	[40546]=40632,
	[40528]=40632,
	[40521]=40632,
	[40510]=40632,
	[40516]=40632,
	[40499]=40633,
	[40467]=40633,
	[40473]=40633,
	[40461]=40633,
	[40416]=40633,
	[40565]=40633,
	[40554]=40633,
	[46175]=45638,
	[46180]=45638,
	[46156]=45638,
	[46172]=45638,
	[46197]=45638,
	[46140]=45638,
	[46143]=45639,
	[46166]=45639,
	[46151]=45639,
	[46212]=45639,
	[46201]=45639,
	[46209]=45639,
	[46120]=45640,
	[46115]=45640,
	[46129]=45640,
	[46191]=45640,
	[46161]=45640,
	[46184]=45640,
	[46125]=45640,
	[40445]=40628,
	[40454]=40628,
	[40420]=40628,
	[40575]=40628,
	[40570]=40628,
	[40580]=40628,
	[40504]=40629,
	[40527]=40629,
	[40545]=40629,
	[40515]=40629,
	[40520]=40629,
	[40509]=40629,
	[40496]=40630,
	[40466]=40630,
	[40472]=40630,
	[40460]=40630,
	[40415]=40630,
	[40552]=40630,
	[40563]=40630,
	[46155]=45641,
	[46179]=45641,
	[46174]=45641,
	[46135]=45641,
	[46188]=45641,
	[46163]=45641,
	[46142]=45642,
	[46148]=45642,
	[46164]=45642,
	[46207]=45642,
	[46200]=45642,
	[46199]=45642,
	[46113]=45643,
	[46119]=45643,
	[46132]=45643,
	[46189]=45643,
	[46158]=45643,
	[46183]=45643,
	[46124]=45643,
	[39519]=40613,
	[39530]=40613,
	[39500]=40613,
	[39634]=40613,
	[39632]=40613,
	[39639]=40613,
	[39582]=40614,
	[39609]=40614,
	[39622]=40614,
	[39593]=40614,
	[39601]=40614,
	[39591]=40614,
	[39560]=40615,
	[39544]=40615,
	[39557]=40615,
	[39543]=40615,
	[39495]=40615,
	[39618]=40615,
	[39624]=40615,
	[45376]=45644,
	[45370]=45644,
	[45383]=45644,
	[45419]=45644,
	[45387]=45644,
	[45392]=45644,
	[45360]=45645,
	[45430]=45645,
	[45426]=45645,
	[45406]=45645,
	[45414]=45645,
	[45401]=45645,
	[45341]=45646,
	[45337]=45646,
	[46131]=45646,
	[45351]=45646,
	[45355]=45646,
	[45345]=45646,
	[45397]=45646,
	[39521]=40616,
	[39514]=40616,
	[39496]=40616,
	[39640]=40616,
	[39628]=40616,
	[39635]=40616,
	[39578]=40617,
	[39610]=40617,
	[39605]=40617,
	[39602]=40617,
	[39583]=40617,
	[39594]=40617,
	[39561]=40618,
	[39545]=40618,
	[39553]=40618,
	[39531]=40618,
	[39491]=40618,
	[39625]=40618,
	[39619]=40618,
	[45382]=45647,
	[45372]=45647,
	[45377]=45647,
	[45391]=45647,
	[45386]=45647,
	[45417]=45647,
	[45361]=45648,
	[45425]=45648,
	[45431]=45648,
	[45412]=45648,
	[45402]=45648,
	[45408]=45648,
	[45336]=45649,
	[45342]=45649,
	[45365]=45649,
	[46313]=45649,
	[45356]=45649,
	[45346]=45649,
	[45398]=45649,
	[39517]=40619,
	[39528]=40619,
	[39498]=40619,
	[39630]=40619,
	[39641]=40619,
	[39636]=40619,
	[39580]=40620,
	[39612]=40620,
	[39607]=40620,
	[39595]=40620,
	[39589]=40620,
	[39603]=40620,
	[39564]=40621,
	[39539]=40621,
	[39555]=40621,
	[39546]=40621,
	[39493]=40621,
	[39626]=40621,
	[39620]=40621,
	[45371]=45650,
	[45384]=45650,
	[45379]=45650,
	[45420]=45650,
	[45388]=45650,
	[45394]=45650,
	[45362]=45651,
	[45427]=45651,
	[45432]=45651,
	[45409]=45651,
	[45403]=45651,
	[45416]=45651,
	[45338]=45652,
	[45343]=45652,
	[45367]=45652,
	[45347]=45652,
	[45357]=45652,
	[45353]=45652,
	[45399]=45652,
	[40448]=40634,
	[40457]=40634,
	[40422]=40634,
	[40572]=40634,
	[40583]=40634,
	[40577]=40634,
	[40506]=40635,
	[40547]=40635,
	[40529]=40635,
	[40517]=40635,
	[40512]=40635,
	[40522]=40635,
	[40500]=40636,
	[40462]=40636,
	[40493]=40636,
	[40468]=40636,
	[40417]=40636,
	[40567]=40636,
	[40556]=40636,
	[46181]=45653,
	[46176]=45653,
	[46153]=45653,
	[46139]=45653,
	[46195]=45653,
	[46170]=45653,
	[46144]=45654,
	[46169]=45654,
	[46150]=45654,
	[46210]=45654,
	[46202]=45654,
	[46208]=45654,
	[46121]=45655,
	[46116]=45655,
	[46133]=45655,
	[46185]=45655,
	[46160]=45655,
	[46192]=45655,
	[46126]=45655,
	[40459]=40637,
	[40424]=40637,
	[40584]=40637,
	[40578]=40637,
	[40573]=40637,
	[40450]=40637,
	[40507]=40638,
	[40548]=40638,
	[40530]=40638,
	[40524]=40638,
	[40518]=40638,
	[40513]=40638,
	[40502]=40639,
	[40470]=40639,
	[40494]=40639,
	[40465]=40639,
	[40419]=40639,
	[40568]=40639,
	[40557]=40639,
	[46177]=45656,
	[46152]=45656,
	[46182]=45656,
	[46136]=45656,
	[46165]=45656,
	[46190]=45656,
	[46145]=45657,
	[46167]=45657,
	[46149]=45657,
	[46203]=45657,
	[46211]=45657,
	[46204]=45657,
	[46122]=45658,
	[46117]=45658,
	[46134]=45658,
	[46196]=45658,
	[46157]=45658,
	[46187]=45658,
	[46127]=45658,
	[51154]=52026,
	[51153]=52026,
	[51152]=52026,
	[51151]=52026,
	[51150]=52026,
	[51195]=52026,
	[51197]=52026,
	[51201]=52026,
	[51196]=52026,
	[51191]=52026,
	[51200]=52026,
	[51192]=52026,
	[51202]=52026,
	[51203]=52026,
	[51193]=52026,
	[51199]=52026,
	[51204]=52026,
	[51194]=52026,
	[51190]=52026,
	[51198]=52026,
	[51214]=52026,
	[51219]=52026,
	[51213]=52026,
	[51218]=52026,
	[51217]=52026,
	[51212]=52026,
	[51216]=52026,
	[51211]=52026,
	[51215]=52026,
	[51210]=52026,
	[51285]=52029,
	[51286]=52029,
	[51287]=52029,
	[51288]=52029,
	[51289]=52029,
	[51244]=52029,
	[51242]=52029,
	[51238]=52029,
	[51243]=52029,
	[51248]=52029,
	[51239]=52029,
	[51247]=52029,
	[51237]=52029,
	[51236]=52029,
	[51246]=52029,
	[51240]=52029,
	[51235]=52029,
	[51245]=52029,
	[51249]=52029,
	[51241]=52029,
	[51225]=52029,
	[51220]=52029,
	[51226]=52029,
	[51221]=52029,
	[51222]=52029,
	[51227]=52029,
	[51223]=52029,
	[51228]=52029,
	[51224]=52029,
	[51229]=52029,
	[47797]=47557,
	[47796]=47557,
	[47795]=47557,
	[47794]=47557,
	[47793]=47557,
	[47788]=47557,
	[47789]=47557,
	[47790]=47557,
	[47791]=47557,
	[47792]=47557,
	[48617]=47557,
	[48651]=47557,
	[48649]=47557,
	[48618]=47557,
	[48588]=47557,
	[48586]=47557,
	[48650]=47557,
	[48587]=47557,
	[48619]=47557,
	[48648]=47557,
	[48620]=47557,
	[48647]=47557,
	[48621]=47557,
	[48585]=47557,
	[48589]=47557,
	[48616]=47557,
	[48642]=47557,
	[48644]=47557,
	[48615]=47557,
	[48583]=47557,
	[48581]=47557,
	[48643]=47557,
	[48582]=47557,
	[48614]=47557,
	[48645]=47557,
	[48613]=47557,
	[48646]=47557,
	[48612]=47557,
	[48580]=47557,
	[48584]=47557,
	[48085]=47557,
	[48035]=47557,
	[48037]=47557,
	[48086]=47557,
	[48033]=47557,
	[48082]=47557,
	[48084]=47557,
	[48083]=47557,
	[48031]=47557,
	[48029]=47557,
	[48088]=47557,
	[48058]=47557,
	[48057]=47557,
	[48087]=47557,
	[48059]=47557,
	[48091]=47557,
	[48089]=47557,
	[48090]=47557,
	[48060]=47557,
	[48061]=47557,
	[48396]=47558,
	[48466]=47558,
	[48397]=47558,
	[48468]=47558,
	[48467]=47558,
	[48398]=47558,
	[48469]=47558,
	[48399]=47558,
	[48470]=47558,
	[48400]=47558,
	[48355]=47558,
	[48353]=47558,
	[48324]=47558,
	[48354]=47558,
	[48293]=47558,
	[48325]=47558,
	[48292]=47558,
	[48323]=47558,
	[48322]=47558,
	[48291]=47558,
	[48351]=47558,
	[48321]=47558,
	[48290]=47558,
	[48294]=47558,
	[48352]=47558,
	[48356]=47558,
	[48358]=47558,
	[48327]=47558,
	[48357]=47558,
	[48306]=47558,
	[48326]=47558,
	[48307]=47558,
	[48328]=47558,
	[48329]=47558,
	[48308]=47558,
	[48360]=47558,
	[48330]=47558,
	[48309]=47558,
	[48305]=47558,
	[48359]=47558,
	[48266]=47558,
	[48263]=47558,
	[48267]=47558,
	[48262]=47558,
	[48261]=47558,
	[48268]=47558,
	[48260]=47558,
	[48269]=47558,
	[48264]=47558,
	[48265]=47558,
	[48385]=47558,
	[48451]=47558,
	[48384]=47558,
	[48433]=47558,
	[48453]=47558,
	[48383]=47558,
	[48447]=47558,
	[48382]=47558,
	[48455]=47558,
	[48381]=47558,
	[48233]=47559,
	[48234]=47559,
	[48235]=47559,
	[48236]=47559,
	[48237]=47559,
	[47762]=47559,
	[47761]=47559,
	[47760]=47559,
	[47759]=47559,
	[47758]=47559,
	[48491]=47559,
	[48548]=47559,
	[48550]=47559,
	[48492]=47559,
	[48549]=47559,
	[48493]=47559,
	[48551]=47559,
	[48494]=47559,
	[48552]=47559,
	[48495]=47559,
	[48171]=47559,
	[48172]=47559,
	[48203]=47559,
	[48142]=47559,
	[48204]=47559,
	[48141]=47559,
	[48140]=47559,
	[48205]=47559,
	[48168]=47559,
	[48206]=47559,
	[48139]=47559,
	[48207]=47559,
	[48138]=47559,
	[48170]=47559,
	[48169]=47559,
	[48174]=47559,
	[48173]=47559,
	[48202]=47559,
	[48143]=47559,
	[48201]=47559,
	[48144]=47559,
	[48145]=47559,
	[48200]=47559,
	[48177]=47559,
	[48199]=47559,
	[48146]=47559,
	[48198]=47559,
	[48147]=47559,
	[48175]=47559,
	[48176]=47559,
	[47763]=47559,
	[47764]=47559,
	[47765]=47559,
	[47766]=47559,
	[47767]=47559,
	[48490]=47559,
	[48547]=47559,
	[48545]=47559,
	[48489]=47559,
	[48546]=47559,
	[48488]=47559,
	[48544]=47559,
	[48487]=47559,
	[48543]=47559,
	[48486]=47559,
	[48232]=47559,
	[48231]=47559,
	[48230]=47559,
	[48229]=47559,
	[48228]=47559,
	[39529]=40622,
	[39499]=40622,
	[39642]=40622,
	[39637]=40622,
	[39631]=40622,
	[39518]=40622,
	[39581]=40623,
	[39613]=40623,
	[39608]=40623,
	[39604]=40623,
	[39596]=40623,
	[39590]=40623,
	[39565]=40624,
	[39548]=40624,
	[39556]=40624,
	[39542]=40624,
	[39494]=40624,
	[39627]=40624,
	[39621]=40624,
	[45385]=45659,
	[45380]=45659,
	[45373]=45659,
	[45422]=45659,
	[45393]=45659,
	[45390]=45659,
	[45363]=45660,
	[45428]=45660,
	[45433]=45660,
	[45415]=45660,
	[45410]=45660,
	[45404]=45660,
	[45339]=45661,
	[45344]=45661,
	[45369]=45661,
	[45352]=45661,
	[45359]=45661,
	[45349]=45661,
	[45400]=45661,
	[48242]=47242,
	[48241]=47242,
	[48240]=47242,
	[48239]=47242,
	[48238]=47242,
	[47803]=47242,
	[47804]=47242,
	[47805]=47242,
	[47806]=47242,
	[47807]=47242,
	[48391]=47242,
	[48461]=47242,
	[48392]=47242,
	[48463]=47242,
	[48462]=47242,
	[48393]=47242,
	[48464]=47242,
	[48394]=47242,
	[48465]=47242,
	[48395]=47242,
	[47782]=47242,
	[47778]=47242,
	[47780]=47242,
	[47779]=47242,
	[47781]=47242,
	[47753]=47242,
	[47754]=47242,
	[47755]=47242,
	[47756]=47242,
	[47757]=47242,
	[48500]=47242,
	[48557]=47242,
	[48555]=47242,
	[48499]=47242,
	[48556]=47242,
	[48498]=47242,
	[48554]=47242,
	[48497]=47242,
	[48553]=47242,
	[48496]=47242,
	[48626]=47242,
	[48657]=47242,
	[48659]=47242,
	[48625]=47242,
	[48593]=47242,
	[48591]=47242,
	[48658]=47242,
	[48592]=47242,
	[48624]=47242,
	[48660]=47242,
	[48623]=47242,
	[48661]=47242,
	[48622]=47242,
	[48590]=47242,
	[48594]=47242,
	[48164]=47242,
	[48163]=47242,
	[48212]=47242,
	[48133]=47242,
	[48211]=47242,
	[48134]=47242,
	[48135]=47242,
	[48210]=47242,
	[48167]=47242,
	[48209]=47242,
	[48136]=47242,
	[48208]=47242,
	[48137]=47242,
	[48165]=47242,
	[48166]=47242,
	[48346]=47242,
	[48348]=47242,
	[48317]=47242,
	[48347]=47242,
	[48286]=47242,
	[48316]=47242,
	[48287]=47242,
	[48318]=47242,
	[48319]=47242,
	[48288]=47242,
	[48350]=47242,
	[48320]=47242,
	[48289]=47242,
	[48285]=47242,
	[48349]=47242,
	[48181]=47242,
	[48182]=47242,
	[48193]=47242,
	[48152]=47242,
	[48194]=47242,
	[48151]=47242,
	[48150]=47242,
	[48195]=47242,
	[48178]=47242,
	[48196]=47242,
	[48149]=47242,
	[48197]=47242,
	[48148]=47242,
	[48180]=47242,
	[48179]=47242,
	[47772]=47242,
	[47771]=47242,
	[47770]=47242,
	[47769]=47242,
	[47768]=47242,
	[48481]=47242,
	[48538]=47242,
	[48540]=47242,
	[48482]=47242,
	[48539]=47242,
	[48483]=47242,
	[48541]=47242,
	[48484]=47242,
	[48542]=47242,
	[48485]=47242,
	[48365]=47242,
	[48363]=47242,
	[48334]=47242,
	[48364]=47242,
	[48301]=47242,
	[48335]=47242,
	[48302]=47242,
	[48333]=47242,
	[48332]=47242,
	[48303]=47242,
	[48361]=47242,
	[48331]=47242,
	[48304]=47242,
	[48300]=47242,
	[48362]=47242,
	[48607]=47242,
	[48641]=47242,
	[48639]=47242,
	[48608]=47242,
	[48576]=47242,
	[48578]=47242,
	[48640]=47242,
	[48577]=47242,
	[48609]=47242,
	[48638]=47242,
	[48610]=47242,
	[48637]=47242,
	[48611]=47242,
	[48579]=47242,
	[48575]=47242,
	[48223]=47242,
	[48224]=47242,
	[48225]=47242,
	[48226]=47242,
	[48227]=47242,
	[48078]=47242,
	[47984]=47242,
	[47983]=47242,
	[48077]=47242,
	[47985]=47242,
	[48081]=47242,
	[48079]=47242,
	[48080]=47242,
	[47986]=47242,
	[47987]=47242,
	[48273]=47242,
	[48256]=47242,
	[48257]=47242,
	[48272]=47242,
	[48258]=47242,
	[48271]=47242,
	[48259]=47242,
	[48270]=47242,
	[48274]=47242,
	[48255]=47242,
	[48376]=47242,
	[48450]=47242,
	[48377]=47242,
	[48430]=47242,
	[48452]=47242,
	[48378]=47242,
	[48446]=47242,
	[48379]=47242,
	[48454]=47242,
	[48380]=47242,
	[48095]=47242,
	[48065]=47242,
	[48066]=47242,
	[48096]=47242,
	[48064]=47242,
	[48092]=47242,
	[48094]=47242,
	[48093]=47242,
	[48063]=47242,
	[48062]=47242,
	[51159]=52025,
	[51158]=52025,
	[51157]=52025,
	[51156]=52025,
	[51155]=52025,
	[51149]=52025,
	[51138]=52025,
	[51148]=52025,
	[51144]=52025,
	[51143]=52025,
	[51137]=52025,
	[51142]=52025,
	[51136]=52025,
	[51147]=52025,
	[51135]=52025,
	[51141]=52025,
	[51139]=52025,
	[51140]=52025,
	[51146]=52025,
	[51145]=52025,
	[51129]=52025,
	[51134]=52025,
	[51133]=52025,
	[51128]=52025,
	[51132]=52025,
	[51127]=52025,
	[51131]=52025,
	[51126]=52025,
	[51130]=52025,
	[51125]=52025,
	[51189]=52025,
	[51188]=52025,
	[51187]=52025,
	[51186]=52025,
	[51185]=52025,
	[51280]=52028,
	[51281]=52028,
	[51282]=52028,
	[51283]=52028,
	[51284]=52028,
	[51290]=52028,
	[51301]=52028,
	[51291]=52028,
	[51295]=52028,
	[51296]=52028,
	[51302]=52028,
	[51297]=52028,
	[51303]=52028,
	[51292]=52028,
	[51304]=52028,
	[51298]=52028,
	[51300]=52028,
	[51299]=52028,
	[51293]=52028,
	[51294]=52028,
	[51310]=52028,
	[51305]=52028,
	[51306]=52028,
	[51311]=52028,
	[51307]=52028,
	[51312]=52028,
	[51308]=52028,
	[51313]=52028,
	[51309]=52028,
	[51314]=52028,
	[51250]=52028,
	[51251]=52028,
	[51252]=52028,
	[51253]=52028,
	[51254]=52028,
	[45039]=45038,
	[45897]=45038,
	[45896]=45038,
	[46017]=45038,
	[63188]=45087,
	[63200]=45087,
	[63194]=45087,
	[63187]=45087,
	[63196]=45087,
	[63195]=45087,
	[63201]=45087,
	[63205]=45087,
	[63198]=45087,
	[63199]=45087,
	[63191]=45087,
	[63197]=45087,
	[63189]=45087,
	[63203]=45087,
	[63206]=45087,
	[63204]=45087,
	[63192]=45087,
	[63190]=45087,
	[49959]=49908,
	[49958]=49908,
	[49954]=49908,
	[49965]=49908,
	[49963]=49908,
	[49961]=49908,
	[49953]=49908,
	[49957]=49908,
	[49962]=49908,
	[49955]=49908,
	[49966]=49908,
	[49956]=49908,
	[49974]=49908,
	[49972]=49908,
	[49971]=49908,
	[49973]=49908,
	[49970]=49908,
	[49969]=49908,
	[70556]=49908,
	[70555]=49908,
	[70568]=49908,
	[70551]=49908,
	[70560]=49908,
	[70559]=49908,
	[70557]=49908,
	[70566]=49908,
	[70550]=49908,
	[70565]=49908,
	[70554]=49908,
	[70558]=49908,
	[70552]=49908,
	[70567]=49908,
	[70563]=49908,
	[70562]=49908,
	[70561]=49908,
	[70553]=49908,
	[49623]=50274,
	[67079]=47556,
	[67145]=47556,
	[67081]=47556,
	[67137]=47556,
	[67087]=47556,
	[67139]=47556,
	[67091]=47556,
	[67130]=47556,
	[67083]=47556,
	[67143]=47556,
	[67082]=47556,
	[67138]=47556,
	[67080]=47556,
	[67136]=47556,
	[67086]=47556,
	[67142]=47556,
	[67084]=47556,
	[67140]=47556,
	[67066]=47556,
	[67146]=47556,
	[67085]=47556,
	[67141]=47556,
	[67065]=47556,
	[67147]=47556,
	[67064]=47556,
	[67144]=47556,
	[67092]=47556,
	[67131]=47556,
	[67096]=47556,
	[67135]=47556,
	[67095]=47556,
	[67134]=47556,
	[67093]=47556,
	[67132]=47556,
	[67094]=47556,
	[67133]=47556,
	[44661]=44577,
	[44662]=44577,
	[44664]=44577,
	[44665]=44577}

InitFrame()
