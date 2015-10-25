--
	--
		--# Created By MoDeR2014 'never remove the credits'
	--
--

-- ***************************** --
-- ***************************** --

--[[
	This script was made under the MTA AR Scripting Challenge
	تم تصميم هذا المود تحت تحدي البرمجة العربي 
	
	http://forum.mtasa.com/viewtopic.php?f=119&t=93698

--]]
-- ****************************** --
-- ****************************** --

Main = {
	ScreenSize = {guiGetScreenSize()},
	DevScreen = {1366, 768},
	OptionsGUI = { button = {}, window = {}, edit = {}, label = {} },
	Tweets = {"No tweets"},
	Rot = 0,
	Num = 1,
	Timer,
};

Options = {
	tEnabled = true,
	tColor = {0, 255, 0},
	bColor = {0, 0, 0},
};

Config = {
	RefreshTime = 5,    -- regetting the tweets time in minutes
	Account = "MoDeR2014Ly",  -- Twitter Account to get his twits
	OptionsPanel = "F3" -- Open Panel Key
};

function setXMLfiletext( Text )
	if File.exists("@Tweets.xml") then xmlF = File.create("@Tweets.xml") else xmlF = File.new("@Tweets.xml") end
	if xmlF then
		xmlF:write("");
		xmlF:write(Text);
		xmlF:flush();
		xmlF:close();
	end
end
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == "string" and isElement( pElementAttachedTo ) and type( func ) == "function" then
    local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == "table" and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                return true
                end
            end
        end
    end
    return false
end
function toggleBar( bool )
	if bool then
		Main["Timer"] = setTimer(Rotate, 60, 0);
		Main["OptionsGUI"]["button"][3]:setText("Disable");
		if isEventHandlerAdded("onClientRender",root, Drawbar) then return end
		addEventHandler("onClientRender",root, Drawbar);
	else
		if isEventHandlerAdded("onClientRender",root, Drawbar) then
			removeEventHandler("onClientRender",root, Drawbar);
		end
		if isTimer(Main["Timer"]) then killTimer(Main["Timer"]) end
		Main["OptionsGUI"]["button"][3]:setText("Enable");
	end
end
function reBuildTable()
	xml = XML.load("@Tweets.xml");
	local index = 0
	while xml:findChild("channel", 0):findChild("item", index) ~= false do
		local Node = xml:findChild("channel", 0):findChild("item", index);
		local Inf = {
			Node:findChild("pubDate",0):getValue(),
			Node:findChild("dc:creator",0):getValue(),
			Node:findChild("title",0):getValue()
		};
		Main["Tweets"][index+1] = "[ "..Inf[1]:sub(1,17).." ] "..Inf[2].." : "..Inf[3]..""
		index = index + 1
	end
	xml:unload();
end if File.exists("@Tweets.xml") then reBuildTable() end

function Drawbar()
	dxDrawRectangle(0, Main["ScreenSize"][2]-25, Main["ScreenSize"][1], Main["ScreenSize"][2], tocolor(Options["bColor"][1], Options["bColor"][2], Options["bColor"][3], 180), false);
	dxDrawText("Latest @"..Config["Account"].." tweets", 10, Main["ScreenSize"][2]-58, Main["ScreenSize"][1], Main["ScreenSize"][2], tocolor(255, 255, 255, 255), 1.00, "default", "left", "center", false, false, false, false, false)
	dxDrawText(Main["Tweets"][Main["Num"]], Main["Rot"], Main["ScreenSize"][2]-25, Main["ScreenSize"][1],  Main["ScreenSize"][2], tocolor(Options["tColor"][1], Options["tColor"][2], Options["tColor"][3], 255), 1.2, "default-bold", "center", "center", false, false, false, false);
