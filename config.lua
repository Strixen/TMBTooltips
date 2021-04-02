local _, config = ...

local frame = CreateFrame( "Frame" )
frame.name = "TMB Helper"

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

local ppb = CreateFrame("Button", "parsePrio", frame, "UIPanelButtonTemplate ")
ppb:SetText("All Items")
ppb:SetWidth(80)
ppb:SetPoint("TOPLEFT", 30, -110)
ppb:RegisterForClicks("AnyUp")
ppb:SetScript("OnClick", function (self, button, down)
	if pasted == "" then return end
	self:SetText(ParseText(pasted,"itemnotes"))
	f:SetText("")
end)

local pwb = CreateFrame("Button", "parseWishlist", frame, "UIPanelButtonTemplate ")
pwb:SetText("Wishlist")
pwb:SetWidth(80)
pwb:SetPoint("TOPLEFT", 250, -110)
pwb:RegisterForClicks("AnyUp")
pwb:SetScript("OnClick", function (self, button, down)
	if pasted == "" then return end
	self:SetText(ParseText(pasted,"wishlist"))
	f:SetText("")
end)

local pwb = CreateFrame("Button", "parsePriolist", frame, "UIPanelButtonTemplate ")
pwb:SetText("Prio List")
pwb:SetWidth(80)
pwb:SetPoint("TOPLEFT", 450, -110)
pwb:RegisterForClicks("AnyUp")
pwb:SetScript("OnClick", function (self, button, down)
	if pasted == "" then return end
	self:SetText(ParseText(pasted,"priolist"))
	f:SetText("")
end)

frame.okay = SaveAndQuit
frame:SetScript( "OnShow", RefreshWidgets )
frame:SetScript( "OnEvent", InitVariables )
frame:RegisterEvent( "VARIABLES_LOADED" )

function ParseText(input,dataPoint)
	if input == nil or dataPoint == nil then return "NoData" end
	local header = ""

	if dataPoint == "wishlist" then
		header = "raid_name,character_name,character_class,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,created_at,updated_at,"
	elseif dataPoint == "priolist" then
		header = "raid_name,character_name,character_class,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,created_at,updated_at,"
	elseif dataPoint == "itemnotes" then
		header = "name,id,instance_name,source_name,guild_note,prio_note,created_at,updated_at,"
	end

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
	local finalTable = {}

	for k,e in pairs(parsedEntries) do
		if dataPoint == "wishlist" or dataPoint == "priolist" then
			local append = finalTable[ tonumber(e.item_id) ]
			if append == nil then append = "" end
			
			finalTable[tonumber(e.item_id)] = e.character_name .. "[" .. e.sort_order .. "]" .. " " .. append
		elseif dataPoint == "itemnotes" then 
			finalTable[tonumber(e.id)] = e.prio_note
		end
	end
	ItemListsDB[dataPoint] = finalTable -- Add it to peristent storage
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
				-- quoted string without separator, then append it
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