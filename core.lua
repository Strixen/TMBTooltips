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
	"\124cFF69CCF0"
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
		Mage = 9
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
	tooltip:AddLine("Revision    : 100") -- EDIT TOC and PKMETA
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
	check1:SetLabel("Priority Note")
	check1:SetValue(ItemListsDB.displayPrioNote)
	checkboxGroup:AddChild(check1)

	local check6 = AceGUI:Create("CheckBox")
	check6:SetLabel("Guild Note")
	check6:SetValue(ItemListsDB.displayGuildNote)
	checkboxGroup:AddChild(check6)

	local check2 = AceGUI:Create("CheckBox")
	check2:SetLabel("Ranks")
	check2:SetValue(ItemListsDB.displayRank)
	checkboxGroup:AddChild(check2)

	local check3 = AceGUI:Create("CheckBox")
	check3:SetLabel("Wishlists")
	check3:SetValue(ItemListsDB.displayWishes)
	checkboxGroup:AddChild(check3)

	local check4 = AceGUI:Create("CheckBox")
	check4:SetLabel("Priolists")
	check4:SetValue(ItemListsDB.displayPrios)
	checkboxGroup:AddChild(check4)

	local check5 = AceGUI:Create("CheckBox")
	check5:SetLabel("Display Alt *")
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
	check6:SetCallback("OnValueChanged", function(obj, evt, val)
		ItemListsDB.displayGuildNote = check6:GetValue()
	end)
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

	local itemNotes = ItemListsDB.itemNotes[itemID]
	if itemNotes == nil then return end -- Item not in DB, escape out of function.

	if IsAltKeyDown() == false then --Display something different if alt is held down.
		-- %%%%%%%%%%%%%%%%% PRIO NOTES
		if ItemListsDB.displayPrioNote then
			local rankData = ""
			local rankColorSelect = itemNotes.rank
			if (tonumber(rankColorSelect) ~= nil) then
				rankColorSelect = rankColorsTableConvert[tonumber(rankColorSelect)]
			end

			local itemPrioNotes = itemNotes.prioNote
			if itemPrioNotes ~= nil and itemPrioNotes ~= "" then
				if ItemListsDB.displayRank and (itemNotes.rank ~= "") then rankData = " | \124cFFD97025Rank: " .. rankColorsTable[rankColorSelect]..itemNotes.rank end
				tt:AddLine("Prio Notes:")
				tt:AddLine("\124cFFFFFFFF" .. itemPrioNotes .. rankData)
			end
		end
		-- %%%%%%%%%%%%%%%%% PRIO RANK 
		-- Edge case where someone might have prio notes disabled but rank enabled.
		
		if not ItemListsDB.displayPrioNote and ItemListsDB.displayRank then
			local rankData = ""
			local rankColorSelect = itemNotes.rank
			if (tonumber(rankColorSelect) ~= nil) then
				rankColorSelect = rankColorsTableConvert[tonumber(rankColorSelect)]
			end
				if (itemNotes.rank ~= "" and itemNotes.rank ~= nil ) then rankData = "\124cFFD97025Rank: " .. rankColorsTable[rankColorSelect]..itemNotes.rank end
				tt:AddLine(rankData)
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
			local itemReceived = itemNotes.received
			local receivedString = ""
			tt:AddLine("Received item:")
			if itemReceived ~= nil then
				-- Construct the string to be displayed
				for k,v in pairs(itemReceived) do
					if k > ItemListsDB.maxNames then break end
					local altStatus = ""
					if ItemListsDB.displayAlts and v.character_is_alt == 1 then altStatus = "[Alt]" end
					receivedString = receivedString .. altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. " "
				end
				tt:AddLine( receivedString )
			end
		end

	else 
		local itemReceived = itemNotes.received
		local receivedString = ""
		tt:AddLine("Received item:")
		if itemReceived ~= nil then
			-- Construct the string to be displayed
			for k,v in pairs(itemReceived) do
				if k > ItemListsDB.maxNames then break end
				local altStatus = ""
				if ItemListsDB.displayAlts and v.character_is_alt == 1 then altStatus = "[Alt]" end
				receivedString = receivedString .. altStatus .. classColorsTable[ v.character_class ] .. v.character_name .. " "
			end
			tt:AddLine( receivedString )
		end
	end
end

-- TODO: Affects more than the static item frame. Need to look into this later
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
	[34575]=34858}

InitFrame()
