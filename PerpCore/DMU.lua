local tbl = 
{
	
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				enabled = false,
				eventType = 18,
				execute = "-- [Debug] OnAOECreate\n-- Verbose logging of every AOE created, a world-text label over it (name, ID, castType,\n-- size, duration, heading), and a drawn shape matching aoeCastType. Loops (self.used each fire).\n\nlocal aoeId    = eventArgs.aoeID\nlocal castType = tonumber(eventArgs.aoeCastType) or 0\nlocal len      = tonumber(eventArgs.aoeLength) or 0\nlocal wid      = tonumber(eventArgs.aoeWidth) or 0\nlocal heading  = tonumber(eventArgs.heading) or 0\nlocal x, y, z  = eventArgs.x, eventArgs.y, eventArgs.z\nlocal durationMs = (tonumber(eventArgs.duration) or 5) * 1000\n\nd(\"[Debug AOE] name=\" .. tostring(eventArgs.aoeName) .. \" id=\" .. tostring(aoeId) .. \" castType=\" .. tostring(castType) .. \" aoeType=\" .. tostring(eventArgs.aoeType) .. \" length=\" .. tostring(len) .. \" width=\" .. tostring(wid) .. \" heading=\" .. string.format(\"%.3f\", heading) .. \" duration=\" .. tostring(eventArgs.duration) .. \" targetAttach=\" .. tostring(eventArgs.targetAttach) .. \" pos=\" .. string.format(\"%.1f, %.1f, %.1f\", x or 0, y or 0, z or 0))\n\nif AnyoneCore and AnyoneCore.addTimedWorldText then\n    local label = string.format(\"%s\\nID: %s  CT: %s  Type: %s\\nL: %s  W: %s  Hd: %.2f\\nDur: %ss\", tostring(eventArgs.aoeName), tostring(aoeId), tostring(castType), tostring(eventArgs.aoeType), tostring(len), tostring(wid), heading, tostring(eventArgs.duration))\n    local cx, cz = x, z\n    local isDirectional = (castType == 3 or castType == 13 or castType == 4 or castType == 12 or castType == 8)\n    if isDirectional and TensorCore and TensorCore.getPosInDirection then\n        local mid = TensorCore.getPosInDirection({ x = x, y = y, z = z }, heading, len * 0.5)\n        if mid then\n            cx, cz = mid.x, mid.z\n        end\n    end\n    local textPos = { x = cx, y = y, z = cz }\n    AnyoneCore.addTimedWorldText(durationMs, label, textPos, 0xFFFFFFFF, true, 0.8)\nend\n\nself.used = true\n",
				executeType = 2,
				loop = true,
				mechanicTime = 15.282,
				name = "[Debug] OnAOECreate",
				timeRange = true,
				timelineIndex = 1,
				timerEndOffset = 9999,
				timerStartOffset = -15.300000190735,
				uuid = "ddf140da-50b5-4f79-bdfb-cf01dc3f6cae",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				enabled = false,
				eventType = 4,
				execute = "-- [Debug] OnEntityMarkerAdd\n-- Verbose logging of every marker added to an entity. Loops (self.used each fire).\n\nlocal ent = TensorCore.mGetEntity(eventArgs.entityID or eventArgs.entityId)\n\nd(\"[Debug Marker] markerID=\" .. tostring(eventArgs.markerID) .. \" entityID=\" .. tostring(eventArgs.entityID) .. \" name=\" .. tostring(ent and ent.name or \"?\") .. \" cid=\" .. tostring(ent and ent.contentid or \"?\") .. \" type=\" .. tostring(ent and ent.type or \"?\") .. (ent and ent.pos and (\" pos=\" .. string.format(\"%.1f, %.1f, %.1f\", ent.pos.x, ent.pos.y, ent.pos.z)) or \"\"))\n\nself.used = true\n",
				executeType = 2,
				loop = true,
				mechanicTime = 15.282,
				name = "[Debug] OnEntityMarkerAdd",
				timeRange = true,
				timelineIndex = 1,
				timerEndOffset = 9999,
				timerStartOffset = -15.300000190735,
				uuid = "593111b3-d4c9-c1b6-9d9f-7d5ec7666024",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				enabled = false,
				eventType = 2,
				execute = "-- [Debug] OnEntityCast\n-- Verbose logging of every non-party cast we see. Loops (self.used each fire).\n-- eventArgs is a userdata object (pairs() returns nothing), so fields are read explicitly.\n\nif not eventArgs then\n    self.used = true\n    return\nend\n\nlocal casterId = eventArgs.entityID or eventArgs.entityId or eventArgs.sourceEntityID\n\n-- Skip casts performed by party members (including us) so we only see enemy/NPC casts.\nif casterId and PerpCore and PerpCore.GetPartyEntities then\n    for _, m in ipairs(PerpCore.GetPartyEntities() or {}) do\n        if m and m.id == casterId then\n            self.used = true\n            return\n        end\n    end\nend\nlocal me = PerpCore and PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nif me and casterId == me.id then\n    self.used = true\n    return\nend\n\nlocal caster   = casterId and TensorCore.mGetEntity(casterId)\nlocal targetId = eventArgs.targetID or eventArgs.targetId or eventArgs.mainTargetID\nlocal target   = targetId and TensorCore.mGetEntity(targetId)\nlocal spellID  = eventArgs.spellID or eventArgs.spellId or eventArgs.actionID\n\n-- Try to resolve the action name if the ActionList API is available.\nlocal spellName = \"?\"\nif spellID and ActionList and ActionList.Get then\n    local ok, action = pcall(function() return ActionList:Get(1, spellID) end)\n    if ok and action and action.name then\n        spellName = action.name\n    end\nend\n\nd(\"[Debug Cast] spell=\" .. tostring(spellName) .. \" (id \" .. tostring(spellID) .. \")\" ..\n    \" caster=\" .. tostring(caster and caster.name or \"?\") ..\n    \" (id \" .. tostring(casterId) .. \", cid \" .. tostring(caster and caster.contentid) ..\n    \", type \" .. tostring(caster and caster.type) .. \")\" ..\n    \" target=\" .. tostring(target and target.name or \"?\") .. \" (id \" .. tostring(targetId) .. \")\" ..\n    \" heading=\" .. tostring(eventArgs.heading) ..\n    (eventArgs.castPosX and (\" castPos=\" .. string.format(\"%.1f, %.1f, %.1f\",\n        eventArgs.castPosX, eventArgs.castPosY or 0, eventArgs.castPosZ or 0)) or \"\"))\n\nself.used = true\n",
				executeType = 2,
				loop = true,
				mechanicTime = 15.282,
				name = "[Debug] OnEntityCast",
				timeRange = true,
				timelineIndex = 1,
				timerEndOffset = 9999,
				timerStartOffset = -15.300000190735,
				uuid = "b7226492-b083-a726-bcb4-bbe8cc4a9955",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				enabled = false,
				eventType = 3,
				execute = "-- [Debug] OnEntityChannel\n-- Verbose logging of every non-party channel we see. Loops (self.used each fire).\n-- eventArgs is a userdata object (pairs() returns nothing), so fields are read explicitly.\n\nif not eventArgs then\n    self.used = true\n    return\nend\n\nlocal casterId = eventArgs.entityID or eventArgs.entityId or eventArgs.sourceEntityID\n\n-- Skip channels performed by party members (including us) so we only see enemy/NPC channels.\nif casterId and PerpCore and PerpCore.GetPartyEntities then\n    for _, m in ipairs(PerpCore.GetPartyEntities() or {}) do\n        if m and m.id == casterId then\n            self.used = true\n            return\n        end\n    end\nend\nlocal me = PerpCore and PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nif me and casterId == me.id then\n    self.used = true\n    return\nend\n\nlocal caster   = casterId and TensorCore.mGetEntity(casterId)\nlocal targetId = eventArgs.targetID or eventArgs.targetId or eventArgs.mainTargetID\nlocal target   = targetId and TensorCore.mGetEntity(targetId)\nlocal spellID  = eventArgs.spellID or eventArgs.spellId or eventArgs.actionID\n\n-- Try to resolve the action name if the ActionList API is available.\nlocal spellName = \"?\"\nif spellID and ActionList and ActionList.Get then\n    local ok, action = pcall(function() return ActionList:Get(1, spellID) end)\n    if ok and action and action.name then\n        spellName = action.name\n    end\nend\n\nd(\"[Debug Channel] spell=\" .. tostring(spellName) .. \" (id \" .. tostring(spellID) .. \")\" ..\n    \" caster=\" .. tostring(caster and caster.name or \"?\") ..\n    \" (id \" .. tostring(casterId) .. \", cid \" .. tostring(caster and caster.contentid) ..\n    \", type \" .. tostring(caster and caster.type) .. \")\" ..\n    \" target=\" .. tostring(target and target.name or \"?\") .. \" (id \" .. tostring(targetId) .. \")\" ..\n    \" heading=\" .. tostring(eventArgs.heading) ..\n    (eventArgs.castPosX and (\" castPos=\" .. string.format(\"%.1f, %.1f, %.1f\",\n        eventArgs.castPosX, eventArgs.castPosY or 0, eventArgs.castPosZ or 0)) or \"\"))\n\nself.used = true\n",
				executeType = 2,
				loop = true,
				mechanicTime = 15.282,
				name = "[Debug] OnEntityChannel",
				timeRange = true,
				timelineIndex = 1,
				timerEndOffset = 9999,
				timerStartOffset = -15.300000190735,
				uuid = "d2d519a0-abf2-f311-bfe9-f07df06da33b",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				enabled = false,
				eventType = 19,
				execute = "-- [Debug] OnEventObjectScript\n-- Verbose logging of event-object scripts. Loops (self.used each fire).\n-- Raw callback is function(entityID, a2, a3, a4). The TensorReactions field names for the extra\n-- args aren't documented, and eventArgs is userdata (pairs() returns nothing), so we probe a wide\n-- set of candidate keys and print whichever come back non-nil to discover the real names.\n\nif not eventArgs then\n    self.used = true\n    return\nend\n\n-- Candidate keys for the entity and the three generic script args (a2/a3/a4).\nlocal candidates = {\n    \"entityID\", \"entityId\", \"sourceEntityID\", \"targetID\", \"targetId\",\n    \"a1\", \"a2\", \"a3\", \"a4\",\n    \"arg1\", \"arg2\", \"arg3\", \"arg4\",\n    \"param1\", \"param2\", \"param3\", \"param4\",\n    \"data1\", \"data2\", \"data3\", \"data4\",\n    \"value\", \"value1\", \"value2\", \"value3\",\n    \"intValue\", \"intValue1\", \"intValue2\", \"intValue3\",\n    \"scriptID\", \"eventID\", \"eobjID\", \"state\", \"flags\", \"type\",\n    \"spellID\", \"actionID\", \"markerID\", \"heading\",\n}\n\nlocal parts = {}\nfor _, key in ipairs(candidates) do\n    local v = eventArgs[key]\n    if v ~= nil then\n        parts[#parts + 1] = key .. \"=\" .. tostring(v)\n    end\nend\n\nd(\"[Debug EObjScript] \" .. (#parts > 0 and table.concat(parts, \", \") or \"<no known fields found>\"))\n\n-- Resolve the acting entity if we can find an id.\nlocal entId = eventArgs.entityID or eventArgs.entityId or eventArgs.sourceEntityID\nlocal ent = entId and TensorCore.mGetEntity(entId)\nif ent then\n    d(\"[Debug EObjScript]   entity: name=\" .. tostring(ent.name) ..\n        \" id=\" .. tostring(ent.id) ..\n        \" cid=\" .. tostring(ent.contentid) ..\n        \" bnpc=\" .. tostring(ent.bnpcid) ..\n        \" type=\" .. tostring(ent.type) ..\n        (ent.pos and (\" pos=\" .. string.format(\"%.1f, %.1f, %.1f\", ent.pos.x, ent.pos.y, ent.pos.z)) or \"\"))\nend\n\nself.used = true\n",
				executeType = 2,
				loop = true,
				mechanicTime = 15.282,
				name = "[Debug] OnEventObjectScript",
				timeRange = true,
				timelineIndex = 1,
				timerEndOffset = 9999,
				timerStartOffset = -15.300000190735,
				uuid = "81202d99-a1fa-2f8c-b759-94d93c8ac079",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				enabled = false,
				eventType = 15,
				execute = "-- [Debug] OnTetherChange\n-- Verbose logging of every tether change. Loops (self.used each fire).\n-- Callback: (sourceEntityID, oldTetherID, oldTetherFlags, oldTargetID, newTetherID, newTetherFlags, newTargetID)\n\nif not eventArgs then\n    self.used = true\n    return\nend\n\nlocal sourceId = eventArgs.sourceEntityID or eventArgs.sourceID\nlocal newTgt   = eventArgs.newTargetID\nlocal oldTgt   = eventArgs.oldTargetID\n\nd(\"[Debug Tether] source=\" .. tostring(sourceId) ..\n    \" oldTetherID=\" .. tostring(eventArgs.oldTetherID) ..\n    \" oldFlags=\" .. tostring(eventArgs.oldTetherFlags) ..\n    \" oldTargetID=\" .. tostring(oldTgt) ..\n    \" newTetherID=\" .. tostring(eventArgs.newTetherID) ..\n    \" newFlags=\" .. tostring(eventArgs.newTetherFlags) ..\n    \" newTargetID=\" .. tostring(newTgt))\n\nlocal function logEnt(label, id)\n    if not id then return end\n    local e = TensorCore.mGetEntity(id)\n    if e then\n        d(\"[Debug Tether]   \" .. label .. \": name=\" .. tostring(e.name) ..\n            \" id=\" .. tostring(e.id) ..\n            \" cid=\" .. tostring(e.contentid) ..\n            \" bnpc=\" .. tostring(e.bnpcid) ..\n            \" type=\" .. tostring(e.type) ..\n            (e.pos and (\" pos=\" .. string.format(\"%.1f, %.1f, %.1f\", e.pos.x, e.pos.y, e.pos.z)) or \"\"))\n    else\n        d(\"[Debug Tether]   \" .. label .. \": <not found> (id=\" .. tostring(id) .. \")\")\n    end\nend\n\nlogEnt(\"source\", sourceId)\nlogEnt(\"newTarget\", newTgt)\n\nself.used = true\n",
				executeType = 2,
				loop = true,
				mechanicTime = 15.282,
				name = "[Debug] OnTetherChange",
				timeRange = true,
				timelineIndex = 1,
				timerEndOffset = 9999,
				timerStartOffset = -15.300000190735,
				uuid = "9b415e4e-fcdb-7c91-8187-6a4af92b2872",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				execute = "-- Fake ice\nArgus.setActionAOEType(47771, 0, 0)\nArgus.setActionAOEType(47771, 1, 0)\n\n-- Fake thunder\nArgus.setActionAOEType(47776, 0, 0)\nArgus.setActionAOEType(47776, 1, 0)\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 15.282,
				name = "[PerpCore] Setup",
				timelineIndex = 1,
				timerOffset = -15.300000190735,
				uuid = "46086115-9d9e-0287-a82a-76083695deb4",
				version = 2,
			},
		},
	}, 
	[3] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 4,
				execute = "-- [MM1] Callout Safespot\n-- OnEntityMarkerAdd\n-- Collect markers (min 4), resolve stack/spread + inside/outside cleave and shotcall (once).\n-- Then highlight the ice safe spots in green via PerpCore.DrawAOESafespots: real ice (47768) are the\n-- danger zones (rotated 90 CW to the safe spots); fake ice (47771) AOEs are already the safe spots.\n\nlocal SPREAD_MARKER = 127\nlocal FIRE_TRUE     = 674\nlocal FIRE_FALSE    = 673\nlocal ICE_TRUE      = 676\nlocal ICE_FALSE     = 675\n\nlocal REAL_ICE      = 47768 -- danger zones -> rotate 90 CW to find the safe spots\nlocal FAKE_ICE      = 47771 -- already the safe spots -> draw as-is\n\ndata.mm1Markers     = data.mm1Markers or {}\ntable.insert(data.mm1Markers, eventArgs.markerID)\n\n-- Wait until at least 4 markers have arrived\nif #data.mm1Markers < 4 then\n    return\nend\n\n-- Scan collected markers\nlocal hasSpread, fire, ice = false, nil, nil\nfor _, id in ipairs(data.mm1Markers) do\n    if id == SPREAD_MARKER then hasSpread = true end\n    if id == FIRE_TRUE then fire = true end\n    if id == FIRE_FALSE then fire = false end\n    if id == ICE_TRUE then ice = true end\n    if id == ICE_FALSE then ice = false end\nend\n\n-- Need both fire and ice resolved before we can call\nif fire == nil or ice == nil then\n    return\nend\n\n-- Callout once. Markers resolve independently of (and usually before) the AOEs spawning, so we\n-- fire the shotcall immediately and gate only the drawing on the AOEs below.\nif not data.mm1CalledOut then\n    local mechanic = hasSpread and \"Spread\" or \"Stack\"\n    -- Fire false inverts the mechanic\n    if not fire then\n        mechanic = (mechanic == \"Spread\") and \"Stack\" or \"Spread\"\n    end\n    -- Ice true = outside cleave, ice false = inside cleave\n    local cleave = ice and \"outside\" or \"inside\"\n    local shotcall = mechanic .. \" \" .. cleave .. \" cleave\"\n    if AnyoneCore and AnyoneCore.Shotcall then\n        AnyoneCore.Shotcall(shotcall, false, 5, false, 100)\n    end\n    data.mm1CalledOut = true\nend\n\n-- Ice true = real ice (danger 47768, rotate to safe); ice false = fake ice (safe 47771, as-is).\nif not (PerpCore and PerpCore.DrawAOESafespots) then\n    return\nend\nlocal drawn = PerpCore.DrawAOESafespots({ aoeId = ice and REAL_ICE or FAKE_ICE, rotate = (ice == true) })\n\n-- Returning without self.used keeps the reaction armed so it re-checks on the next marker event.\nif drawn < 2 then\n    return\nend\n\ndata.mm1Markers   = {}\ndata.mm1CalledOut = nil\nself.used         = true\n",
				executeType = 2,
				mechanicTime = 29,
				name = "[MM1] Callout Safespot",
				timeRange = true,
				timelineIndex = 3,
				timerEndOffset = 10,
				uuid = "de7fdfb1-216b-183a-832e-29788c2e55bc",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
					
					{
						data = 
						{
							aType = "Lua",
							actionLua = "AnyoneCore.Shotcall(\"GO TO CONGA SPOT\", false, 5, false, 100)\nself.used = true",
							conditions = 
							{
								
								{
									"26b9b903-f46d-d680-a956-6ba1cdf90fa9",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "c4a80348-cb81-c2f2-9172-a29f1f2b343b",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Event",
							eventArgType = 2,
							eventSpellID = 47764,
							name = "Is Mystery Magic",
							uuid = "26b9b903-f46d-d680-a956-6ba1cdf90fa9",
							version = 3,
						},
					},
				},
				eventType = 2,
				mechanicTime = 29,
				name = "Conga Reminder",
				timeRange = true,
				timelineIndex = 3,
				timerEndOffset = 15,
				uuid = "f33d240e-3e94-cfe3-b311-174392303dbf",
				version = 2,
			},
		},
	},
	[6] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 18,
				execute = "-- Callout Tower\n-- OnAOECreate\n-- Tower AOEs: avoid if we have the magic vuln buff, otherwise soak and draw the tower circle.\n\nlocal TOWER_AOE  = 47786\nlocal MAGIC_VULN = 2941\n\nif eventArgs.aoeID ~= TOWER_AOE then\n    return\nend\n\nlocal me = PerpCore.GetPlayer(data.perspective)\nlocal hasBuff = me and TensorCore and TensorCore.hasBuff and TensorCore.hasBuff(me, MAGIC_VULN)\n\nif hasBuff then\n    AnyoneCore.Shotcall(\"Avoid Tower\", false, 5, false, 100)\n    self.used = true\nelse\n    AnyoneCore.Shotcall(\"Soak Tower\", false, 5, false, 100)\n\n    -- Draw a green circle matching the AOE's radius and duration\n    if Argus2 and Argus2.addTimedCircleFilled then\n        local durationMs   = (eventArgs.duration or 5) * 1000\n        local greenFill    = GUI:ColorConvertFloat4ToU32(0, 1, 0, 0.4)\n        local greenOutline = GUI:ColorConvertFloat4ToU32(0, 1, 0, 1)\n        Argus2.addTimedCircleFilled(durationMs, eventArgs.x, eventArgs.y, eventArgs.z, eventArgs.aoeLength, 32, greenFill, greenOutline)\n    end\n    self.used = true\nend\n",
				executeType = 2,
				mechanicTime = 37.953,
				name = "Callout Tower",
				timeRange = true,
				timelineIndex = 6,
				timerEndOffset = 10,
				uuid = "b4426b57-f12a-4be2-9e23-faa15d5dd1cf",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
					
					{
						data = 
						{
							aType = "Lua",
							actionLua = "-- Callout Confetti\n-- OnEntityCast (spellID checked by reaction condition)\n-- Iterate the party, find everyone with Confetti (5078), draw a purple circle that follows\n-- them for the buff's duration, and shotcall \"Knockback Party\" if one of them is me.\n\nlocal CONFETTI      = 5078\nlocal CIRCLE_RADIUS = 6\n\nlocal party = PerpCore.GetPartyEntities() or {}\nlocal me = PerpCore.GetPlayer(data.perspective)\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal drawer = TensorCore.getStaticDrawer(purple, 2)\n\nlocal iHaveIt = false\nfor _, ent in ipairs(party) do\n    if ent and ent.id and ent.buffs then\n        local duration\n        for _, b in pairs(ent.buffs) do\n            if b and tonumber(b.id) == CONFETTI then\n                duration = tonumber(b.duration) or 5\n                break\n            end\n        end\n        if duration then\n            drawer:addTimedCircleOnEnt(duration * 1000, ent.id, CIRCLE_RADIUS)\n            if me and ent.id == me.id then\n                iHaveIt = true\n            end\n        end\n    end\nend\n\nif iHaveIt and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(\"Knockback Party\", false, 5, false, 100)\nend\n\nself.used = true",
							conditions = 
							{
								
								{
									"d24aa2a2-bcc6-dbad-aedf-5dab2103ed3a",
									true,
								},
							},
							gVar = "ACR_RikuNIN3_CD",
							uuid = "552ef09d-a394-958d-ae5f-f36dfc36b6a6",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Event",
							eventArgType = 2,
							eventSpellID = 47786,
							name = "Is Explosion",
							uuid = "d24aa2a2-bcc6-dbad-aedf-5dab2103ed3a",
							version = 3,
						},
					},
				},
				eventType = 2,
				mechanicTime = 37.953,
				name = "Callout Confetti",
				timeRange = true,
				timelineIndex = 6,
				timerEndOffset = 10,
				uuid = "a37e1277-3430-bb17-bbfc-0f224bd0362b",
				version = 2,
			},
		},
	},
	[10] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 4,
				execute = "-- [MM2] Callout Safespot\n-- OnEntityMarkerAdd\n-- Wait for 2 markers (Thunder/Ice true/false), then wait until every expected AOE has spawned\n-- and colour them: real AOEs solid red (avoid), fake + danger AOEs solid green (safe).\n\n-- Markers we gate on\nlocal THUNDER_TRUE    = 678\nlocal THUNDER_FALSE   = 677\nlocal ICE_TRUE        = 676\nlocal ICE_FALSE       = 675\nlocal WATCHED_MARKERS = {\n    [THUNDER_TRUE] = true,\n    [THUNDER_FALSE] = true,\n    [ICE_TRUE] = true,\n    [ICE_FALSE] = true,\n}\n\n-- AOE ids\nlocal REAL_ICE        = 47768\nlocal FAKE_ICE        = 47771\nlocal REAL_THUNDER    = 47775\nlocal FAKE_THUNDER    = 47776\nlocal THUNDER_DANGER  = 47777 -- spawns when thunder is fake\nlocal ICE_DANGER      = 47774 -- spawns when ice is fake\n\n-- Colour groups: real + danger variants are the actual damage zones (red, avoid);\n-- fake AOEs are the safe spots (green).\nlocal RED_IDS         = { [REAL_ICE] = true, [REAL_THUNDER] = true, [ICE_DANGER] = true, [THUNDER_DANGER] = true }\nlocal GREEN_IDS       = { [FAKE_ICE] = true, [FAKE_THUNDER] = true }\n\n-- ---------------------------------------------------------------------------\n-- Marker collection: wait until 2 of the watched markers have arrived\n-- ---------------------------------------------------------------------------\nlocal markerId        = eventArgs and tonumber(eventArgs.markerID)\nif not markerId or not WATCHED_MARKERS[markerId] then\n    return\nend\n\ndata.mm2Markers = data.mm2Markers or {}\ntable.insert(data.mm2Markers, markerId)\n\nif #data.mm2Markers < 2 then\n    return\nend\n\n-- ---------------------------------------------------------------------------\n-- Shape drawing + AOE gathering helpers\n-- ---------------------------------------------------------------------------\n-- Draw with Argus2 filled shapes. Default gradient intensity, but gradientMinOpacity = 1 so the\n-- fill stays fully opaque (doesn't fade out). Trailing args are positional: colorMid, delay,\n-- entityAttach, [targetAttach], [keepLength], colorOutline, outlineThickness, gradientIntensity,\n-- gradientMinOpacity.\nlocal MIN_OPACITY = 1\nlocal function drawShape(color, aoe)\n    if not Argus2 then return end\n    local ct  = tonumber(aoe.aoeCastType) or 0\n    local L   = tonumber(aoe.aoeLength) or 0\n    local W   = tonumber(aoe.aoeWidth) or 0\n    local h   = tonumber(aoe.heading) or 0\n    local ms  = 4700\n    local SEG = 48\n    if ct == 2 or ct == 5 or ct == 7 or ct == 6 then\n        Argus2.addTimedCircleFilled(ms, aoe.x, aoe.y, aoe.z, L, SEG, color, color, nil, 0, nil, nil, nil, 3, MIN_OPACITY)\n    elseif ct == 3 or ct == 13 then\n        Argus2.addTimedConeFilled(ms, aoe.x, aoe.y, aoe.z, L, math.rad(90), h, SEG, color, color, nil, 0, nil, nil, nil,\n            nil, 4, MIN_OPACITY)\n    elseif ct == 4 or ct == 12 or ct == 8 then\n        Argus2.addTimedRectFilled(ms, aoe.x, aoe.y, aoe.z, L, W, h, color, color, nil, 0, nil, nil, false, nil, nil, 4,\n            MIN_OPACITY)\n    elseif ct == 10 then\n        local inner = W > 0 and W or (L * 0.4)\n        Argus2.addTimedDonutFilled(ms, aoe.x, aoe.y, aoe.z, inner, L, SEG, color, color, nil, 0, nil, nil, nil, 2,\n            MIN_OPACITY)\n    elseif ct == 11 then\n        Argus2.addTimedCrossFilled(ms, aoe.x, aoe.y, aoe.z, L, W, h, color, color, nil, 0, nil, nil, nil, nil, 4,\n            MIN_OPACITY)\n    else\n        Argus2.addTimedCircleFilled(ms, aoe.x, aoe.y, aoe.z, (L > 0 and L or 3), SEG, color, color, nil, 0, nil, nil, nil,\n            3, MIN_OPACITY)\n    end\nend\n\nlocal function gatherAOEs()\n    local out = {}\n    if Argus then\n        if Argus.getCurrentGroundAOEs then\n            for _, a in pairs(Argus.getCurrentGroundAOEs() or {}) do out[#out + 1] = a end\n        end\n        if Argus.getCurrentDirectionalAOEs then\n            for _, a in pairs(Argus.getCurrentDirectionalAOEs(true) or {}) do out[#out + 1] = a end\n        end\n    end\n    return out\nend\n\n-- ---------------------------------------------------------------------------\n-- Work out which AOEs to expect from the markers (real -> real AOE only;\n-- fake -> fake AOE + its danger variant), then wait until they have all spawned.\n-- ---------------------------------------------------------------------------\nlocal expected = {}\nfor _, v in ipairs(data.mm2Markers) do\n    if v == THUNDER_TRUE then\n        expected[REAL_THUNDER] = true\n    elseif v == THUNDER_FALSE then\n        expected[FAKE_THUNDER] = true\n        expected[THUNDER_DANGER] = true\n    elseif v == ICE_TRUE then\n        expected[REAL_ICE] = true\n    elseif v == ICE_FALSE then\n        expected[FAKE_ICE] = true\n        expected[ICE_DANGER] = true\n    end\nend\n\nlocal allAoes = gatherAOEs()\nlocal present = {}\nfor _, a in ipairs(allAoes) do present[tonumber(a.aoeID)] = true end\n\n-- Returning without self.used keeps the reaction armed so it re-checks on the next marker event.\nfor id in pairs(expected) do\n    if not present[id] then\n        return\n    end\nend\n\n-- ---------------------------------------------------------------------------\n-- Draw: real + danger AOEs solid red, fake AOEs solid green\n-- ---------------------------------------------------------------------------\nlocal redSolid   = GUI:ColorConvertFloat4ToU32(1, 0, 0, 1)\nlocal greenSolid = GUI:ColorConvertFloat4ToU32(0, 1, 0, 1)\n\n-- Draw green (fake) first so red (real/danger) layers on top where they overlap.\nfor _, a in ipairs(allAoes) do\n    local id = tonumber(a.aoeID)\n    if GREEN_IDS[id] then\n        drawShape(greenSolid, a)\n    end\nend\nfor _, a in ipairs(allAoes) do\n    local id = tonumber(a.aoeID)\n    if RED_IDS[id] then\n        drawShape(redSolid, a)\n    end\nend\n\n-- Shotcall the ice/thunder real/fake combination.\nlocal iceReal, thunderReal\nfor _, v in ipairs(data.mm2Markers) do\n    if v == ICE_TRUE then\n        iceReal = true\n    elseif v == ICE_FALSE then\n        iceReal = false\n    elseif v == THUNDER_TRUE then\n        thunderReal = true\n    elseif v == THUNDER_FALSE then\n        thunderReal = false\n    end\nend\n\nlocal call\nif iceReal and thunderReal then\n    call = \"Both real\"\nelseif iceReal == false and thunderReal == false then\n    call = \"Both fake\"\nelseif iceReal and thunderReal == false then\n    call = \"Ice real, Thunder fake\"\nelseif iceReal == false and thunderReal then\n    call = \"Ice fake, Thunder real\"\nend\n\nif call and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(call, false, 5, false, 100)\nend\n\ndata.mm2Markers = {}\nself.used = true\n",
				executeType = 2,
				mechanicTime = 49.422,
				name = "[MM2] Callout Safespot",
				timeRange = true,
				timelineIndex = 10,
				timerEndOffset = 10,
				timerStartOffset = -5,
				uuid = "c490d3ea-caae-a7fe-8859-9baa90462314",
				version = 2,
			},
		},
	},
	[16] = 
	{
		
		{
			data = 
			{
				actions = 
				{
					
					{
						data = 
						{
							aType = "Lua",
							actionLua = "-- Graven 2 First Tethers\n-- OnTetherChange (tether id 45 checked by the reaction condition)\n-- Every living player is tethered (tether id 45) to one of two orb NPCs. Only 2 unique source\n-- positions exist; the higher orb is purple, the lower orb is yellow. The event can fire before\n-- both tethers exist, so we stay armed until both source positions are present, then draw a purple\n-- circle (6s) / yellow circle (10s) on every player and shotcall our own colour.\n\nlocal TETHER_ID     = 45\nlocal CIRCLE_RADIUS = 6\nlocal PURPLE_MS     = 9000\nlocal YELLOW_MS     = 13000\n\nif not (Argus and Argus.getTethersOnEnt and TensorCore and PerpCore) then\n    return\nend\n\nlocal party = PerpCore.GetPartyEntities() or {}\n\n-- Group players by their tether source position (4 share each of the 2 unique spots).\nlocal function posKey(p)\n    return string.format(\"%.1f_%.1f_%.1f\", p.x or 0, p.y or 0, p.z or 0)\nend\n\nlocal groups = {} -- key -> { y = sourceHeight, players = { ent, ... } }\nlocal order  = {} -- discovery order so we can iterate the groups\n\nfor _, member in ipairs(party) do\n    if member and member.id then\n        local tethers = Argus.getTethersOnEnt(member.id)\n        if tethers then\n            for i = 1, #tethers do\n                local t = tethers[i]\n                if tonumber(t.type) == TETHER_ID and t.partnerid then\n                    local src = TensorCore.mGetEntity(t.partnerid)\n                    if src and src.pos then\n                        local k = posKey(src.pos)\n                        local g = groups[k]\n                        if not g then\n                            g = { y = src.pos.y or 0, players = {} }\n                            groups[k] = g\n                            order[#order + 1] = g\n                        end\n                        g.players[#g.players + 1] = member\n                    end\n                    break\n                end\n            end\n        end\n    end\nend\n\n-- Stay armed until both unique source positions exist so we can tell purple (higher) from yellow (lower).\nif #order < 2 then\n    return\nend\n\n-- The source with the greatest height is the purple tether; everything else is yellow.\nlocal purpleGroup\nfor _, g in ipairs(order) do\n    if not purpleGroup or g.y > purpleGroup.y then\n        purpleGroup = g\n    end\nend\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal yellow = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\nlocal purpleDrawer = TensorCore.getStaticDrawer(purple, 2)\nlocal yellowDrawer = TensorCore.getStaticDrawer(yellow, 2)\n\nlocal me = PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nlocal myIsPurple\n\nfor _, g in ipairs(order) do\n    local isPurple = (g == purpleGroup)\n    local drawer = isPurple and purpleDrawer or yellowDrawer\n    local ms = isPurple and PURPLE_MS or YELLOW_MS\n    for _, member in ipairs(g.players) do\n        drawer:addTimedCircleOnEnt(ms, member.id, CIRCLE_RADIUS)\n        if me and member.id == me.id then\n            myIsPurple = isPurple\n        end\n    end\nend\n\n-- Shotcall our own tether colour.\nif myIsPurple ~= nil and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(myIsPurple and \"Purple Tether\" or \"Yellow Tether\", false, 5, false, 100)\nend\n\nself.used = true\n",
							conditions = 
							{
								
								{
									"3e4d1c28-5130-d749-9dd6-ce9d82ea34dc",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "17b471da-97f1-1a15-ad95-e98651517306",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Event",
							comparator = 3,
							eventArgType = 5,
							eventIntValue = 45,
							name = "Is Graven Tether",
							uuid = "3e4d1c28-5130-d749-9dd6-ce9d82ea34dc",
							version = 3,
						},
					},
				},
				eventType = 15,
				mechanicTime = 80.063,
				name = "Graven 2 First Tethers",
				timeRange = true,
				timelineIndex = 16,
				timerEndOffset = 10,
				uuid = "bb656131-607b-cccc-8ac5-a094e601a1af",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 4,
				execute = "-- Graven 2 Safespot\n-- OnEntityMarkerAdd\n-- A single ice marker resolves the mechanic: Ice True (676) = outside cleave, Ice False (675) = inside.\n-- After the callout, highlight the ice safe spots in green via PerpCore.DrawAOESafespots: real ice\n-- (47768) are the danger zones (rotated 90 CW to the safe spots); fake ice (47771) are already safe.\n\nlocal ICE_TRUE  = 676\nlocal ICE_FALSE = 675\n\nlocal REAL_ICE  = 47768 -- danger zones -> rotate 90 CW to find the safe spots\nlocal FAKE_ICE  = 47771 -- already the safe spots -> draw as-is\n\nlocal marker    = eventArgs and eventArgs.markerID\n\nlocal ice\nif marker == ICE_TRUE then\n    ice = true\nelseif marker == ICE_FALSE then\n    ice = false\nend\n\n-- Stay armed until one of the ice markers shows up.\nif ice == nil then\n    return\nend\n\n-- Callout once. Ice true = outside cleave, ice false = inside cleave.\nif not data.graven2CalledOut then\n    if AnyoneCore and AnyoneCore.Shotcall then\n        AnyoneCore.Shotcall(ice and \"Outside Cleave\" or \"Inside Cleave\", false, 5, false, 100)\n    end\n    data.graven2CalledOut = true\nend\n\n-- Ice true = real ice (danger 47768, rotate to safe); ice false = fake ice (safe 47771, as-is).\nif not (PerpCore and PerpCore.DrawAOESafespots) then\n    return\nend\nlocal drawn = PerpCore.DrawAOESafespots({ aoeId = ice and REAL_ICE or FAKE_ICE, rotate = (ice == true) })\n\n-- Returning without self.used keeps the reaction armed so it re-checks on the next marker event.\nif drawn < 2 then\n    return\nend\n\ndata.graven2CalledOut = nil\nself.used = true\n",
				executeType = 2,
				mechanicTime = 80.063,
				name = "Graven 2 Safespot",
				timeRange = true,
				timelineIndex = 16,
				timerEndOffset = 10,
				uuid = "e5eb6d88-ed49-fd50-a594-cfee32a7d00f",
				version = 2,
			},
		},
	},
	[18] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 19,
				execute = "-- Graven 2 Room Cleave\n-- OnEventObjectScript\n-- The cleaving orb is identified by its content id: yellow (2015165) cleaves the EAST half,\n-- purple (2015164) cleaves the WEST half. Draw a 180-degree cone from arena center that way.\n\nlocal YELLOW_CID = 2015165\nlocal PURPLE_CID = 2015164\nlocal CENTER     = { x = 100, y = 0, z = 100 }\nlocal RADIUS     = 40\nlocal DRAW_MS    = 8000\nlocal CONE_ANGLE = math.rad(180)\nlocal SEG        = 64\n\nlocal entId = eventArgs and (eventArgs.entityID or eventArgs.entityId)\nlocal ent   = entId and TensorCore.mGetEntity(entId)\nlocal cid   = ent and tonumber(ent.contentid)\n\n-- Stay armed until the cleaving orb (one of the two content ids) shows up.\nif cid ~= YELLOW_CID and cid ~= PURPLE_CID then\n    return\nend\n\nif not (Argus2 and TensorCore and GUI) then\n    self.used = true\n    return\nend\n\nlocal isYellow = (cid == YELLOW_CID)\n\n-- East = +x, West = -x. Use getHeadingToTarget so the heading matches the cone draw convention.\nlocal dirPoint = {\n    x = CENTER.x + (isYellow and 10 or -10),\n    y = CENTER.y,\n    z = CENTER.z,\n}\nlocal heading = TensorCore.getHeadingToTarget(CENTER, dirPoint)\n\nlocal fill, outline\nif isYellow then\n    fill    = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 1)\nelse\n    fill    = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 1)\nend\n\nArgus2.addTimedConeFilled(DRAW_MS, CENTER.x, CENTER.y, CENTER.z, RADIUS, CONE_ANGLE, heading, SEG, fill, outline)\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 91.172,
				name = "Graven 2 Room Cleave",
				timeRange = true,
				timelineIndex = 18,
				timerEndOffset = 15,
				uuid = "e72e90e5-d085-efa4-9b4b-713dbd093e1e",
				version = 2,
			},
			inheritedIndex = 1,
		},
		
		{
			data = 
			{
				actions = 
				{
					
					{
						data = 
						{
							aType = "Lua",
							actionLua = "-- Graven 2 Second Tethers\n-- OnTetherChange (tether id 45 checked by the reaction condition)\n-- Same as Graven 2 First Tethers: every living player is tethered (tether id 45) to one of two orb\n-- NPCs. Only 2 unique source positions exist; the higher orb is purple, the lower orb is yellow.\n-- The event can fire before both tethers exist, so we stay armed until both source positions are\n-- present, then draw a purple circle (6s) / yellow circle (10s) on each player and shotcall our colour.\n\nlocal TETHER_ID     = 45\nlocal CIRCLE_RADIUS = 6\nlocal PURPLE_MS     = 9000\nlocal YELLOW_MS     = 13000\n\nif not (Argus and Argus.getTethersOnEnt and TensorCore and PerpCore) then\n    return\nend\n\nlocal party = PerpCore.GetPartyEntities() or {}\n\n-- Group players by their tether source position (4 share each of the 2 unique spots).\nlocal function posKey(p)\n    return string.format(\"%.1f_%.1f_%.1f\", p.x or 0, p.y or 0, p.z or 0)\nend\n\nlocal groups = {} -- key -> { y = sourceHeight, players = { ent, ... } }\nlocal order  = {} -- discovery order so we can iterate the groups\n\nfor _, member in ipairs(party) do\n    if member and member.id then\n        local tethers = Argus.getTethersOnEnt(member.id)\n        if tethers then\n            for i = 1, #tethers do\n                local t = tethers[i]\n                if tonumber(t.type) == TETHER_ID and t.partnerid then\n                    local src = TensorCore.mGetEntity(t.partnerid)\n                    if src and src.pos then\n                        local k = posKey(src.pos)\n                        local g = groups[k]\n                        if not g then\n                            g = { y = src.pos.y or 0, players = {} }\n                            groups[k] = g\n                            order[#order + 1] = g\n                        end\n                        g.players[#g.players + 1] = member\n                    end\n                    break\n                end\n            end\n        end\n    end\nend\n\n-- Stay armed until both unique source positions exist so we can tell purple (higher) from yellow (lower).\nif #order < 2 then\n    return\nend\n\n-- The source with the greatest height is the purple tether; everything else is yellow.\nlocal purpleGroup\nfor _, g in ipairs(order) do\n    if not purpleGroup or g.y > purpleGroup.y then\n        purpleGroup = g\n    end\nend\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal yellow = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\nlocal purpleDrawer = TensorCore.getStaticDrawer(purple, 2)\nlocal yellowDrawer = TensorCore.getStaticDrawer(yellow, 2)\n\nlocal me = PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nlocal myIsPurple\n\nfor _, g in ipairs(order) do\n    local isPurple = (g == purpleGroup)\n    local drawer = isPurple and purpleDrawer or yellowDrawer\n    local ms = isPurple and PURPLE_MS or YELLOW_MS\n    for _, member in ipairs(g.players) do\n        drawer:addTimedCircleOnEnt(ms, member.id, CIRCLE_RADIUS)\n        if me and member.id == me.id then\n            myIsPurple = isPurple\n        end\n    end\nend\n\n-- Shotcall our own tether colour.\nif myIsPurple ~= nil and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(myIsPurple and \"Purple Tether\" or \"Yellow Tether\", false, 5, false, 100)\nend\n\nself.used = true\n",
							conditions = 
							{
								
								{
									"3e4d1c28-5130-d749-9dd6-ce9d82ea34dc",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "17b471da-97f1-1a15-ad95-e98651517306",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Event",
							comparator = 3,
							eventArgType = 5,
							eventIntValue = 45,
							name = "Is Graven Tether",
							uuid = "3e4d1c28-5130-d749-9dd6-ce9d82ea34dc",
							version = 3,
						},
					},
				},
				eventType = 15,
				mechanicTime = 91.172,
				name = "Graven 2 Second Tethers",
				timeRange = true,
				timelineIndex = 18,
				timerEndOffset = 15,
				timerStartOffset = 5,
				uuid = "774391ee-eee0-7ed3-a83a-dbb5be71fdb3",
				version = 2,
			},
		},
	},
	[20] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 19,
				execute = "-- Graven 2 Room Cleave 2\n-- OnEventObjectScript\n-- The cleaving orb is identified by its content id: yellow (2015165) cleaves the EAST half,\n-- purple (2015164) cleaves the WEST half. Draw a 180-degree cone from arena center that way.\n\nlocal YELLOW_CID = 2015165\nlocal PURPLE_CID = 2015164\nlocal CENTER     = { x = 100, y = 0, z = 100 }\nlocal RADIUS     = 40\nlocal DRAW_MS    = 8000\nlocal CONE_ANGLE = math.rad(180)\nlocal SEG        = 64\n\nlocal entId = eventArgs and (eventArgs.entityID or eventArgs.entityId)\nlocal ent   = entId and TensorCore.mGetEntity(entId)\nlocal cid   = ent and tonumber(ent.contentid)\n\n-- Stay armed until the cleaving orb (one of the two content ids) shows up.\nif cid ~= YELLOW_CID and cid ~= PURPLE_CID then\n    return\nend\n\nif not (Argus2 and TensorCore and GUI) then\n    self.used = true\n    return\nend\n\nlocal isYellow = (cid == YELLOW_CID)\n\n-- East = +x, West = -x. Use getHeadingToTarget so the heading matches the cone draw convention.\nlocal dirPoint = {\n    x = CENTER.x + (isYellow and 10 or -10),\n    y = CENTER.y,\n    z = CENTER.z,\n}\nlocal heading = TensorCore.getHeadingToTarget(CENTER, dirPoint)\n\nlocal fill, outline\nif isYellow then\n    fill    = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 1)\nelse\n    fill    = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 1)\nend\n\nArgus2.addTimedConeFilled(DRAW_MS, CENTER.x, CENTER.y, CENTER.z, RADIUS, CONE_ANGLE, heading, SEG, fill, outline)\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 100.233,
				name = "Graven 2 Room Cleave 2",
				timeRange = true,
				timelineIndex = 20,
				timerEndOffset = 15,
				timerStartOffset = 5,
				uuid = "41c0b352-c6d4-1025-b26e-63b6d871f90c",
				version = 2,
			},
			inheritedIndex = 1,
		},
	},
	[25] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				execute = "-- Confetti Reminder\n-- OnUpdate\n-- When a player's Confetti (5078) has <= 5s left, draw a purple circle on them. If it's us, also\n-- shotcall \"Knockback Party\". Resolve (self.used) once we've drawn.\n\nlocal CONFETTI      = 5078\nlocal CIRCLE_RADIUS = 6\n\nlocal party = PerpCore.GetPartyEntities() or {}\nlocal me = PerpCore.GetPlayer(data.perspective)\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal drawer = TensorCore.getStaticDrawer(purple, 2)\n\nlocal drewAny = false\nlocal iHaveIt = false\n\nfor _, ent in ipairs(party) do\n    if ent and ent.id and ent.buffs then\n        local duration\n        for _, b in pairs(ent.buffs) do\n            if b and tonumber(b.id) == CONFETTI then\n                duration = tonumber(b.duration) or 0\n                break\n            end\n        end\n        if duration and duration <= 5 then\n            drawer:addTimedCircleOnEnt(duration * 1000, ent.id, CIRCLE_RADIUS)\n            drewAny = true\n            if me and ent.id == me.id then\n                iHaveIt = true\n            end\n        end\n    end\nend\n\n-- Nothing in the reminder window yet, keep waiting.\nif not drewAny then\n    return\nend\n\nif iHaveIt and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(\"Knockback Party\", false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 117.905,
				name = "Confetti Reminder",
				timeRange = true,
				timelineIndex = 25,
				timerStartOffset = -10,
				uuid = "1fadebb5-27d8-90f1-be00-9139cd7319d4",
				version = 2,
			},
		},
	},
	[31] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 8,
				execute = "-- Teleport Callout\n-- OnNewBuffEntry\n-- We get two teleport (Tele-portent) buffs. Each id maps to a direction. OnNewBuffEntry gives an\n-- unreliable entityID, so \"is it me\" is answered by reading our own buffs. Wait until we hold\n-- exactly two teleport buffs, then call them out in resolve order (lowest duration first).\n\nlocal DIRECTIONS = {\n    [4876] = \"Up\",    [5079] = \"Up\",\n    [4877] = \"Down\",  [5080] = \"Down\",\n    [4879] = \"Left\",  [5082] = \"Left\",\n    [4878] = \"Right\", [5081] = \"Right\",\n}\n\nlocal me = PerpCore and PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nif not me or not me.buffs then\n    return\nend\n\n-- Collect our own teleport buffs (keep duplicates -- e.g. two \"Up\" -> \"Up -> Up\").\nlocal mine = {}\nfor _, b in pairs(me.buffs) do\n    local id = b and tonumber(b.id)\n    local dir = id and DIRECTIONS[id]\n    if dir then\n        mine[#mine + 1] = { dir = dir, duration = tonumber(b.duration) or 0 }\n    end\nend\n\n-- Stay armed until we have both teleport buffs.\nif #mine < 2 then\n    return\nend\n\n-- Lowest duration resolves first.\ntable.sort(mine, function(a, b) return a.duration < b.duration end)\n\nlocal callout = mine[1].dir .. \" -> \" .. mine[2].dir\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(callout, false, 5, false, 100)\nend\n\n-- Hand off the resolve-ordered pair to \"Draw Teleport Spots\".\ndata.teleportPlacements = { mine[1].dir, mine[2].dir }\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 151.202,
				name = "Teleport Callout",
				timeRange = true,
				timelineIndex = 31,
				timerEndOffset = 10,
				uuid = "3ef8378e-5f3b-ccba-9e4a-deee25130751",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				execute = "-- Draw Teleport Spots\n-- Follow-up to \"Teleport Callout\". That reaction stores our resolve-ordered arrow pair in\n-- data.teleportPlacements (e.g. { \"Right\", \"Up\" }). Here we map that pair to one of the four\n-- intercardinals, find the nearest numbered ground marker, and draw the 4 arrow-spots (2x2)\n-- that resolve there -- our two in green, the other group's two in gray.\n\nlocal CENTER   = { x = 100, y = 0, z = 100 }\nlocal PROBE    = 20 -- how far off-center we look to find the intercardinal marker\nlocal OFFSET   = 3  -- half the 4-yalm spacing between adjacent spots\nlocal DRAW_MS  = 15000\nlocal CIRCLE_R = 2\nlocal SEG      = 32\n\n-- Stay armed until Teleport Callout has handed us both directions.\nlocal tp       = data.teleportPlacements\nif not tp or #tp < 2 then\n    return\nend\n\nif not (Argus2 and TensorCore and GUI and PerpCore) then\n    return\nend\n\n-- Chosen strat (\"Default\" or \"X13\"), set from the PerpGUI Reactions tab.\nlocal strat = (PerpCore.GetDMUPhase1ArrowsStrat and PerpCore.GetDMUPhase1ArrowsStrat()) or \"Default\"\n\n-- Unordered pair (sorted) -> intercardinal. Reversible by construction.\nlocal function pairKey(a, b)\n    if a <= b then return a .. \"|\" .. b end\n    return b .. \"|\" .. a\nend\n\nlocal ZONE_BY_PAIR = {\n    [\"Left|Left\"] = \"NE\",\n    [\"Right|Up\"] = \"NE\",\n    [\"Up|Up\"] = \"SE\",\n    [\"Down|Right\"] = \"SE\",\n    [\"Right|Right\"] = \"SW\",\n    [\"Down|Left\"] = \"SW\",\n    [\"Down|Down\"] = \"NW\",\n    [\"Left|Up\"] = \"NW\",\n}\n\n-- Intercardinal unit offset from center: north = -Z, east = +X.\nlocal ZONE_DIR     = {\n    NE = { x = 1, z = -1 },\n    SE = { x = 1, z = 1 },\n    SW = { x = -1, z = 1 },\n    NW = { x = -1, z = -1 },\n}\n\n-- Per-zone 2x2 layout: which arrow sits at each corner (top = north, left = west).\n-- Decoded from the reference image; NE matches the explicit callout.\nlocal ZONE_LAYOUT  = {\n    NE = { TL = \"Left\", TR = \"Left\", BL = \"Right\", BR = \"Up\" },\n    NW = { TL = \"Down\", TR = \"Left\", BL = \"Down\", BR = \"Up\" },\n    SW = { TL = \"Down\", TR = \"Left\", BL = \"Right\", BR = \"Right\" },\n    SE = { TL = \"Down\", TR = \"Up\", BL = \"Right\", BR = \"Up\" },\n}\n\n-- Corner -> world offset (OFFSET yalms). top = -Z, left = -X.\nlocal CORNER_OFF   = {\n    TL = { x = -OFFSET, z = -OFFSET },\n    TR = { x = OFFSET, z = -OFFSET },\n    BL = { x = -OFFSET, z = OFFSET },\n    BR = { x = OFFSET, z = OFFSET },\n}\n\n-- Direction -> world offset used to compute the arrow heading (where it points).\nlocal DIR_POINT    = {\n    Up    = { x = 0, z = -10 },\n    Down  = { x = 0, z = 10 },\n    Left  = { x = -10, z = 0 },\n    Right = { x = 10, z = 0 },\n}\n\nlocal key          = pairKey(tp[1], tp[2])\nlocal zone         = ZONE_BY_PAIR[key]\nif not zone then\n    return\nend\n\n-- Default: probe toward the zone, snap to the nearest waymark, lay a tight 2x2 around it.\nlocal function buildDefaultCorners()\n    local zd = ZONE_DIR[zone]\n    local probePos = { x = CENTER.x + zd.x * PROBE, y = CENTER.y, z = CENTER.z + zd.z * PROBE }\n    local marker = PerpCore.GetWaymarkClosestToEntity(probePos)\n    if not marker then\n        return nil\n    end\n    local out = {}\n    for _, c in ipairs({ \"TL\", \"TR\", \"BL\", \"BR\" }) do\n        local co = CORNER_OFF[c]\n        out[c] = { x = marker.x + co.x, y = marker.y, z = marker.z + co.z }\n    end\n    return out\nend\n\n-- X13: two anchor waymarks per zone, each fixed to one corner (the two known diagonal corners).\nlocal ZONE_ANCHORS = {\n    NE = { { mark = \"B\", corner = \"BL\" }, { mark = \"2\", corner = \"TR\" } },\n    SE = { { mark = \"C\", corner = \"TL\" }, { mark = \"3\", corner = \"BR\" } },\n    NW = { { mark = \"A\", corner = \"BR\" }, { mark = \"1\", corner = \"TL\" } },\n    SW = { { mark = \"D\", corner = \"TR\" }, { mark = \"4\", corner = \"BL\" } },\n}\n\n-- Rotating a known corner 90 degrees clockwise about the midpoint lands on this corner.\nlocal CW_NEXT = { TL = \"TR\", TR = \"BR\", BR = \"BL\", BL = \"TL\" }\n\n-- X13: place the two anchors, then fill the two blanks by rotating each anchor 90 CW about\n-- the midpoint of the anchor line. Returns nil if either waymark is missing/inactive.\nlocal function buildX13Corners()\n    local anchors = ZONE_ANCHORS[zone]\n    if not anchors then\n        return nil\n    end\n    local out = {}\n    for _, a in ipairs(anchors) do\n        local info = PerpCore.GetWaymarkInfo(a.mark)\n        if not info or not info.isActive then\n            return nil\n        end\n        out[a.corner] = { x = info.x, y = info.y, z = info.z }\n    end\n    local p1 = out[anchors[1].corner]\n    local p2 = out[anchors[2].corner]\n    local ox = (p1.x + p2.x) / 2\n    local oz = (p1.z + p2.z) / 2\n    -- Clockwise rotation about O in world axes (+X east, +Z south): (x,z) -> (-z, x).\n    for _, a in ipairs(anchors) do\n        local p = out[a.corner]\n        out[CW_NEXT[a.corner]] = {\n            x = ox - (p.z - oz),\n            y = p.y,\n            z = oz + (p.x - ox),\n        }\n    end\n    return out\nend\n\nlocal cornerPos\nif strat == \"X13\" then\n    cornerPos = buildX13Corners()\nend\nif not cornerPos then\n    cornerPos = buildDefaultCorners()\nend\nif not cornerPos then\n    return\nend\n\n-- Our placements in resolve order: tp[1] expires first (\"1\"), tp[2] second (\"2\").\nlocal ownOrder = {\n    { dir = tp[1], label = \"1\", used = false },\n    { dir = tp[2], label = \"2\", used = false },\n}\n\nlocal greenFill = GUI:ColorConvertFloat4ToU32(0, 1, 0, 0.30)\nlocal greenLine = GUI:ColorConvertFloat4ToU32(0, 1, 0, 1)\nlocal grayFill  = GUI:ColorConvertFloat4ToU32(0.55, 0.55, 0.55, 0.30)\nlocal grayLine  = GUI:ColorConvertFloat4ToU32(0.75, 0.75, 0.75, 1)\nlocal textColor = GUI:ColorConvertFloat4ToU32(1, 1, 1, 1)\n\nlocal layout    = ZONE_LAYOUT[zone]\nfor _, corner in ipairs({ \"TL\", \"TR\", \"BL\", \"BR\" }) do\n    local dir  = layout[corner]\n    local sp   = cornerPos[corner]\n    local sx   = sp.x\n    local sy   = sp.y\n    local sz   = sp.z\n\n    -- Ours = direction matches an unconsumed placement; grab its resolve-order label.\n    local label = nil\n    for _, o in ipairs(ownOrder) do\n        if not o.used and o.dir == dir then\n            o.used = true\n            label  = o.label\n            break\n        end\n    end\n    local mine = label ~= nil\n\n    local fill = mine and greenFill or grayFill\n    local line = mine and greenLine or grayLine\n\n    Argus2.addTimedCircleFilled(DRAW_MS, sx, sy, sz, CIRCLE_R, SEG, fill, line)\n\n    local dp = DIR_POINT[dir]\n    local heading = TensorCore.getHeadingToTarget(\n        { x = sx, y = sy, z = sz },\n        { x = sx + dp.x, y = sy, z = sz + dp.z }\n    )\n    -- addTimedArrowFilled draws from its origin along the heading, so push the origin back\n    -- half the length to center the arrow on the spot (edge to edge, short either side).\n    local ARROW_LEN = 2.0\n    local ux = dp.x / 10\n    local uz = dp.z / 10\n    local ax = sx - ux * (ARROW_LEN / 2)\n    local az = sz - uz * (ARROW_LEN / 2)\n    Argus2.addTimedArrowFilled(DRAW_MS, ax, sy, az, ARROW_LEN, 0.7, 0.6, 1.8, heading, fill, line)\n\n    -- Label our spots with their resolve order (1 = expires first).\n    if mine and AnyoneCore and AnyoneCore.addTimedWorldText then\n        AnyoneCore.addTimedWorldText(DRAW_MS, label, { x = sx, y = sy, z = sz }, textColor, true, 1.5)\n    end\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 151.202,
				name = "Draw Teleport Spots",
				throttleTime = 50,
				timeRange = true,
				timelineIndex = 31,
				timerEndOffset = 10,
				uuid = "278208bd-c56d-e5dc-bd5a-94b3eb5bd373",
				version = 2,
			},
		},
	},
	[34] = 
	{
		
		{
			data = 
			{
				actions = 
				{
					
					{
						data = 
						{
							aType = "Lua",
							actionLua = "-- Graven 3 Tethers\n-- OnTetherChange (tether id 45 checked by the reaction condition)\n-- Find our own tether source, then any other party member's tether source at a different position.\n-- Of the two unique sources, the HIGHER one is yellow and the lower one is purple.\n-- Callout our own colour, then set self.used = true (only if we made the callout).\n\nlocal TETHER_ID = 45\n\nif not (Argus and Argus.getTethersOnEnt and TensorCore and PerpCore) then\n    return\nend\n\n-- Returns the tether-45 source entity for a given entity id, or nil.\nlocal function tetherSource(entId)\n    local tethers = Argus.getTethersOnEnt(entId)\n    if not tethers then\n        return nil\n    end\n    for i = 1, #tethers do\n        local t = tethers[i]\n        if tonumber(t.type) == TETHER_ID and t.partnerid then\n            local src = TensorCore.mGetEntity(t.partnerid)\n            if src and src.pos then\n                return src\n            end\n        end\n    end\n    return nil\nend\n\nlocal function posKey(p)\n    return string.format(\"%.1f_%.1f_%.1f\", p.x or 0, p.y or 0, p.z or 0)\nend\n\nlocal me = PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nif not me or not me.id then\n    return\nend\n\n-- Our own tether source.\nlocal mySrc = tetherSource(me.id)\nif not mySrc then\n    return\nend\nlocal myKey = posKey(mySrc.pos)\n\n-- Find a second, different source position among the party.\nlocal otherSrc\nfor _, member in ipairs(PerpCore.GetPartyEntities() or {}) do\n    if member and member.id and member.id ~= me.id then\n        local src = tetherSource(member.id)\n        if src and posKey(src.pos) ~= myKey then\n            otherSrc = src\n            break\n        end\n    end\nend\n\n-- Stay armed until we've found both unique source positions.\nif not otherSrc then\n    return\nend\n\n-- Higher source = yellow, lower source = purple.\nlocal myIsYellow = (mySrc.pos.y or 0) > (otherSrc.pos.y or 0)\n\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(myIsYellow and \"Yellow (Confused) -> Far\" or \"Purple (Sleep) -> Close\", false, 5, false, 100)\nend\n\nself.used = true\n",
							conditions = 
							{
								
								{
									"4b83c226-1c0f-2587-bf2b-36cc3be5d325",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "e3f6a475-54b0-82d2-9189-da25d1850584",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Event",
							comparator = 3,
							eventArgType = 5,
							eventIntValue = 45,
							name = "Is Graven Tether",
							uuid = "4b83c226-1c0f-2587-bf2b-36cc3be5d325",
							version = 3,
						},
					},
				},
				eventType = 15,
				mechanicTime = 163.327,
				name = "Graven 3 Tethers",
				randomOffset = 5,
				timeRange = true,
				timelineIndex = 34,
				timerEndOffset = 5,
				uuid = "40ca225e-32b1-0b72-9df7-655a051bf257",
				version = 2,
			},
		},
	},
	[35] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				execute = "-- Confetti Reminder\n-- OnUpdate\n-- When a player's Confetti (5078) has <= 5s left, draw a purple circle on them. If it's us, also\n-- shotcall \"Knockback Party\". Resolve (self.used) once we've drawn.\n\nlocal CONFETTI      = 5078\nlocal CIRCLE_RADIUS = 6\n\nlocal party = PerpCore.GetPartyEntities() or {}\nlocal me = PerpCore.GetPlayer(data.perspective)\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal drawer = TensorCore.getStaticDrawer(purple, 2)\n\nlocal drewAny = false\nlocal iHaveIt = false\n\nfor _, ent in ipairs(party) do\n    if ent and ent.id and ent.buffs then\n        local duration\n        for _, b in pairs(ent.buffs) do\n            if b and tonumber(b.id) == CONFETTI then\n                duration = tonumber(b.duration) or 0\n                break\n            end\n        end\n        if duration and duration <= 5 then\n            drawer:addTimedCircleOnEnt(duration * 1000, ent.id, CIRCLE_RADIUS)\n            drewAny = true\n            if me and ent.id == me.id then\n                iHaveIt = true\n            end\n        end\n    end\nend\n\n-- Nothing in the reminder window yet, keep waiting.\nif not drewAny then\n    return\nend\n\nif iHaveIt and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(\"Knockback Party\", false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 167.546,
				name = "Confetti Reminder",
				timeRange = true,
				timelineIndex = 35,
				timerStartOffset = -10,
				uuid = "3e672bbf-1bff-cae4-ac2b-032eb4884b87",
				version = 2,
			},
		},
	},
	[37] = 
	{
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 4,
				execute = "-- [MM3] Callout Safespot\n-- OnEntityMarkerAdd\n-- Collect markers (min 4), resolve stack/spread + inside/outside cleave (thunder variant) and\n-- shotcall (once). Then highlight the thunder AOEs via PerpCore.DrawAOESafespots (no rotation):\n--   real thunder (47775)  -> two danger zones drawn red.\n--   fake thunder (47776)  -> two safe zones drawn green, plus two danger zones (47777) drawn red.\n\nlocal SPREAD_MARKER  = 127\nlocal STACK_MARKER   = 128 -- not strictly needed: anything that isn't spread is stack\nlocal FIRE_TRUE      = 674\nlocal FIRE_FALSE     = 673\nlocal THUNDER_TRUE   = 678\nlocal THUNDER_FALSE  = 677\n\nlocal REAL_THUNDER   = 47775 -- real thunder danger zones -> red\nlocal FAKE_THUNDER   = 47776 -- fake thunder safe zones -> green\nlocal THUNDER_DANGER = 47777 -- spawns alongside fake thunder -> red\n\ndata.mm3Markers = data.mm3Markers or {}\ntable.insert(data.mm3Markers, eventArgs.markerID)\n\n-- Wait until at least 4 markers have arrived\nif #data.mm3Markers < 4 then\n    return\nend\n\n-- Scan collected markers\nlocal hasSpread, fire, thunder = false, nil, nil\nfor _, id in ipairs(data.mm3Markers) do\n    if id == SPREAD_MARKER then hasSpread = true end\n    if id == FIRE_TRUE     then fire = true end\n    if id == FIRE_FALSE    then fire = false end\n    if id == THUNDER_TRUE  then thunder = true end\n    if id == THUNDER_FALSE then thunder = false end\nend\n\n-- Need both fire and thunder resolved before we can call\nif fire == nil or thunder == nil then\n    return\nend\n\n-- Callout once. Markers resolve independently of (and usually before) the AOEs spawning, so we\n-- fire the shotcall immediately and gate only the drawing on the AOEs below.\nif not data.mm3CalledOut then\n    local mechanic = hasSpread and \"Spread\" or \"Stack\"\n    -- Fire false inverts the mechanic\n    if not fire then\n        mechanic = (mechanic == \"Spread\") and \"Stack\" or \"Spread\"\n    end\n    -- Thunder true = outside cleave, thunder false = inside cleave\n    local cleave = thunder and \"outside\" or \"inside\"\n    local shotcall = mechanic .. \" \" .. cleave .. \" cleave\"\n    if AnyoneCore and AnyoneCore.Shotcall then\n        AnyoneCore.Shotcall(shotcall, false, 5, false, 100)\n    end\n    data.mm3CalledOut = true\nend\n\n-- Draw the thunder AOEs in place (no rotation), recoloured.\nif not (PerpCore and PerpCore.DrawAOESafespots and GUI) then\n    return\nend\nlocal red   = GUI:ColorConvertFloat4ToU32(1, 0, 0, 1)\nlocal green = GUI:ColorConvertFloat4ToU32(0, 1, 0, 1)\n\nif thunder then\n    -- Real thunder: two 47775 danger zones drawn red. Stay armed until both have spawned.\n    if #PerpCore.GetActiveAOEsById(REAL_THUNDER) < 2 then\n        return\n    end\n    PerpCore.DrawAOESafespots({ aoeId = REAL_THUNDER, color = red })\nelse\n    -- Fake thunder: two 47776 safe zones (green) + two 47777 danger zones (red).\n    if #PerpCore.GetActiveAOEsById(FAKE_THUNDER) < 2 or #PerpCore.GetActiveAOEsById(THUNDER_DANGER) < 2 then\n        return\n    end\n    PerpCore.DrawAOESafespots({ aoeId = FAKE_THUNDER, color = green })\n    PerpCore.DrawAOESafespots({ aoeId = THUNDER_DANGER, color = red })\nend\n\ndata.mm3Markers   = {}\ndata.mm3CalledOut = nil\nself.used = true\n",
				executeType = 2,
				mechanicTime = 185.952,
				name = "[MM3] Callout Safespot",
				timeRange = true,
				timelineIndex = 37,
				timerStartOffset = -10,
				uuid = "55200e52-ca1d-f763-b0a3-0d597580f834",
				version = 2,
			},
		},
		
		{
			data = 
			{
				actions = 
				{
				},
				conditions = 
				{
				},
				eventType = 19,
				execute = "-- Gaze Callout\n-- OnEventObjectScript\n-- Identify the gaze by the source content id and call out how to face.\n-- Real gaze (2015166) -> look away from statue. Fake gaze (2015167) -> look towards statue.\n\nlocal REAL_CID = 2015166\nlocal FAKE_CID = 2015167\n\nlocal entId = eventArgs and (eventArgs.entityID or eventArgs.entityId)\nlocal ent   = entId and TensorCore.mGetEntity(entId)\nlocal cid   = ent and tonumber(ent.contentid)\n\nlocal shotcall\nif cid == REAL_CID then\n    shotcall = \"Real Gaze -> Look away from statue\"\nelseif cid == FAKE_CID then\n    shotcall = \"Fake Gaze -> Look towards statue\"\nend\n\n-- Stay armed until the gaze object (one of the two content ids) shows up.\nif not shotcall then\n    return\nend\n\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(shotcall, false, 15, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 185.952,
				name = "Gaze Callout",
				timeRange = true,
				timelineIndex = 37,
				timerEndOffset = 10,
				timerStartOffset = -10,
				uuid = "f0b77d6c-a799-cb5f-878f-390ab9e9fde7",
				version = 2,
			},
		},
	},
	inheritedProfiles = 
	{
	},
	timelineName = "dmu",
	version = "1.5.0",
}



return tbl