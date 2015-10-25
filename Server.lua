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

function getPlayerDataS( Player )
	local DB = dbPoll(ModerDB:query("SELECT * FROM PlayersData WHERE Serial=?", Player:getSerial()), -1);
	if #DB > 0 and DB[1]["Serial"] == Player:getSerial() then
		return {DB[1]["tEnabled"], DB[1]["tColor"], DB[1]["bColor"]};
	else
		return false
	end
end

function setPlayerDataS( Player, data, value )
	ModerDB:exec("UPDATE PlayersData SET "..data.."=? WHERE Serial=?", value, Player:getSerial());
end

function isPlayerDataExists( Player )
	local DB = dbPoll(ModerDB:query("SELECT * FROM PlayersData WHERE Serial=?", Player:getSerial()), -1);
	if #DB > 0 and DB[1]["Serial"] == Player:getSerial() then
		return true
	else
		return false
	end
end

function createPlayerData(Player)
	ModerDB:exec("INSERT INTO PlayersData VALUES( ?, ?, ?, ? )", Player:getSerial(), "true", "0, 255, 0", "0, 0, 0");
end

addEventHandler("onResourceStart", resourceRoot,
function ()
	ModerDB = Connection.create("sqlite", "Database.db");
	ModerDB:exec("CREATE TABLE IF NOT EXISTS PlayersData ( Serial, tEnabled, tColor, bColor )");
end );

addEvent("Tweets:Call", true);
addEventHandler("Tweets:Call", root,
function ( client, account )
	if client == source then
		fetchRemote("http://twitrss.me/twitter_user_to_rss/?user="..account,
		function (Text, Err)
			if Err == 0 then
				triggerClientEvent(client, "Tweets:onClientCall", client, Text:gsub("\n", ""));
			end
		end, "", false, client);
	end
end );

addEvent("Tweets:LoadData", true);
addEventHandler("Tweets:LoadData", root,
function ( client )
	if client == source then
		if isPlayerDataExists(client) then
			triggerClientEvent(client, "Tweets:onClientLoadData", client, getPlayerDataS(client));
		else
			createPlayerData(client);
			triggerClientEvent(client, "Tweets:onClientLoadData", client, getPlayerDataS(client));
		end
	end
end );

addEvent("Tweets:saveData", true);
addEventHandler("Tweets:saveData", root,
function ( client, Data )
	if client == source then
		if type(Data) == "table" then
			setPlayerDataS(client, Data[1], Data[2]);
		else
			setPlayerDataS(client, "tEnabled", Data);
		end
		triggerClientEvent(client, "Tweets:onClientLoadData", client, getPlayerDataS(client));
	end
end );
