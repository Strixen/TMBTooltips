local _, config = ...

local frame = CreateFrame( "Frame" )
frame.name = "TMB Tooltips"

ItemListsDB = {}

local userVariables

local dialogHeader = frame:CreateFontString( nil, "OVERLAY", "GameTooltipText" )
dialogHeader:SetFont( "Fonts\\FRIZQT__.TTF", 10, "THINOUTLINE" )
dialogHeader:SetPoint( "TOPLEFT", 20, -20 )
dialogHeader:SetText( "Welcome to the very unfinished control panel of TMB helper also a WIP name\nUse the export functions of TMB, the ones you want are: \nWishlists, Prios and All Items. Paste them into the dialog below and click the corrosponding button." )

local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(300, 200)
scrollFrame:SetPoint("CENTER")

local f = CreateFrame("EditBox", "logEditBox", scrollFrame, "InputBoxTemplate")
f:SetFrameStrata("DIALOG")
f:SetWidth(300)
f:SetAutoFocus(false)
f:SetPoint("TOPLEFT", 30, -80)
f:SetMultiLine(true)

local textBuffer, i, lastPaste = {}, 0, 0
local pasted = ""
f:SetScript("OnShow", function(self)
	self:SetText("")
	pasted = ""
end)
local function clearBuffer(self)
	self:SetScript('OnUpdate', nil)
	pasted = strtrim(table.concat(textBuffer))
	f:ClearFocus()
end
f:SetScript('OnChar', function(self, c)
	if lastPaste ~= GetTime() then
		textBuffer, i, lastPaste = {}, 0, GetTime()
		self:SetScript('OnUpdate', clearBuffer)
	end
	i = i + 1
	textBuffer[i] = c
end)
f:SetMaxBytes(2500)



scrollFrame:SetScrollChild(f)

local ppb = CreateFrame("Button", "parseCSV", frame, "UIPanelButtonTemplate ")
ppb:SetText("Parse CSV")
ppb:SetWidth(80)
ppb:SetPoint("TOPLEFT", 30, -110)
ppb:RegisterForClicks("AnyUp")
ppb:SetScript("OnClick", function (self, button, down)
	if pasted == "" then return end
	self:SetText(ParseText(pasted))
	f:SetText("")
end)


frame.okay = SaveAndQuit
frame:SetScript( "OnShow", RefreshWidgets )
frame:SetScript( "OnEvent", InitVariables )
frame:RegisterEvent( "VARIABLES_LOADED" )

function ParseText(input)
	if input == nil then return "NoData" end
	local header = "type,raid_name,member_name,character_name,character_class,character_is_alt,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,item_tier,item_tier_label,created_at,updated_at,"

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
InterfaceOptions_AddCategory( frame )