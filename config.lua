local _, config = ...

local frame = CreateFrame( "Frame" )
frame.name = "TMB Helper"

ItemListsDB = {}

local userVariables

local PROF_CHECK = {}
local QUEST_CHECK = {}

--[[ local function CreateCheckbox( name, x, y, label, tooltip )

	local check = CreateFrame( "CheckButton", name, frame, "ChatConfigCheckButtonTemplate" ) --"OptionsCheckButtonTemplate" )
	_G[ name .. "Text" ]:SetText( label )
	check.tooltip = tooltip
	check:SetPoint( "TOPLEFT", x, y )

	return check
end ]]



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
	self:SetText(ParsePrioNotes(pasted))
	f:SetText("")
end)

local pwb = CreateFrame("Button", "parseWishlist", frame, "UIPanelButtonTemplate ")
pwb:SetText("Wishlist")
pwb:SetWidth(80)
pwb:SetPoint("TOPLEFT", 250, -110)
pwb:RegisterForClicks("AnyUp")
pwb:SetScript("OnClick", function (self, button, down)
	if pasted == "" then return end
	self:SetText(ParseWishlist(pasted))
	f:SetText("")
end)

local pwb = CreateFrame("Button", "parsePriolist", frame, "UIPanelButtonTemplate ")
pwb:SetText("Prio List")
pwb:SetWidth(80)
pwb:SetPoint("TOPLEFT", 450, -110)
pwb:RegisterForClicks("AnyUp")
pwb:SetScript("OnClick", function (self, button, down)
	if pasted == "" then return end
	self:SetText(ParsePriolist(pasted))
	f:SetText("")
end)

frame.okay = SaveAndQuit
frame:SetScript( "OnShow", RefreshWidgets )
frame:SetScript( "OnEvent", InitVariables )
frame:RegisterEvent( "VARIABLES_LOADED" )

local function union ( a, b ) --Merge two tables
    local result = {}
    for k,v in pairs ( a ) do
        table.insert( result, v )
    end
    for k,v in pairs ( b ) do
         table.insert( result, v )
    end
    return result
end

function ParsePrioNotes(input)
	if input == nil then return end
	local CSVlines = {}
	local t = {}
	for line in input:gmatch("([^\n]*)\n?") do
		table.insert(CSVlines, line..",")
	end
	if (CSVlines[1] ~= "name,id,instance_name,source_name,guild_note,prio_note,created_at,updated_at,") then return "Wrong Header" end -- Validate the header

	local tt = {}
	for k,l in pairs(CSVlines) do
		tt = ParseCSVLine(l)
		t = union(t,tt)
	end
 	local prioNotes = {}
	local len = tablelength(t)
	for i = 14,len,8 do
		
	 prioNotes[tonumber(t[i-4])] = t[i] -- Add the Prio Notes

	end
	ItemListsDB.itemnotes = prioNotes

	return "Done"

end

function ParseWishlist(input)
	if input == nil then return end
	local CSVlines = {}
	local t = {}
	for line in input:gmatch("([^\n]*)\n?") do
		table.insert(CSVlines, line..",")
	end
	if (CSVlines[1] ~= "raid_name,character_name,character_class,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,created_at,updated_at,") then return "Wrong Header" end -- Validate the header

	local tt = {}
	for k,l in pairs(CSVlines) do
		tt = ParseCSVLine(l)
		t = union(t,tt)
	end
 	local wishlist = {}
	local len = tablelength(t)
	for i = 16,len,14 do
	local append = wishlist[tonumber(t[i+5])]
	if append == nil then append = "" end
	wishlist[tonumber(t[i+5])] = t[i] .. "["..t[i+3].."]" .. " " .. append -- Add the Prio Notes

	end
	ItemListsDB.wishlist = wishlist -- Add it to peristent storage

	return "Done"

end

function ParsePriolist(input)
	if input == nil then return end
	local CSVlines = {}
	local t = {}
	for line in input:gmatch("([^\n]*)\n?") do
		table.insert(CSVlines, line..",")
	end
	if (CSVlines[1] ~= "raid_name,character_name,character_class,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,created_at,updated_at,") then return "Wrong Header" end -- Validate the header

	local tt = {}
	for k,l in pairs(CSVlines) do
		tt = ParseCSVLine(l)
		t = union(t,tt)
	end
 	local priolist = {}
	local len = tablelength(t)
	for i = 16,len,14 do
	local append = priolist[tonumber(t[i+5])]
	if append == nil then append = "" end
	priolist[tonumber(t[i+5])] = t[i] .. "["..t[i+3].."]" .. " " .. append -- Add the Prio Notes

	end
	ItemListsDB.priolist = priolist -- Add it to peristent storage

	return "Done"

end


function ParseText(input,dataType)

	if input == nil or dataType == nil then return "NoData" end

	local dataPoint,header = "",""
	-- WTB switch function.
	if dataType == "wishlist" then
		dataPoint = "wishlist"
		header = "raid_name,character_name,character_class,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,created_at,updated_at,"
	elseif dataType == "priolist" then
		dataPoint = "priolist"
		header = "raid_name,character_name,character_class,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,created_at,updated_at,"
	elseif dataType == "itemnotes" then
		dataPoint = "itemnotes"
		header = "name,id,instance_name,source_name,guild_note,prio_note,created_at,updated_at,"
	end


	local parsedLines = {}
	local t = {}
	
	for line in input:gmatch("([^\n]*)\n?") do -- Extract the lines into seperate entries in an array.
		table.insert(parsedLines, line..",")
	end
	if (parsedLines[1] ~= header) then return "Wrong Header" end -- Validate the header

	-- Try and determine the positions of relevant info
	local magicNumbers = {}
	local headerData = ParseCSVLine(parsedLines(1))
	local headerLength = tablelength(headerData)

	magicNumbers.jumpI = headerLength
	header = "raid_name,character_name,character_class,character_inactive_at,sort_order,item_name,item_id,note,received_at,import_id,item_note,item_prio_note,created_at,updated_at,"


	for k,v in pairs(headerData) do -- Go through the header looking for starting index and jump length.
		if dataPoint = "wishlist" then
			if v == "character_name" then
				magicNumbers.offsetOrigin = k
				magicNumbers.startI = headerLength + k
			end
		end
	end

	-- local tt = {} -- Throwaway table used 
	for k,l in pairs(parsedLines) do
		t = union(t,ParseCSVLine(l))
	end

 	local dataTable = {}
	local len = tablelength(t)
	for i = 16,len,14 do
	local append = dataTable[tonumber(t[i+5])]
	if append == nil then append = "" end
	dataTable[tonumber(t[i+5])] = t[i] .. "["..t[i+3].."]" .. " " .. append -- Add the Prio Notes

	end
	ItemListsDB.priolist = dataTable -- Add it to peristent storage

	return "Done"

end




function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
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