end
function Rotate()
	local X = Main["ScreenSize"][1] + 60
	if Main["Rot"] >= X then
		Main["Rot"] = -X
		if Main["Num"] == #Main["Tweets"] then
			Main["Num"] = 1
		else
			Main["Num"] = Main["Num"] + 1
		end
	else
		Main["Rot"] = Main["Rot"] + 6
	end
end

Main["OptionsGUI"]["window"][1] = GuiWindow.create((Main["ScreenSize"][1] - 410) / 2, (Main["ScreenSize"][2] - 353) / 2, 410, 353, ":: Twitter News | Options :: By MoDeR2014", false)
Main["OptionsGUI"]["label"][1]  = GuiLabel.create(1, 38, 409, 15, "Text Color", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["edit"][1]   = GuiEdit.create(135, 63, 40, 23, "", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["edit"][2]   = GuiEdit.create(185, 63, 40, 23, "", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["edit"][3]   = GuiEdit.create(235, 63, 40, 23, "", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][2]  = GuiLabel.create(1, 63, 124, 23, "RGB", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["button"][1] = GuiButton.create(165, 96, 80, 25, "set Color", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][3]  = GuiLabel.create(285, 63, 124, 23, "Color Preview", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][4]  = GuiLabel.create(0, 131, 409, 15, "_________________________________________________________", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][5]  = GuiLabel.create(1, 156, 409, 15, "Background Color", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][6]  = GuiLabel.create(0, 181, 124, 23, "RGB", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["edit"][4]   = GuiEdit.create(135, 181, 40, 23, "", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["edit"][5]   = GuiEdit.create(185, 181, 40, 23, "", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["edit"][6]   = GuiEdit.create(235, 181, 40, 23, "", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][7]  = GuiLabel.create(285, 181, 124, 23, "Color Preview", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["button"][2] = GuiButton.create(165, 219, 80, 25, "set Color", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][8]  = GuiLabel.create(1, 254, 409, 15, "_________________________________________________________", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["label"][9]  = GuiLabel.create(0, 279, 409, 15, "Enable & Disable Bar", false, Main["OptionsGUI"]["window"][1])
Main["OptionsGUI"]["button"][3] = GuiButton.create(165, 304, 80, 25, "", false, Main["OptionsGUI"]["window"][1])

Main["OptionsGUI"]["window"][1]:setSizable(false);
Main["OptionsGUI"]["label"][1]:setHorizontalAlign("center", false);
Main["OptionsGUI"]["label"][2]:setHorizontalAlign("right", false);
Main["OptionsGUI"]["label"][4]:setHorizontalAlign("center", false);
Main["OptionsGUI"]["label"][5]:setHorizontalAlign("center", false);
Main["OptionsGUI"]["label"][6]:setHorizontalAlign("right", false);
Main["OptionsGUI"]["label"][8]:setHorizontalAlign("center", false);
Main["OptionsGUI"]["label"][9]:setHorizontalAlign("center", false);
for index = 2, 7 do
	Main["OptionsGUI"]["label"][index]:setVerticalAlign("center");
end
for index = 1, 6 do
	Main["OptionsGUI"]["edit"][index]:setMaxLength(3);
end
Main["OptionsGUI"]["window"][1]:setVisible(false);

triggerServerEvent("Tweets:LoadData", localPlayer, localPlayer);
triggerServerEvent("Tweets:Call", localPlayer, localPlayer, Config["Account"]);
setTimer(triggerServerEvent, Config["RefreshTime"]*60000, 0, "Tweets:Call", localPlayer, localPlayer, Config["Account"]);

addEvent("Tweets:onClientLoadData", true);
addEventHandler("Tweets:onClientLoadData", root,
function ( InfTable )
	if InfTable[1] == "true" then
		Options["tEnabled"] = true
		toggleBar(true);
	else
		Options["tEnabled"] = false
		toggleBar();
	end
	local sT = split(InfTable[2], ", ");
	local sB = split(InfTable[3], ", ");
	Options["tColor"] = {sT[1], sT[2], sT[3]};
	Options["bColor"] = {sB[1], sB[2], sB[3]};
end );

addEvent("Tweets:onClientCall", true);
addEventHandler("Tweets:onClientCall", root,
function ( Text )
	setXMLfiletext(Text);
	reBuildTable();
end );

addEventHandler("onClientGUIChanged", resourceRoot,
function ()
	if source:getType() == "gui-edit" then
		if source:getText() == "" or source:getText():find(" ") then
			source:setText("0");
		else
			local cT = tonumber(source:getText());
			if not cT then
				source:setText(source:getText():gsub("[^%d]", ""));
			elseif cT > 255 then
				source:setText("255");
			elseif cT < 0 then
				source:setText("0");
			elseif source:getText() == "" or source:getText() == " " then
				source:setText("0");
			end
			Main["OptionsGUI"]["label"][3]:setColor(Main["OptionsGUI"]["edit"][1]:getText(), Main["OptionsGUI"]["edit"][2]:getText(), Main["OptionsGUI"]["edit"][3]:getText());
			Main["OptionsGUI"]["label"][7]:setColor(Main["OptionsGUI"]["edit"][4]:getText(), Main["OptionsGUI"]["edit"][5]:getText(), Main["OptionsGUI"]["edit"][6]:getText());
		end
	end
end );

addEventHandler("onClientGUIClick", resourceRoot,
function ( button )
	if button == "left" then
		if source == Main["OptionsGUI"]["button"][1] then
			local Color = Main["OptionsGUI"]["edit"][1]:getText()..", "..Main["OptionsGUI"]["edit"][2]:getText()..", "..Main["OptionsGUI"]["edit"][3]:getText()
			triggerServerEvent("Tweets:saveData", localPlayer, localPlayer, {"tColor", Color});
		elseif source == Main["OptionsGUI"]["button"][2] then
			local Color = Main["OptionsGUI"]["edit"][4]:getText()..", "..Main["OptionsGUI"]["edit"][5]:getText()..", "..Main["OptionsGUI"]["edit"][6]:getText()
			triggerServerEvent("Tweets:saveData", localPlayer, localPlayer, {"bColor", Color});
		elseif source == Main["OptionsGUI"]["button"][3] then
			if Options["tEnabled"] == true then
				value = "false"
			else
				value = "true"
			end
			triggerServerEvent("Tweets:saveData", localPlayer, localPlayer, value);
		end
		if source:getType() == "gui-button" then
			local bB = source
			bB:setEnabled(false);
			setTimer(function () bB:setEnabled(true) end, 2000, 1);
			playSoundFrontEnd(27);
		end
	end
end );

bindKey(Config["OptionsPanel"], "down",
function ()
	Main["OptionsGUI"]["window"][1]:setVisible(not Main["OptionsGUI"]["window"][1]:getVisible());
	showCursor(Main["OptionsGUI"]["window"][1]:getVisible());
	if Main["OptionsGUI"]["window"][1]:getVisible() then
		Main["OptionsGUI"]["window"][1]:bringToFront();
		Main["OptionsGUI"]["edit"][1]:setText(Options["tColor"][1]);
		Main["OptionsGUI"]["edit"][2]:setText(Options["tColor"][2]);
		Main["OptionsGUI"]["edit"][3]:setText(Options["tColor"][3]);
		Main["OptionsGUI"]["label"][3]:setColor(Options["tColor"][1], Options["tColor"][2], Options["tColor"][3]);
		Main["OptionsGUI"]["edit"][4]:setText(Options["bColor"][1]);
		Main["OptionsGUI"]["edit"][5]:setText(Options["bColor"][2]);
		Main["OptionsGUI"]["edit"][6]:setText(Options["bColor"][3]);
		Main["OptionsGUI"]["label"][7]:setColor(Options["bColor"][1], Options["bColor"][2], Options["bColor"][3]);
	end
end );
