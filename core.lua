ThatsMyBis = LibStub("AceAddon-3.0"):NewAddon("ThatsMyBis", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0")
local LibAceSerializer = LibStub:GetLibrary("AceSerializer-3.0")

local frame = CreateFrame( "Frame" )
local AceGUI = LibStub("AceGUI-3.0")
local TMBIcon = LibStub("LibDBIcon-1.0")

local classColorsTable = {
	Warrior = "\124cFFC79C6E",
	Paladin = "\124cFFF58CBA",
	Shaman = "\124cFF0070DE",
	Hunter = "\124cFFABD473",
	Druid = "\124cFFFF7D0A",
	Rogue = "\124cFFFFF569",
	Priest = "\124cFFFFFFFF",
	Warlock = "\124cFF9482C9",
	Mage = "\124cFF69CCF0"
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
	tooltip:AddLine("Version    : 0.5b") -- EDIT TOC and PKMETA
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
	syncFrame:SetWidth(300)
	syncFrame:SetHeight(200)
	syncFrame:SetLayout("Flow")
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
	popup:SetHeight(340)
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

	-- END OF CHECKBOXES

	local slider1 = AceGUI:Create("Slider")
	slider1:SetValue(ItemListsDB.maxNames)
	slider1:SetSliderValues(1,10,1)
	slider1:SetLabel("How many names to display")
	slider1:SetRelativeWidth(1)
	textboxGroup:AddChild(slider1)

	local inputfield = AceGUI:Create("MultiLineEditBox")
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
	parseData:SetText("Parse")
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
	if ItemListsDB.showMemberNote == nil then ItemListsDB.showMemberNote = true end


	if ItemListsDB.enabled then 
		statusEnableText = "TMB Tooltips is currently: Enabled"
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
		ThatsMyBis:Print(UnitInRaid("Strixpot"))
	elseif arg == "notes" then
		ItemListsDB.showMemberNote = not ItemListsDB.showMemberNote
	else 
		ThatsMyBis:Print("Thats my BIS command arguments\nminimap - toggle minimap icon\ntoogle - enable/disable function\nno argument - open config\nanything else - show this text")
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
			local itemPrioNotes = itemNotes.prioNote
			if itemPrioNotes ~= nil and itemPrioNotes ~= "" then
				if ItemListsDB.displayRank and (itemNotes.rank ~= "") then rankData = " | \124cFFD97025Rank: " .. rankColorsTable[itemNotes.rank]..itemNotes.rank end
				tt:AddLine("Prio Notes:")
				tt:AddLine("\124cFFFFFFFF" .. itemPrioNotes .. rankData)
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
					if ItemListsDB.showMemberNote then 
						if smallestWish.character_note ~= nil then 
							noteHolder = " {"..smallestWish.character_note.."} "
						end
					end
					if i % 5 == 0 then linebreaker = "\n" end
					if ItemListsDB.displayAlts and smallestWish.character_is_alt == 1 then altStatus = "*" end
					wishlistString = wishlistString .. classColorsTable[ smallestWish.character_class ] .. altStatus .. smallestWish.character_name .. "[" .. smallestWish.sort_order .. "]" .. noteHolder .. linebreaker
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
					if ItemListsDB.showMemberNote then 
						if smallestWish.character_note ~= nil then 
							noteHolder = " {"..smallestWish.character_note.."} "
						end
					end
					if i % 5 == 0 then linebreaker = "\n" end
					if ItemListsDB.displayAlts and smallestPrio.character_is_alt == 1 then altStatus = "*" end
					prioListString = prioListString .. classColorsTable[ smallestPrio.character_class ] .. altStatus .. smallestPrio.character_name .. "[" .. smallestPrio.sort_order .. "]" .. noteHolder .. linebreaker
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
					if ItemListsDB.displayAlts and v.character_is_alt == 1 then altStatus = "*" end
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
				if ItemListsDB.displayAlts and v.character_is_alt == 1 then altStatus = "*" end
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
	local header = "type,raid_group_name,member_name,character_name,character_class,character_is_alt,character_inactive_at,character_note,sort_order,item_name,item_id,is_offspec,note,received_at,import_id,item_note,item_prio_note,item_tier,item_tier_label,created_at,updated_at,"

	local parsedLines = {}
	local parsedEntries = {}
	
	for line in input:gmatch("([^\n]*)\n?") do -- Extract the lines into seperate entries in an array.
		table.insert(parsedLines, line..",")
	end
	if (parsedLines[1] ~= header) then return "Wrong Header" end -- Validate the header
	
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

		tempTable = noteTable[ tonumber(e.item_id) ] --Try and load the item element
		if tempTable == nil then noteTable[ tonumber(e.item_id) ] = {} end -- Make an array because this is the first time the item is seen

		if e.type == "wishlist" then
			tempCharTable.character_class = e.character_class
			tempCharTable.character_name = e.character_name
			tempCharTable.sort_order = tonumber(e.sort_order)
			tempCharTable.member_name = e.member_name
			tempCharTable.character_is_alt = tonumber(e.character_is_alt)
			if ItemListsDB.showMemberNote then
				tempCharTable.character_note = e.character_note
			end

			if tempTable ~= nil then tempTable = tempTable.wishlist end -- Look at the wishlist element if it exist then load it
			if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
				tempTable = {}
				table.insert(tempTable,tempCharTable)
			else -- Else insert it into the old one before saving.
				table.insert(tempTable,tempCharTable)
			end
			noteTable[tonumber(e.item_id)].wishlist = tempTable
		elseif e.type == "prio" then
			tempCharTable.character_class = e.character_class
			tempCharTable.character_name = e.character_name
			tempCharTable.sort_order = tonumber(e.sort_order)
			tempCharTable.member_name = e.member_name
			tempCharTable.character_is_alt = tonumber(e.character_is_alt)
			if ItemListsDB.showMemberNote then
				tempCharTable.character_note = e.character_note
			end

			if tempTable ~= nil then tempTable = tempTable.priolist end -- Look at the priolist element if it exist then load it
			if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
				tempTable = {}
				table.insert(tempTable,tempCharTable)
			else -- Else insert it into the old one before saving.
				table.insert(tempTable,tempCharTable)
			end
			noteTable[tonumber(e.item_id)].priolist = tempTable
		elseif e.type == "received" then 
			tempCharTable.character_class = e.character_class
			tempCharTable.character_name = e.character_name
			tempCharTable.member_name = e.member_name
			tempCharTable.character_is_alt = tonumber(e.character_is_alt)

			if tempTable ~= nil then tempTable = tempTable.received end -- Look at the recieved element if it exist then load it
			if tempTable == nil then --If the loaded item is nil then its the first wish for this item so just save it directly
				tempTable = {}
				table.insert(tempTable,tempCharTable)
			else -- Else insert it into the old one before saving.
				table.insert(tempTable,tempCharTable)
			end
			noteTable[tonumber(e.item_id)].received = tempTable
		elseif e.type == "item_note" then 
			noteTable[tonumber(e.item_id)].prioNote = e.item_prio_note
			noteTable[tonumber(e.item_id)].guildNote = e.item_note
			noteTable[tonumber(e.item_id)].rank = e.item_tier_label
 		end
	end
	noteTable["ID"] = math.floor(GetTime())
	ItemListsDB["itemNotes"] = noteTable -- Add it to peristent storage

	return "Done"
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
				local valid, command, data = LibAceSerializer:Deserialize(serializedMsg)
				if valid then
					if command == "INFO" then
						ThatsMyBis:Print(data)
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
	end
	if target == "PARTY" then 
		ThatsMyBis:SendCommMessage("TMBSync", serialized, target, "BULK")
	elseif target == "RAID" then 
		ThatsMyBis:SendCommMessage("TMBSync", serialized, target, "BULK")
	elseif target == "GUILD" then 
		ThatsMyBis:SendCommMessage("TMBSync", serialized, target, "BULK")
	else 
		ThatsMyBis:SendCommMessage("TMBSync", serialized, "WHISPER", target, "BULK")
	end
    
end

InitFrame()
