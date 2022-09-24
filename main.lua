local EventFrame = CreateFrame("Frame")

local selfPlayerName, selfRealm = UnitName("player")

allowedPlayers = allowedPlayers or {"Droot", "Leftovermeat", "Wildchad"}

local function containsElement(tbl, element)
    for index, value in ipairs(tbl) do
        if value == element then return true end
    end

    return false
end

EventFrame:RegisterEvent("CHAT_MSG_PARTY")
EventFrame:RegisterEvent("CHAT_MSG_PARTY_LEADER")
EventFrame:RegisterEvent("CHAT_MSG_WHISPER")
EventFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(f, event)
    if event == "PLAYER_LOGIN" then
        -- SendChatMessage("Party control initialized!", "PARTY", nil, nil, nil)
        print("Party control initialized!")
        print(tostring(allowedPlayers))
    end
end)

function stringContainsFollow(input)
    -- Convert input to lower case.
    lowerInput = string.lower(input)

    if string.find(lowerInput, "!follow") then return true end

    return false
end

function stringContainsStop(input)
    -- Convert input to lower case.
    lowerInput = string.lower(input)

    if string.find(lowerInput, "!stop") then return true end

    return false
end

function stringContainsLeader(input)
    -- Convert input to lower case.
    lowerInput = string.lower(input)

    if string.find(lowerInput, "!leader") then return true end

    return false
end

function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
 end

function stringContainsInvite(input)
    -- Convert input to lower case.
    lowerInput = string.lower(input)

    if string.find(lowerInput, "!invite") then return true end

    return false
end

function handlePartyMessage(self, event, text, playerName, languageName,
                            channelName, playerName2, specialFlags,
                            zoneChannelID, channelIndex, channelBaseName,
                            unused, lineID, guid, bnSenderID, isMobile,
                            isSubtitle, hideSenderInLetterBox, suppressRaidIcons)

    -- If chat message originated from self do not do anything.
    if playerName2 == selfPlayerName then return end

    -- Only keep going if the string starts with an exclamation-mark "!"
    if string.starts(text, "!") == false then return end

    -- Check the message originates from an allowed player.
    if false == containsElement(allowedPlayers, playerName2) then
        print("User: " .. playerName2 .. " not allowed to issue commands!")
        return
    end

    --    dump(text, playerName, languageName, channelName, playerName2, specialFlags,
    --         zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid,
    --         bnSenderID, isMobile, isSubtitle, hideSenderInLetterBox,
    --         suppressRaidIcons)

    -- arg1: event.text
    -- arg2: event.playerName
    -- arg3: event.languageName
    -- arg4: event.channelName
    -- arg5: event.playerName2
    -- arg6: event.specialFlags
    -- arg7: event.zoneChannelID
    -- arg8: event.channelIndex
    -- arg9: event.channelBaseName
    -- arg10: unused
    -- arg11: event.lineID
    -- arg12: event.guid
    -- arg13: event.bnSenderID
    -- arg14: event.isMobile
    -- arg15: event.isSubtitle
    -- arg16: event.hideSenderInLetterBox
    -- arg17: event.supressRaidIcons

    if stringContainsFollow(text) then
        --SendChatMessage(playerName .. " wants me to follow them!", "PARTY", nil, nil, nil)
        FollowUnit(playerName2)
    end

    if stringContainsStop(text) then FollowUnit("player") end

    if stringContainsLeader(text) then PromoteToLeader(playerName2) end

    if stringContainsInvite(text) then

        -- If direct match "!invite" the player sending the message.
        if text == "!invite" then
            InviteUnit(playerName2)
            return
        else
            -- Otherwise try to invite the player names following the "!invite" string.
            for i in string.gmatch(text, "%S+") do
                if (i ~= "!invite") then InviteUnit(i) end
            end
        end

    end

end

EventFrame:SetScript("OnEvent", handlePartyMessage)

SLASH_PARTYADD1 = '/partyadd'
SLASH_PARTYLIST1 = '/partylist'

SlashCmdList['PARTYADD'] = function(msg)
    table.insert(allowedPlayers, msg)
    DEFAULT_CHAT_FRAME:AddMessage('added ' .. msg .. ' to allowed players')
end

SlashCmdList['PARTYLIST'] = function(msg)
    print('current players:')
    for k, val in pairs(allowedPlayers) do
        print(' ' .. k .. ', ' .. val)
    end
end