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
				execute = "-- [Debug] OnAOECreate\n-- Verbose logging of every AOE created, a world-text label over it (name, ID, castType,\n-- size, duration, heading), and a drawn shape matching aoeCastType. Loops (self.used each fire).\n\nlocal aoeId    = eventArgs.aoeID\nlocal castType = tonumber(eventArgs.aoeCastType) or 0\nlocal len      = tonumber(eventArgs.aoeLength) or 0\nlocal wid      = tonumber(eventArgs.aoeWidth) or 0\nlocal heading  = tonumber(eventArgs.heading) or 0\nlocal x, y, z  = eventArgs.x, eventArgs.y, eventArgs.z\nlocal durationMs = (tonumber(eventArgs.duration) or 5) * 1000\n\nd(\"[Debug AOE] name=\" .. tostring(eventArgs.aoeName) ..\n    \" id=\" .. tostring(aoeId) ..\n    \" castType=\" .. tostring(castType) ..\n    \" aoeType=\" .. tostring(eventArgs.aoeType) ..\n    \" length=\" .. tostring(len) ..\n    \" width=\" .. tostring(wid) ..\n    \" heading=\" .. string.format(\"%.3f\", heading) ..\n    \" duration=\" .. tostring(eventArgs.duration) ..\n    \" targetAttach=\" .. tostring(eventArgs.targetAttach) ..\n    \" pos=\" .. string.format(\"%.1f, %.1f, %.1f\", x or 0, y or 0, z or 0))\n\n-- World-text label centered inside the AOE. Directional shapes (cones/lines) originate at the\n-- event position, so their visual center is half the length along the heading -- offset the\n-- label there so AOEs sharing an origin but pointing different ways don't overlap.\nif AnyoneCore and AnyoneCore.addTimedWorldText then\n    local label = string.format(\n        \"%s\\nID: %s  CT: %s  Type: %s\\nL: %s  W: %s  Hd: %.2f\\nDur: %ss\",\n        tostring(eventArgs.aoeName), tostring(aoeId), tostring(castType), tostring(eventArgs.aoeType),\n        tostring(len), tostring(wid), heading, tostring(eventArgs.duration)\n    )\n    local cx, cz = x, z\n    local isDirectional = (castType == 3 or castType == 13 or castType == 4 or castType == 12 or castType == 8)\n    if isDirectional and TensorCore and TensorCore.getPosInDirection then\n        local mid = TensorCore.getPosInDirection({ x = x, y = y, z = z }, heading, len * 0.5)\n        if mid then\n            cx, cz = mid.x, mid.z\n        end\n    end\n    local textPos = { x = cx, y = y, z = cz }\n    AnyoneCore.addTimedWorldText(durationMs, label, textPos, 0xFFFFFFFF, true, 0.8)\nend\n\nself.used = true\n",
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
				execute = "-- Disable the in-game omen VFX for every ice/thunder AOE we know of (setting both type indices\n-- to 0 hides the native omen). We draw our own callouts/safespots, so the native telegraphs --\n-- especially the misleading \"fake\" ones -- only add noise.\n\n-- Ice\nArgus.setActionAOEType(47768, 0, 0) -- real ice\nArgus.setActionAOEType(47768, 1, 0)\nArgus.setActionAOEType(47771, 0, 0) -- fake ice\nArgus.setActionAOEType(47771, 1, 0)\nArgus.setActionAOEType(47774, 0, 0) -- ice danger (spawns with fake ice)\nArgus.setActionAOEType(47774, 1, 0)\n\n-- Thunder\nArgus.setActionAOEType(47775, 0, 0) -- real thunder\nArgus.setActionAOEType(47775, 1, 0)\nArgus.setActionAOEType(47776, 0, 0) -- fake thunder\nArgus.setActionAOEType(47776, 1, 0)\nArgus.setActionAOEType(47777, 0, 0) -- thunder danger (spawns with fake thunder)\nArgus.setActionAOEType(47777, 1, 0)\n\n-- Shared arena geometry (used by multiple reactions for full-arena draws, distance checks, etc.)\ndata.arenaCenter = { x = 100, y = 0, z = 100 }\ndata.arenaRadius = 20\n\nself.used = true\n",
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
	[5] = 
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
							actionLua = "data.kefkaMarkers = data.kefkaMarkers or {}\ntable.insert(data.kefkaMarkers, eventArgs.markerID)\nself.used = true\n",
							conditions = 
							{
								
								{
									"b25bc53a-1a0e-571c-b497-99dc27eb57be",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "f2897081-a616-76a1-93c4-0550eaf77528",
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
							eventArgType = 3,
							markerIDList = 
							{
								673,
								674,
								675,
								676,
							},
							name = "Is Kefka Marker",
							uuid = "b25bc53a-1a0e-571c-b497-99dc27eb57be",
							version = 3,
						},
					},
				},
				eventType = 4,
				loop = true,
				mechanicTime = 37.11,
				name = "[MM1] Record Kefka Markers",
				timeRange = true,
				timelineIndex = 5,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "5dc7c86a-c93f-7272-9bbf-dd34a95e51f3",
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
							actionLua = "data.partyMarkers = data.partyMarkers or {}\ntable.insert(data.partyMarkers, eventArgs.markerID)\nself.used = true\n",
							conditions = 
							{
								
								{
									"2fc1ee6c-f0c4-ccb2-91c1-14b4bd600426",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "6c4dc328-d4d0-d4a1-b755-715a5d6952d9",
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
							eventArgType = 3,
							markerIDList = 
							{
								128,
								127,
							},
							name = "Is Party Marker",
							uuid = "2fc1ee6c-f0c4-ccb2-91c1-14b4bd600426",
							version = 3,
						},
					},
				},
				eventType = 4,
				loop = true,
				mechanicTime = 37.11,
				name = "[MM1] Record Party Markers",
				timeRange = true,
				timelineIndex = 5,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "dc32ef1f-9956-3a82-8e18-7eac01ae7a1f",
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
							actionLua = "-- Record the full AOE data (not just the id) so Draw Safespot can re-draw / subtract the shapes.\ndata.mm1AOEs = data.mm1AOEs or {}\ntable.insert(data.mm1AOEs, {\n    aoeID       = eventArgs.aoeID,\n    x           = eventArgs.x,\n    y           = eventArgs.y,\n    z           = eventArgs.z,\n    aoeCastType = eventArgs.aoeCastType,\n    aoeLength   = eventArgs.aoeLength,\n    aoeWidth    = eventArgs.aoeWidth,\n    heading     = eventArgs.heading,\n    duration    = eventArgs.duration,\n})\nself.used = true\n",
							conditions = 
							{
								
								{
									"c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "068dbd1e-2b92-03b7-b8c7-b79f959f3299",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Lua",
							conditionLua = "return eventArgs.aoeID == 47771 or eventArgs.aoeID == 47768 or eventArgs.aoeID == 47774",
							name = "Is Ice AOE",
							uuid = "c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
							version = 3,
						},
					},
				},
				eventType = 18,
				loop = true,
				mechanicTime = 37.11,
				name = "[MM1] Record AOEs",
				timeRange = true,
				timelineIndex = 5,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "b2999308-767a-8110-a3fb-01bc97c75b2a",
				version = 2,
			},
			inheritedIndex = 2,
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
				execute = "-- [MM1] Callout Safespot\n-- Resolves stack/spread + inside/outside cleave from the recorded markers and shotcalls once.\n-- Stays armed until every recording condition is met: 2 or 4 AOEs, exactly 2 kefka markers,\n-- and at least 1 party marker.\n--   Kefka markers carry one fire (674 true / 673 false) and one ice (676 true / 675 false).\n--   A party spread marker (127) = spread, stack marker (128) = stack -- but fire false flips it.\n--   Ice true = outside cleave, ice false = inside cleave.\n\nlocal FIRE_TRUE     = 674\nlocal FIRE_FALSE    = 673\nlocal ICE_TRUE      = 676\nlocal ICE_FALSE     = 675\nlocal SPREAD_MARKER = 127\n\n-- Read-only: bail until the recorder reactions have created all three tables. Do NOT initialise\n-- them here -- this runs on OnUpdate and must never race/clobber the data the recorders own.\nif not (data.mm1AOEs and data.kefkaMarkers and data.partyMarkers) then\n    return\nend\n\nlocal aoes  = data.mm1AOEs\nlocal kefka = data.kefkaMarkers\nlocal party = data.partyMarkers\n\n-- All recording conditions must be satisfied first.\nif not ((#aoes == 2 or #aoes == 4) and #kefka == 2 and #party >= 1) then\n    return\nend\n\n-- Resolve fire + ice from the kefka markers.\nlocal fire, ice = nil, nil\nfor _, id in ipairs(kefka) do\n    if id == FIRE_TRUE then fire = true\n    elseif id == FIRE_FALSE then fire = false\n    elseif id == ICE_TRUE then ice = true\n    elseif id == ICE_FALSE then ice = false end\nend\nif fire == nil or ice == nil then\n    return\nend\n\n-- Spread vs stack from the party markers (anything that isn't spread is treated as stack).\nlocal hasSpread = false\nfor _, id in ipairs(party) do\n    if id == SPREAD_MARKER then hasSpread = true end\nend\n\nlocal mechanic = hasSpread and \"Spread\" or \"Stack\"\n-- Fire false inverts the mechanic.\nif not fire then\n    mechanic = (mechanic == \"Spread\") and \"Stack\" or \"Spread\"\nend\n\nlocal cleave = ice and \"outside\" or \"inside\"\nlocal shotcall = mechanic .. \" \" .. cleave .. \" cleave\"\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(shotcall, false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 37.11,
				name = "[MM1] Callout Safespot",
				timeRange = true,
				timelineIndex = 5,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "b5908426-a665-6891-93c2-bcdca9403e83",
				version = 2,
			},
			inheritedIndex = 3,
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
				execute = "-- [MM1] Draw Safespot\n-- Highlights the ice safe zone using subtractive (occlusion) drawing: a full-arena green circle\n-- with the danger ice AOEs carved out of it via FLAG_OCCLUDE -- so only the safe ground stays green.\n-- Stays armed until every recording condition is met: 2 or 4 AOEs, exactly 2 kefka markers,\n-- and at least 1 party marker.\n--   Ice true  -> subtract real ice  (47768, the danger zones).\n--   Ice false -> subtract ice danger (47774).\n\nlocal CENTER       = data.arenaCenter or { x = 100, y = 0, z = 100 }\nlocal ARENA_RADIUS = data.arenaRadius or 20\nlocal SEG          = 50\n\nlocal ICE_TRUE     = 676\nlocal ICE_FALSE    = 675\nlocal REAL_ICE     = 47768 -- danger when ice is true\nlocal ICE_DANGER   = 47774 -- danger when ice is false\n\n-- Read-only: bail until the recorder reactions have created all three tables. Do NOT initialise\n-- them here -- this runs on OnUpdate and must never race/clobber the data the recorders own.\nif not (data.mm1AOEs and data.kefkaMarkers and data.partyMarkers) then\n    return\nend\n\nlocal aoes  = data.mm1AOEs\nlocal kefka = data.kefkaMarkers\nlocal party = data.partyMarkers\n\n-- All recording conditions must be satisfied first.\nif not ((#aoes == 2 or #aoes == 4) and #kefka == 2 and #party >= 1) then\n    return\nend\n\nif not (Argus2 and GUI and PerpCore and PerpCore.DrawAOEShape) then\n    return\nend\n\n-- Resolve ice from the kefka markers.\nlocal ice = nil\nfor _, id in ipairs(kefka) do\n    if id == ICE_TRUE then ice = true\n    elseif id == ICE_FALSE then ice = false end\nend\nif ice == nil then\n    return\nend\n\nlocal dangerId = ice and REAL_ICE or ICE_DANGER\n\n-- Match the draw lifetime to the danger AOEs (fallback 8s).\nlocal ms = 0\nfor _, a in ipairs(aoes) do\n    if tonumber(a.aoeID) == dangerId then\n        ms = math.max(ms, (tonumber(a.duration) or 6) * 1000)\n    end\nend\nif ms <= 0 then ms = 8000 end\n\n-- FLAG_OCCLUDE carves the draw out as negative space; FLAG_WARP_TERRAIN makes it follow the ground.\nlocal occlude = Argus2.RenderFlags.FLAG_OCCLUDE | Argus2.RenderFlags.FLAG_WARP_TERRAIN\nlocal green   = GUI:ColorConvertFloat4ToU32(0, 1, 0, 0.4)\n\n-- Full-arena green circle (solid fill, gradientIntensity 0), then subtract each danger AOE.\nArgus2.addTimedCircleFilled(ms, CENTER.x, CENTER.y, CENTER.z, ARENA_RADIUS, SEG, green, green, nil, 0, nil, nil, nil, 0)\n\nfor _, a in ipairs(aoes) do\n    if tonumber(a.aoeID) == dangerId then\n        PerpCore.DrawAOEShape(green, a.x, a.y, a.z, a.aoeCastType, a.aoeLength, a.aoeWidth, a.heading, ms, occlude)\n    end\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 37.11,
				name = "[MM1] Draw Safespot",
				timeRange = true,
				timelineIndex = 5,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "de68e665-d367-cbc7-964d-3b5e898f5641",
				version = 2,
			},
			inheritedIndex = 3,
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
				mechanicTime = 37.11,
				name = "Conga Reminder",
				timeRange = true,
				timelineIndex = 5,
				timerEndOffset = 3,
				timerStartOffset = -1,
				uuid = "9a3ac167-b0df-5975-8e3b-419d10002544",
				version = 2,
			},
			inheritedIndex = 6,
		},
	},
	[7] = 
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
				execute = "-- [MM1] Cleanup\n-- Clear everything Mystery Magic 1 recorded/used so a later MM1 (or a fresh pull) starts clean.\n-- Setting to nil (not {}) lets the recorder reactions re-create the tables on their next event,\n-- and keeps the read-only Callout/Draw reactions bailing until data exists again.\ndata.mm1AOEs      = nil\ndata.kefkaMarkers = nil\ndata.partyMarkers = nil\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 42.188,
				name = "[MM1] Cleanup",
				timelineIndex = 7,
				uuid = "eda41e18-58fa-9168-a6dd-1fe1c041dae1",
				version = 2,
			},
			inheritedIndex = 1,
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
				eventType = 18,
				execute = "-- Callout Tower\n-- OnAOECreate\n\nlocal TOWER_AOE  = 47786\nlocal MAGIC_VULN = 2941\n\nif eventArgs.aoeID ~= TOWER_AOE then\n    return\nend\n\nlocal hasBuff = TensorCore and TensorCore.hasBuff and\n    TensorCore.hasBuff(PerpCore.GetPlayer(data.perspective), MAGIC_VULN)\n\nAnyoneCore.Shotcall(hasBuff and \"Avoid Tower\" or \"Soak Tower\", false, 5, false, 100)\nself.used = true\n",
				executeType = 2,
				mechanicTime = 42.188,
				name = "Callout Tower",
				timeRange = true,
				timelineIndex = 7,
				timerEndOffset = 10,
				uuid = "2024bf3d-63c6-b4f3-846d-ae5b017577da",
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
							actionLua = "-- Callout Confetti\n-- OnEntityCast (spellID checked by reaction condition)\n-- Iterate the party, find everyone with Confetti (5078), draw a purple circle that follows\n-- them for the buff's duration, and shotcall \"Knockback Party\" if one of them is me.\n\nlocal CONFETTI      = 5078\nlocal CIRCLE_RADIUS = 6\n\nlocal party = PerpCore.GetPartyEntities() or {}\nlocal me = PerpCore.GetPlayer(data.perspective)\n\n-- Entity-attached draw so the circle tracks the player's live position\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal white  = GUI:ColorConvertFloat4ToU32(1, 1, 1, 1)\nlocal drawer = TensorCore.getStaticDrawer(purple, 2)\n\nlocal iHaveIt = false\nfor _, ent in ipairs(party) do\n    if ent and ent.id and ent.buffs then\n        local duration\n        for _, b in pairs(ent.buffs) do\n            if b and tonumber(b.id) == CONFETTI then\n                duration = tonumber(b.duration) or 5\n                break\n            end\n        end\n        if duration then\n            local ms = duration * 1000\n            drawer:addTimedCircleOnEnt(ms, ent.id, CIRCLE_RADIUS)\n            -- Countdown in the middle of the circle showing how long it lasts (white text, with background).\n            if AnyoneCore and AnyoneCore.addWorldTextCountdownOnEnt then\n                AnyoneCore.addWorldTextCountdownOnEnt(ms, ent.id, white, true)\n            end\n            if me and ent.id == me.id then\n                iHaveIt = true\n            end\n        end\n    end\nend\n\nif iHaveIt and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(\"Knockback Party\", false, 5, false, 100)\nend\n\nself.used = true\n",
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
							eventSpellID = 47782,
							name = "Is Confetti",
							uuid = "d24aa2a2-bcc6-dbad-aedf-5dab2103ed3a",
							version = 3,
						},
					},
				},
				eventType = 2,
				mechanicTime = 42.188,
				name = "Callout Confetti",
				timeRange = true,
				timelineIndex = 7,
				timerEndOffset = 10,
				uuid = "81ee8dc6-d561-3c25-8ed3-d7edd8b1fa84",
				version = 2,
			},
		},
	},
	[11] = 
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
							actionLua = "data.kefkaMarkers = data.kefkaMarkers or {}\ntable.insert(data.kefkaMarkers, eventArgs.markerID)\nself.used = true\n",
							conditions = 
							{
								
								{
									"b25bc53a-1a0e-571c-b497-99dc27eb57be",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "f2897081-a616-76a1-93c4-0550eaf77528",
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
							eventArgType = 3,
							markerIDList = 
							{
								675,
								676,
								677,
								678,
							},
							name = "Is Kefka Marker",
							uuid = "b25bc53a-1a0e-571c-b497-99dc27eb57be",
							version = 3,
						},
					},
				},
				eventType = 4,
				loop = true,
				mechanicTime = 53.407,
				name = "[MM2] Record Kefka Markers",
				timeRange = true,
				timelineIndex = 11,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "bc5992ac-33a5-76aa-8456-1910a5818da0",
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
							actionLua = "-- Record the full AOE data (not just the id) so Draw Safespot can re-draw / subtract the shapes.\ndata.mm2AOEs = data.mm2AOEs or {}\ntable.insert(data.mm2AOEs, {\n    aoeID       = eventArgs.aoeID,\n    x           = eventArgs.x,\n    y           = eventArgs.y,\n    z           = eventArgs.z,\n    aoeCastType = eventArgs.aoeCastType,\n    aoeLength   = eventArgs.aoeLength,\n    aoeWidth    = eventArgs.aoeWidth,\n    heading     = eventArgs.heading,\n    duration    = eventArgs.duration,\n})\nself.used = true\n",
							conditions = 
							{
								
								{
									"c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "068dbd1e-2b92-03b7-b8c7-b79f959f3299",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Lua",
							conditionLua = "return eventArgs.aoeID == 47771 or eventArgs.aoeID == 47768 or eventArgs.aoeID == 47774 or eventArgs.aoeID == 47775 or eventArgs.aoeID == 47776 or eventArgs.aoeID == 47777",
							name = "Is Ice or Thunder AOE",
							uuid = "c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
							version = 3,
						},
					},
				},
				eventType = 18,
				loop = true,
				mechanicTime = 53.407,
				name = "[MM2] Record AOEs",
				timeRange = true,
				timelineIndex = 11,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "aa6f94c8-4342-4aa9-bada-872ebf650c4a",
				version = 2,
			},
			inheritedIndex = 3,
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
				execute = "-- [MM2] Callout Safespot\n-- Resolves whether ice and thunder are real or fake from the 2 kefka markers, then shotcalls once.\n-- Read-only on data; bails until both kefka markers AND every expected AOE are present.\n--   both real -> \"Both real\"; both fake -> \"Both fake\"; otherwise name the fake element.\n\nlocal ICE_TRUE       = 676 -- real ice\nlocal ICE_FALSE      = 675 -- fake ice\nlocal THUNDER_TRUE   = 678 -- real thunder\nlocal THUNDER_FALSE  = 677 -- fake thunder\n\nlocal REAL_ICE       = 47768\nlocal FAKE_ICE       = 47771\nlocal ICE_DANGER     = 47774\nlocal REAL_THUNDER   = 47775\nlocal FAKE_THUNDER   = 47776\nlocal THUNDER_DANGER = 47777\n\nif not (data.mm2AOEs and data.kefkaMarkers) then\n    return\nend\n\nlocal aoes  = data.mm2AOEs\nlocal kefka = data.kefkaMarkers\n\n-- Exactly the two kefka markers (one ice, one thunder).\nif #kefka ~= 2 then\n    return\nend\n\n-- Resolve ice/thunder: true = real, false = fake.\nlocal ice, thunder = nil, nil\nfor _, id in ipairs(kefka) do\n    if id == ICE_TRUE then ice = true\n    elseif id == ICE_FALSE then ice = false\n    elseif id == THUNDER_TRUE then thunder = true\n    elseif id == THUNDER_FALSE then thunder = false end\nend\nif ice == nil or thunder == nil then\n    return\nend\n\n-- Verify every AOE that should have spawned is present (real = 2 danger; fake = 2 safe + 2 danger).\nlocal function countById(id)\n    local n = 0\n    for _, a in ipairs(aoes) do\n        if tonumber(a.aoeID) == id then n = n + 1 end\n    end\n    return n\nend\n\nlocal iceOk\nif ice then\n    iceOk = countById(REAL_ICE) >= 2\nelse\n    iceOk = countById(FAKE_ICE) >= 2 and countById(ICE_DANGER) >= 2\nend\n\nlocal thunderOk\nif thunder then\n    thunderOk = countById(REAL_THUNDER) >= 2\nelse\n    thunderOk = countById(FAKE_THUNDER) >= 2 and countById(THUNDER_DANGER) >= 2\nend\n\nif not (iceOk and thunderOk) then\n    return\nend\n\n-- Build the callout.\nlocal call\nif ice and thunder then\n    call = \"Both real\"\nelseif not ice and not thunder then\n    call = \"Both fake\"\nelseif not ice then\n    call = \"Ice fake\"\nelse\n    call = \"Thunder fake\"\nend\n\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(call, false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 53.407,
				name = "[MM2] Callout Safespot",
				timeRange = true,
				timelineIndex = 11,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "64fc4766-e3b6-9c50-94db-38a0da5095c9",
				version = 2,
			},
			inheritedIndex = 3,
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
				execute = "-- [MM2] Draw Safespot\n-- Full-arena green circle with the danger zones carved out via FLAG_OCCLUDE, so only safe ground\n-- stays green. Read-only on data; bails until both kefka markers AND every expected AOE are present.\n--   ice real  -> subtract real ice  (47768); ice fake  -> subtract ice danger  (47774).\n--   thunder real -> subtract real thunder (47775); thunder fake -> subtract thunder danger (47777).\n\nlocal CENTER         = data.arenaCenter or { x = 100, y = 0, z = 100 }\nlocal ARENA_RADIUS   = data.arenaRadius or 20\nlocal SEG            = 50\n\nlocal ICE_TRUE       = 676 -- real ice\nlocal ICE_FALSE      = 675 -- fake ice\nlocal THUNDER_TRUE   = 678 -- real thunder\nlocal THUNDER_FALSE  = 677 -- fake thunder\n\nlocal REAL_ICE       = 47768\nlocal FAKE_ICE       = 47771\nlocal ICE_DANGER     = 47774\nlocal REAL_THUNDER   = 47775\nlocal FAKE_THUNDER   = 47776\nlocal THUNDER_DANGER = 47777\n\nif not (data.mm2AOEs and data.kefkaMarkers) then\n    return\nend\n\nlocal aoes  = data.mm2AOEs\nlocal kefka = data.kefkaMarkers\n\n-- Exactly the two kefka markers (one ice, one thunder).\nif #kefka ~= 2 then\n    return\nend\n\n-- Resolve ice/thunder: true = real, false = fake.\nlocal ice, thunder = nil, nil\nfor _, id in ipairs(kefka) do\n    if id == ICE_TRUE then\n        ice = true\n    elseif id == ICE_FALSE then\n        ice = false\n    elseif id == THUNDER_TRUE then\n        thunder = true\n    elseif id == THUNDER_FALSE then\n        thunder = false\n    end\nend\nif ice == nil or thunder == nil then\n    return\nend\n\n-- Verify every AOE that should have spawned is present (real = 2 danger; fake = 2 safe + 2 danger).\nlocal function countById(id)\n    local n = 0\n    for _, a in ipairs(aoes) do\n        if tonumber(a.aoeID) == id then n = n + 1 end\n    end\n    return n\nend\n\nlocal iceOk\nif ice then\n    iceOk = countById(REAL_ICE) >= 2\nelse\n    iceOk = countById(FAKE_ICE) >= 2 and countById(ICE_DANGER) >= 2\nend\n\nlocal thunderOk\nif thunder then\n    thunderOk = countById(REAL_THUNDER) >= 2\nelse\n    thunderOk = countById(FAKE_THUNDER) >= 2 and countById(THUNDER_DANGER) >= 2\nend\n\nif not (iceOk and thunderOk) then\n    return\nend\n\nif not (Argus2 and GUI and PerpCore and PerpCore.DrawAOEShape) then\n    return\nend\n\n-- Danger IDs to subtract from the green: real -> the real AOE, fake -> the danger AOE.\nlocal iceDanger     = ice and REAL_ICE or ICE_DANGER\nlocal thunderDanger = thunder and REAL_THUNDER or THUNDER_DANGER\n\n-- Match the draw lifetime to the danger AOEs (fallback 8s).\nlocal ms            = 0\nfor _, a in ipairs(aoes) do\n    local id = tonumber(a.aoeID)\n    if id == iceDanger or id == thunderDanger then\n        ms = math.max(ms, (tonumber(a.duration) or 6) * 1000)\n    end\nend\nif ms <= 0 then ms = 8000 end\n\n-- FLAG_OCCLUDE carves the draw out as negative space; FLAG_WARP_TERRAIN makes it follow the ground.\nlocal occlude = Argus2.RenderFlags.FLAG_OCCLUDE | Argus2.RenderFlags.FLAG_WARP_TERRAIN\nlocal green   = GUI:ColorConvertFloat4ToU32(0, 1, 0, 0.4)\n\n-- Full-arena green circle (solid fill), then subtract every danger AOE.\nArgus2.addTimedCircleFilled(ms, CENTER.x, CENTER.y, CENTER.z, ARENA_RADIUS, SEG, green, green, nil, 0, nil, nil, nil, 0)\n\nfor _, a in ipairs(aoes) do\n    local id = tonumber(a.aoeID)\n    if id == iceDanger or id == thunderDanger then\n        PerpCore.DrawAOEShape(green, a.x, a.y, a.z, a.aoeCastType, a.aoeLength, a.aoeWidth, a.heading, ms, occlude)\n    end\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 53.407,
				name = "[MM2] Draw Safespot",
				timeRange = true,
				timelineIndex = 11,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "802a9e54-7aa5-093e-a32e-cd22445efa45",
				version = 2,
			},
			inheritedIndex = 5,
		},
	},
	[12] = 
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
				execute = "-- [MM2] Cleanup\n-- Clear everything Mystery Magic 2 recorded/used so a later MM2 (or a fresh pull) starts clean.\n-- Setting to nil (not {}) lets the recorder reactions re-create the tables on their next event,\n-- and keeps the read-only Callout/Draw reactions bailing until data exists again.\ndata.mm2AOEs      = nil\ndata.kefkaMarkers = nil\n\nself.used         = true\n",
				executeType = 2,
				mechanicTime = 62.547,
				name = "[MM2] Cleanup",
				timelineIndex = 12,
				uuid = "34ab4643-17e5-9726-b5fc-32779f43d09a",
				version = 2,
			},
			inheritedIndex = 1,
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
							actionLua = "data.kefkaMarkers = data.kefkaMarkers or {}\ntable.insert(data.kefkaMarkers, eventArgs.markerID)\nself.used = true\n",
							conditions = 
							{
								
								{
									"b25bc53a-1a0e-571c-b497-99dc27eb57be",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "f2897081-a616-76a1-93c4-0550eaf77528",
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
							eventArgType = 3,
							markerIDList = 
							{
								675,
								676,
							},
							name = "Is Kefka Marker",
							uuid = "b25bc53a-1a0e-571c-b497-99dc27eb57be",
							version = 3,
						},
					},
				},
				eventType = 4,
				loop = true,
				mechanicTime = 80.063,
				name = "[Graven 2] Record Kefka Markers",
				timeRange = true,
				timelineIndex = 16,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "07dc0f4a-73b2-7119-9f66-f98795d25582",
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
							actionLua = "-- Record the full AOE data (not just the id) so Draw Safespot can re-draw / subtract the shapes.\ndata.graven2AOEs = data.graven2AOEs or {}\ntable.insert(data.graven2AOEs, {\n    aoeID       = eventArgs.aoeID,\n    x           = eventArgs.x,\n    y           = eventArgs.y,\n    z           = eventArgs.z,\n    aoeCastType = eventArgs.aoeCastType,\n    aoeLength   = eventArgs.aoeLength,\n    aoeWidth    = eventArgs.aoeWidth,\n    heading     = eventArgs.heading,\n    duration    = eventArgs.duration,\n})\nself.used = true\n",
							conditions = 
							{
								
								{
									"c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "068dbd1e-2b92-03b7-b8c7-b79f959f3299",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Lua",
							conditionLua = "return eventArgs.aoeID == 47771 or eventArgs.aoeID == 47768 or eventArgs.aoeID == 47774",
							name = "Is Ice AOE",
							uuid = "c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
							version = 3,
						},
					},
				},
				eventType = 18,
				loop = true,
				mechanicTime = 80.063,
				name = "[Graven 2] Record AOEs",
				timeRange = true,
				timelineIndex = 16,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "331fa248-7598-dad5-9639-11a721f12707",
				version = 2,
			},
			inheritedIndex = 2,
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
							actionLua = "-- Graven 2 Draw Tethers\n-- OnTetherChange (tether id 45 checked by the reaction condition)\n-- Handles both the first and second tether sets (identical logic). Every living player is tethered\n-- (tether id 45) to one of two orb NPCs. Only 2 unique source positions exist; the higher orb is\n-- purple, the lower orb is yellow. The event can fire before both tethers exist, so we stay armed\n-- until both source positions are present, then draw a purple/yellow circle on every player (with a\n-- countdown in the middle) and shotcall our own colour.\n\nlocal TETHER_ID     = 45\nlocal CIRCLE_RADIUS = 6\nlocal PURPLE_MS     = 6375\nlocal YELLOW_MS     = 10375\n\nif not (Argus and Argus.getTethersOnEnt and TensorCore and PerpCore) then\n    return\nend\n\nlocal party = PerpCore.GetPartyEntities() or {}\n\n-- Group players by their tether source position (4 share each of the 2 unique spots).\nlocal function posKey(p)\n    return string.format(\"%.1f_%.1f_%.1f\", p.x or 0, p.y or 0, p.z or 0)\nend\n\nlocal groups = {} -- key -> { y = sourceHeight, players = { ent, ... } }\nlocal order  = {} -- discovery order so we can iterate the groups\n\nfor _, member in ipairs(party) do\n    if member and member.id then\n        local tethers = Argus.getTethersOnEnt(member.id)\n        if tethers then\n            for i = 1, #tethers do\n                local t = tethers[i]\n                if tonumber(t.type) == TETHER_ID and t.partnerid then\n                    local src = TensorCore.mGetEntity(t.partnerid)\n                    if src and src.pos then\n                        local k = posKey(src.pos)\n                        local g = groups[k]\n                        if not g then\n                            g = { y = src.pos.y or 0, players = {} }\n                            groups[k] = g\n                            order[#order + 1] = g\n                        end\n                        g.players[#g.players + 1] = member\n                    end\n                    break\n                end\n            end\n        end\n    end\nend\n\n-- Stay armed until both unique source positions exist so we can tell purple (higher) from yellow (lower).\nif #order < 2 then\n    return\nend\n\n-- The source with the greatest height is the purple tether; everything else is yellow.\nlocal purpleGroup\nfor _, g in ipairs(order) do\n    if not purpleGroup or g.y > purpleGroup.y then\n        purpleGroup = g\n    end\nend\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal yellow = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\nlocal white  = GUI:ColorConvertFloat4ToU32(1, 1, 1, 1)\nlocal purpleDrawer = TensorCore.getStaticDrawer(purple, 2)\nlocal yellowDrawer = TensorCore.getStaticDrawer(yellow, 2)\n\nlocal me = PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nlocal myIsPurple\n\nfor _, g in ipairs(order) do\n    local isPurple = (g == purpleGroup)\n    local drawer = isPurple and purpleDrawer or yellowDrawer\n    local ms = isPurple and PURPLE_MS or YELLOW_MS\n    for _, member in ipairs(g.players) do\n        drawer:addTimedCircleOnEnt(ms, member.id, CIRCLE_RADIUS)\n        -- Countdown in the middle of the circle showing how long it lasts (white text, with background).\n        if AnyoneCore and AnyoneCore.addWorldTextCountdownOnEnt then\n            AnyoneCore.addWorldTextCountdownOnEnt(ms, member.id, white, true)\n        end\n        if me and member.id == me.id then\n            myIsPurple = isPurple\n        end\n    end\nend\n\n-- Shotcall our own tether colour.\nif myIsPurple ~= nil and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(myIsPurple and \"Purple Tether\" or \"Yellow Tether\", false, 5, false, 100)\nend\n\nself.used = true\n",
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
				name = "[Graven 2] Draw First Tethers",
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
				execute = "-- Graven 2 Callout Safespot\n-- Resolves real/fake ice from the single kefka marker, then shotcalls the cleave position once.\n-- Read-only on data; bails until the kefka marker is present.\n--   ice true (676) = outside cleave; ice false (675) = inside cleave.\n\nlocal ICE_TRUE  = 676 -- real ice\nlocal ICE_FALSE = 675 -- fake ice\n\nif not data.kefkaMarkers then\n    return\nend\n\nlocal kefka = data.kefkaMarkers\n\nif #kefka < 1 then\n    return\nend\n\n-- Resolve ice: true = real, false = fake.\nlocal ice\nfor _, id in ipairs(kefka) do\n    if id == ICE_TRUE then\n        ice = true\n    elseif id == ICE_FALSE then\n        ice = false\n    end\nend\nif ice == nil then\n    return\nend\n\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(ice and \"Outside Cleave\" or \"Inside Cleave\", false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 80.063,
				name = "[Graven 2] Callout Safespot",
				timeRange = true,
				timelineIndex = 16,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "c9d2fc4f-0f4f-fcbc-a904-cd8ad8d35252",
				version = 2,
			},
			inheritedIndex = 4,
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
				execute = "-- Graven 2 Draw Safespot\n-- Full-arena green circle with the danger zones carved out via FLAG_OCCLUDE, so only safe ground\n-- stays green. Read-only on data; bails until the kefka marker AND every expected AOE are present.\n--   ice real (676) -> subtract real ice    (47768), 2 AOEs.\n--   ice fake (675) -> subtract ice danger  (47774), 4 AOEs total.\n\nlocal CENTER       = data.arenaCenter or { x = 100, y = 0, z = 100 }\nlocal ARENA_RADIUS = data.arenaRadius or 20\nlocal SEG          = 50\n\nlocal ICE_TRUE     = 676  -- real ice\nlocal ICE_FALSE    = 675  -- fake ice\n\nlocal REAL_ICE     = 47768\nlocal ICE_DANGER   = 47774\n\nif not (data.graven2AOEs and data.kefkaMarkers) then\n    return\nend\n\nlocal aoes  = data.graven2AOEs\nlocal kefka = data.kefkaMarkers\n\n-- Need the single ice kefka marker.\nif #kefka < 1 then\n    return\nend\n\n-- Resolve ice: true = real, false = fake.\nlocal ice\nfor _, id in ipairs(kefka) do\n    if id == ICE_TRUE then\n        ice = true\n    elseif id == ICE_FALSE then\n        ice = false\n    end\nend\nif ice == nil then\n    return\nend\n\n-- Verify every expected AOE has spawned: real = 2, fake = 4.\nif ice then\n    if #aoes < 2 then return end\nelse\n    if #aoes < 4 then return end\nend\n\nif not (Argus2 and GUI and PerpCore and PerpCore.DrawAOEShape) then\n    return\nend\n\n-- Danger ID to subtract from the green: real -> real ice, fake -> ice danger.\nlocal dangerId = ice and REAL_ICE or ICE_DANGER\n\n-- Match the draw lifetime to the danger AOEs (fallback 8s).\nlocal ms = 0\nfor _, a in ipairs(aoes) do\n    if tonumber(a.aoeID) == dangerId then\n        ms = math.max(ms, (tonumber(a.duration) or 6) * 1000)\n    end\nend\nif ms <= 0 then ms = 8000 end\n\n-- FLAG_OCCLUDE carves the draw out as negative space; FLAG_WARP_TERRAIN makes it follow the ground.\nlocal occlude = Argus2.RenderFlags.FLAG_OCCLUDE | Argus2.RenderFlags.FLAG_WARP_TERRAIN\nlocal green   = GUI:ColorConvertFloat4ToU32(0, 1, 0, 0.4)\n\n-- Full-arena green circle (solid fill), then subtract every danger AOE.\nArgus2.addTimedCircleFilled(ms, CENTER.x, CENTER.y, CENTER.z, ARENA_RADIUS, SEG, green, green, nil, 0, nil, nil, nil, 0)\n\nfor _, a in ipairs(aoes) do\n    if tonumber(a.aoeID) == dangerId then\n        PerpCore.DrawAOEShape(green, a.x, a.y, a.z, a.aoeCastType, a.aoeLength, a.aoeWidth, a.heading, ms, occlude)\n    end\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 80.063,
				name = "[Graven 2] Draw Safespot",
				timeRange = true,
				timelineIndex = 16,
				timerEndOffset = 10,
				uuid = "e5eb6d88-ed49-fd50-a594-cfee32a7d00f",
				version = 2,
			},
		},
	},
	[17] = 
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
				execute = "-- [Graven 2] Cleanup\n-- Clear everything Graven 2 recorded/used so a later Graven 2 (or a fresh pull) starts clean.\n-- Setting to nil (not {}) lets the recorder reactions re-create the tables on their next event,\n-- and keeps the read-only Callout/Draw reactions bailing until data exists again.\ndata.graven2AOEs = nil\ndata.kefkaMarkers = nil\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 87.219,
				name = "[Graven 2] Cleanup",
				timelineIndex = 17,
				uuid = "cccc1be5-7e6d-9700-a333-3470f51da58c",
				version = 2,
			},
			inheritedIndex = 1,
		},
	},
	[18] = 
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
							actionLua = "-- Graven 2 Second Tethers\n-- OnTetherChange (tether id 45 checked by the reaction condition)\n-- Same as Graven 2 First Tethers but with the second set's timers. Every living player is tethered\n-- (tether id 45) to one of two orb NPCs. Only 2 unique source positions exist; the higher orb is\n-- purple, the lower orb is yellow. The event can fire before both tethers exist, so we stay armed\n-- until both source positions are present, then draw a purple/yellow circle on every player (with a\n-- countdown in the middle) and shotcall our own colour.\n\nlocal TETHER_ID     = 45\nlocal CIRCLE_RADIUS = 6\nlocal PURPLE_MS     = 8370\nlocal YELLOW_MS     = 12385\n\nif not (Argus and Argus.getTethersOnEnt and TensorCore and PerpCore) then\n    return\nend\n\nlocal party = PerpCore.GetPartyEntities() or {}\n\n-- Group players by their tether source position (4 share each of the 2 unique spots).\nlocal function posKey(p)\n    return string.format(\"%.1f_%.1f_%.1f\", p.x or 0, p.y or 0, p.z or 0)\nend\n\nlocal groups = {} -- key -> { y = sourceHeight, players = { ent, ... } }\nlocal order  = {} -- discovery order so we can iterate the groups\n\nfor _, member in ipairs(party) do\n    if member and member.id then\n        local tethers = Argus.getTethersOnEnt(member.id)\n        if tethers then\n            for i = 1, #tethers do\n                local t = tethers[i]\n                if tonumber(t.type) == TETHER_ID and t.partnerid then\n                    local src = TensorCore.mGetEntity(t.partnerid)\n                    if src and src.pos then\n                        local k = posKey(src.pos)\n                        local g = groups[k]\n                        if not g then\n                            g = { y = src.pos.y or 0, players = {} }\n                            groups[k] = g\n                            order[#order + 1] = g\n                        end\n                        g.players[#g.players + 1] = member\n                    end\n                    break\n                end\n            end\n        end\n    end\nend\n\n-- Stay armed until both unique source positions exist so we can tell purple (higher) from yellow (lower).\nif #order < 2 then\n    return\nend\n\n-- The source with the greatest height is the purple tether; everything else is yellow.\nlocal purpleGroup\nfor _, g in ipairs(order) do\n    if not purpleGroup or g.y > purpleGroup.y then\n        purpleGroup = g\n    end\nend\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal yellow = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\nlocal white  = GUI:ColorConvertFloat4ToU32(1, 1, 1, 1)\nlocal purpleDrawer = TensorCore.getStaticDrawer(purple, 2)\nlocal yellowDrawer = TensorCore.getStaticDrawer(yellow, 2)\n\nlocal me = PerpCore.GetPlayer and PerpCore.GetPlayer(data.perspective)\nlocal myIsPurple\n\nfor _, g in ipairs(order) do\n    local isPurple = (g == purpleGroup)\n    local drawer = isPurple and purpleDrawer or yellowDrawer\n    local ms = isPurple and PURPLE_MS or YELLOW_MS\n    for _, member in ipairs(g.players) do\n        drawer:addTimedCircleOnEnt(ms, member.id, CIRCLE_RADIUS)\n        -- Countdown in the middle of the circle showing how long it lasts (white text, with background).\n        if AnyoneCore and AnyoneCore.addWorldTextCountdownOnEnt then\n            AnyoneCore.addWorldTextCountdownOnEnt(ms, member.id, white, true)\n        end\n        if me and member.id == me.id then\n            myIsPurple = isPurple\n        end\n    end\nend\n\n-- Shotcall our own tether colour.\nif myIsPurple ~= nil and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(myIsPurple and \"Purple Tether\" or \"Yellow Tether\", false, 5, false, 100)\nend\n\nself.used = true\n",
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
				name = "[Graven 2] Draw Second Tethers",
				timeRange = true,
				timelineIndex = 18,
				timerEndOffset = 15,
				timerStartOffset = 5,
				uuid = "774391ee-eee0-7ed3-a83a-dbb5be71fdb3",
				version = 2,
			},
		},
	},
	[21] = 
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
				execute = "-- Graven 2 Room Cleave\n-- OnEventObjectScript\n-- The cleaving orb is identified by its content id: yellow (2015165) cleaves the EAST half,\n-- purple (2015164) cleaves the WEST half. Draw a 180-degree cone from arena center that way.\n\nlocal YELLOW_CID = 2015165\nlocal PURPLE_CID = 2015164\nlocal CENTER     = { x = 100, y = 0, z = 100 }\nlocal RADIUS     = 40\nlocal DRAW_MS    = 5135\nlocal CONE_ANGLE = math.rad(180)\nlocal SEG        = 64\n\nlocal entId = eventArgs and (eventArgs.entityID or eventArgs.entityId)\nlocal ent   = entId and TensorCore.mGetEntity(entId)\nlocal cid   = ent and tonumber(ent.contentid)\n\n-- Stay armed until the cleaving orb (one of the two content ids) shows up.\nif cid ~= YELLOW_CID and cid ~= PURPLE_CID then\n    return\nend\n\nif not (Argus2 and TensorCore and GUI) then\n    self.used = true\n    return\nend\n\nlocal isYellow = (cid == YELLOW_CID)\n\n-- East = +x, West = -x. Use getHeadingToTarget so the heading matches the cone draw convention.\nlocal dirPoint = {\n    x = CENTER.x + (isYellow and 10 or -10),\n    y = CENTER.y,\n    z = CENTER.z,\n}\nlocal heading = TensorCore.getHeadingToTarget(CENTER, dirPoint)\n\nlocal fill, outline\nif isYellow then\n    fill    = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 1)\nelse\n    fill    = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 1)\nend\n\nArgus2.addTimedConeFilled(DRAW_MS, CENTER.x, CENTER.y, CENTER.z, RADIUS, CONE_ANGLE, heading, SEG, fill, outline)\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 100.999,
				name = "[Graven 2] Draw Room Cleave",
				timeRange = true,
				timelineIndex = 21,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "2aea1ea3-0ada-c6ac-b05f-aaba445581fb",
				version = 2,
			},
			inheritedIndex = 1,
		},
	},
	[24] = 
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
				execute = "-- Graven 2 Room Cleave 2\n-- OnEventObjectScript\n-- The cleaving orb is identified by its content id: yellow (2015165) cleaves the EAST half,\n-- purple (2015164) cleaves the WEST half. Draw a 180-degree cone from arena center that way.\n\nlocal YELLOW_CID = 2015165\nlocal PURPLE_CID = 2015164\nlocal CENTER     = { x = 100, y = 0, z = 100 }\nlocal RADIUS     = 40\nlocal DRAW_MS    = 5135\nlocal CONE_ANGLE = math.rad(180)\nlocal SEG        = 64\n\nlocal entId = eventArgs and (eventArgs.entityID or eventArgs.entityId)\nlocal ent   = entId and TensorCore.mGetEntity(entId)\nlocal cid   = ent and tonumber(ent.contentid)\n\n-- Stay armed until the cleaving orb (one of the two content ids) shows up.\nif cid ~= YELLOW_CID and cid ~= PURPLE_CID then\n    return\nend\n\nif not (Argus2 and TensorCore and GUI) then\n    self.used = true\n    return\nend\n\nlocal isYellow = (cid == YELLOW_CID)\n\n-- East = +x, West = -x. Use getHeadingToTarget so the heading matches the cone draw convention.\nlocal dirPoint = {\n    x = CENTER.x + (isYellow and 10 or -10),\n    y = CENTER.y,\n    z = CENTER.z,\n}\nlocal heading = TensorCore.getHeadingToTarget(CENTER, dirPoint)\n\nlocal fill, outline\nif isYellow then\n    fill    = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(1, 0.85, 0.1, 1)\nelse\n    fill    = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\n    outline = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 1)\nend\n\nArgus2.addTimedConeFilled(DRAW_MS, CENTER.x, CENTER.y, CENTER.z, RADIUS, CONE_ANGLE, heading, SEG, fill, outline)\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 114.171,
				name = "[Graven 2] Draw Room Cleave 2",
				timeRange = true,
				timelineIndex = 24,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "9fbf26c3-6bbe-18b7-a37f-7cf5ed9933f3",
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
				execute = "-- Confetti Reminder\n-- OnUpdate\n-- Once ANY player's Confetti (5078) is down to <= 5s, draw a purple circle on EVERY player who has\n-- the debuff (not just the ones already at <= 5s) so a slight timer skew doesn't drop a circle.\n-- If we have it, also shotcall \"Knockback Party\". Resolve (self.used) once we've drawn.\n\nlocal CONFETTI      = 5078\nlocal CIRCLE_RADIUS = 6\n\nlocal party = PerpCore.GetPartyEntities() or {}\nlocal me = PerpCore.GetPlayer(data.perspective)\n\n-- Collect everyone who currently has Confetti and their remaining duration.\nlocal holders = {}\nlocal triggered = false\nfor _, ent in ipairs(party) do\n    if ent and ent.id and ent.buffs then\n        for _, b in pairs(ent.buffs) do\n            if b and tonumber(b.id) == CONFETTI then\n                local duration = tonumber(b.duration) or 0\n                holders[#holders + 1] = { ent = ent, duration = duration }\n                if duration <= 5 then\n                    triggered = true\n                end\n                break\n            end\n        end\n    end\nend\n\n-- Nobody is in the reminder window yet, keep waiting.\nif not triggered then\n    return\nend\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal white  = GUI:ColorConvertFloat4ToU32(1, 1, 1, 1)\nlocal drawer = TensorCore.getStaticDrawer(purple, 2)\n\nlocal iHaveIt = false\nfor _, h in ipairs(holders) do\n    local ms = h.duration * 1000\n    drawer:addTimedCircleOnEnt(ms, h.ent.id, CIRCLE_RADIUS)\n    -- Countdown in the middle of the circle showing how long it lasts (white text, with background).\n    if AnyoneCore and AnyoneCore.addWorldTextCountdownOnEnt then\n        AnyoneCore.addWorldTextCountdownOnEnt(ms, h.ent.id, white, true)\n    end\n    if me and h.ent.id == me.id then\n        iHaveIt = true\n    end\nend\n\nif iHaveIt and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(\"Knockback Party\", false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 117.905,
				name = "Confetti Reminder",
				timeRange = true,
				timelineIndex = 25,
				timerEndOffset = 2.0999999046326,
				timerStartOffset = -7.9000000953674,
				uuid = "9a9702a7-c42d-0039-a164-a706cc4d626b",
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
				name = "[Arrows] Callout Debuffs",
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
				name = "[Arrows] Draw Teleport Spots",
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
				name = "[Graven 3] Callout Tether",
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
				execute = "-- Confetti Reminder\n-- OnUpdate\n-- Once ANY player's Confetti (5078) is down to <= 5s, draw a purple circle on EVERY player who has\n-- the debuff (not just the ones already at <= 5s) so a slight timer skew doesn't drop a circle.\n-- If we have it, also shotcall \"Knockback Party\". Resolve (self.used) once we've drawn.\n\nlocal CONFETTI      = 5078\nlocal CIRCLE_RADIUS = 6\n\nlocal party = PerpCore.GetPartyEntities() or {}\nlocal me = PerpCore.GetPlayer(data.perspective)\n\n-- Collect everyone who currently has Confetti and their remaining duration.\nlocal holders = {}\nlocal triggered = false\nfor _, ent in ipairs(party) do\n    if ent and ent.id and ent.buffs then\n        for _, b in pairs(ent.buffs) do\n            if b and tonumber(b.id) == CONFETTI then\n                local duration = tonumber(b.duration) or 0\n                holders[#holders + 1] = { ent = ent, duration = duration }\n                if duration <= 5 then\n                    triggered = true\n                end\n                break\n            end\n        end\n    end\nend\n\n-- Nobody is in the reminder window yet, keep waiting.\nif not triggered then\n    return\nend\n\nlocal purple = GUI:ColorConvertFloat4ToU32(0.6, 0.1, 0.9, 0.4)\nlocal white  = GUI:ColorConvertFloat4ToU32(1, 1, 1, 1)\nlocal drawer = TensorCore.getStaticDrawer(purple, 2)\n\nlocal iHaveIt = false\nfor _, h in ipairs(holders) do\n    local ms = h.duration * 1000\n    drawer:addTimedCircleOnEnt(ms, h.ent.id, CIRCLE_RADIUS)\n    -- Countdown in the middle of the circle showing how long it lasts (white text, with background).\n    if AnyoneCore and AnyoneCore.addWorldTextCountdownOnEnt then\n        AnyoneCore.addWorldTextCountdownOnEnt(ms, h.ent.id, white, true)\n    end\n    if me and h.ent.id == me.id then\n        iHaveIt = true\n    end\nend\n\nif iHaveIt and AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(\"Knockback Party\", false, 5, false, 100)\nend\n\nself.used = true\n",
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
					
					{
						data = 
						{
							aType = "Lua",
							actionLua = "data.kefkaMarkers = data.kefkaMarkers or {}\ntable.insert(data.kefkaMarkers, eventArgs.markerID)\nself.used = true\n",
							conditions = 
							{
								
								{
									"b25bc53a-1a0e-571c-b497-99dc27eb57be",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "f2897081-a616-76a1-93c4-0550eaf77528",
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
							eventArgType = 3,
							markerIDList = 
							{
								677,
								678,
								673,
								674,
							},
							name = "Is Kefka Marker",
							uuid = "b25bc53a-1a0e-571c-b497-99dc27eb57be",
							version = 3,
						},
					},
				},
				eventType = 4,
				loop = true,
				mechanicTime = 185.952,
				name = "[MM3] Record Kefka Markers",
				timeRange = true,
				timelineIndex = 37,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "a4857ff2-a17e-44a4-8e4b-475602ee67d2",
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
							actionLua = "data.partyMarkers = data.partyMarkers or {}\ntable.insert(data.partyMarkers, eventArgs.markerID)\nself.used = true\n",
							conditions = 
							{
								
								{
									"2fc1ee6c-f0c4-ccb2-91c1-14b4bd600426",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "6c4dc328-d4d0-d4a1-b755-715a5d6952d9",
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
							eventArgType = 3,
							markerIDList = 
							{
								128,
								127,
							},
							name = "Is Party Marker",
							uuid = "2fc1ee6c-f0c4-ccb2-91c1-14b4bd600426",
							version = 3,
						},
					},
				},
				eventType = 4,
				loop = true,
				mechanicTime = 185.952,
				name = "[MM3] Record Party Markers",
				timeRange = true,
				timelineIndex = 37,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "5e0c9cb7-f375-b804-b50e-1979a2d23515",
				version = 2,
			},
			inheritedIndex = 2,
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
							actionLua = "-- Record the full AOE data (not just the id) so Draw Safespot can re-draw / subtract the shapes.\ndata.mm3AOEs = data.mm3AOEs or {}\ntable.insert(data.mm3AOEs, {\n    aoeID       = eventArgs.aoeID,\n    x           = eventArgs.x,\n    y           = eventArgs.y,\n    z           = eventArgs.z,\n    aoeCastType = eventArgs.aoeCastType,\n    aoeLength   = eventArgs.aoeLength,\n    aoeWidth    = eventArgs.aoeWidth,\n    heading     = eventArgs.heading,\n    duration    = eventArgs.duration,\n})\nself.used = true\n",
							conditions = 
							{
								
								{
									"c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
									true,
								},
							},
							endIfUsed = true,
							gVar = "ACR_RikuNIN3_CD",
							uuid = "068dbd1e-2b92-03b7-b8c7-b79f959f3299",
							version = 2.1,
						},
					},
				},
				conditions = 
				{
					
					{
						data = 
						{
							category = "Lua",
							conditionLua = "return eventArgs.aoeID == 47775 or eventArgs.aoeID == 47776 or eventArgs.aoeID == 47777",
							name = "Is Thunder AOE",
							uuid = "c7b16078-69d7-b2f4-bcaa-0a4a119cc1ee",
							version = 3,
						},
					},
				},
				eventType = 18,
				loop = true,
				mechanicTime = 185.952,
				name = "[MM3] Record AOEs",
				timeRange = true,
				timelineIndex = 37,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "8972979d-b46d-e510-bac8-1334ceee1624",
				version = 2,
			},
			inheritedIndex = 3,
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
				execute = "-- [MM3] Callout Safespot\n-- Resolves stack/spread + inside/outside cleave from the recorded markers and shotcalls once.\n-- Stays armed until every condition is met: exactly 2 kefka markers and at least 1 party marker.\n--   Kefka markers carry one fire (674 true / 673 false) and one thunder (678 true / 677 false).\n--   A party spread marker (127) = spread, stack marker (128) = stack -- but fire false flips it.\n--   Thunder true = outside cleave, thunder false = inside cleave.\n\nlocal FIRE_TRUE     = 674\nlocal FIRE_FALSE    = 673\nlocal THUNDER_TRUE  = 678\nlocal THUNDER_FALSE = 677\nlocal SPREAD_MARKER = 127\n\n-- Read-only: bail until the recorder reactions have created both tables. Do NOT initialise them\n-- here -- this runs on OnUpdate and must never race/clobber the data the recorders own.\nif not (data.kefkaMarkers and data.partyMarkers) then\n    return\nend\n\nlocal kefka = data.kefkaMarkers\nlocal party = data.partyMarkers\n\n-- Conditions: exactly 2 kefka markers (fire + thunder) and at least 1 party marker.\nif not (#kefka == 2 and #party >= 1) then\n    return\nend\n\n-- Resolve fire + thunder from the kefka markers.\nlocal fire, thunder = nil, nil\nfor _, id in ipairs(kefka) do\n    if id == FIRE_TRUE then fire = true\n    elseif id == FIRE_FALSE then fire = false\n    elseif id == THUNDER_TRUE then thunder = true\n    elseif id == THUNDER_FALSE then thunder = false end\nend\nif fire == nil or thunder == nil then\n    return\nend\n\n-- Spread vs stack from the party markers (anything that isn't spread is treated as stack).\nlocal hasSpread = false\nfor _, id in ipairs(party) do\n    if id == SPREAD_MARKER then hasSpread = true end\nend\n\nlocal mechanic = hasSpread and \"Spread\" or \"Stack\"\n-- Fire false inverts the mechanic.\nif not fire then\n    mechanic = (mechanic == \"Spread\") and \"Stack\" or \"Spread\"\nend\n\nlocal cleave = thunder and \"outside\" or \"inside\"\nlocal shotcall = mechanic .. \" \" .. cleave .. \" cleave\"\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(shotcall, false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 185.952,
				name = "[MM3] Callout Safespot",
				timeRange = true,
				timelineIndex = 37,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "b5170807-1c5f-f2cb-9d1d-76ebc9b11f2b",
				version = 2,
			},
			inheritedIndex = 4,
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
				execute = "-- [MM3] Draw Safespot\n-- Full-arena green circle with the thunder danger zones carved out via FLAG_OCCLUDE, so only safe\n-- ground stays green. Read-only on data; bails until 2 kefka markers, >=1 party marker AND every\n-- expected thunder AOE are present.\n--   thunder real (678) -> subtract real thunder   (47775), 2 AOEs.\n--   thunder fake (677) -> subtract thunder danger (47777), 4 AOEs total.\n\nlocal CENTER         = data.arenaCenter or { x = 100, y = 0, z = 100 }\nlocal ARENA_RADIUS   = data.arenaRadius or 20\nlocal SEG            = 50\n\nlocal THUNDER_TRUE   = 678 -- real thunder\nlocal THUNDER_FALSE  = 677 -- fake thunder\n\nlocal REAL_THUNDER   = 47775\nlocal FAKE_THUNDER   = 47776\nlocal THUNDER_DANGER = 47777\n\nif not (data.mm3AOEs and data.kefkaMarkers and data.partyMarkers) then\n    return\nend\n\nlocal aoes  = data.mm3AOEs\nlocal kefka = data.kefkaMarkers\nlocal party = data.partyMarkers\n\n-- Conditions: exactly 2 kefka markers (fire + thunder) and at least 1 party marker.\nif not (#kefka == 2 and #party >= 1) then\n    return\nend\n\n-- Resolve thunder: true = real, false = fake (fire markers are ignored here).\nlocal thunder\nfor _, id in ipairs(kefka) do\n    if id == THUNDER_TRUE then\n        thunder = true\n    elseif id == THUNDER_FALSE then\n        thunder = false\n    end\nend\nif thunder == nil then\n    return\nend\n\n-- Verify every expected thunder AOE is present (real = 2 real thunder; fake = 2 fake + 2 danger).\nlocal function countById(id)\n    local n = 0\n    for _, a in ipairs(aoes) do\n        if tonumber(a.aoeID) == id then n = n + 1 end\n    end\n    return n\nend\n\nlocal thunderOk\nif thunder then\n    thunderOk = countById(REAL_THUNDER) >= 2\nelse\n    thunderOk = countById(FAKE_THUNDER) >= 2 and countById(THUNDER_DANGER) >= 2\nend\n\nif not thunderOk then\n    return\nend\n\nif not (Argus2 and GUI and PerpCore and PerpCore.DrawAOEShape) then\n    return\nend\n\n-- Danger ID to subtract from the green: real -> real thunder, fake -> thunder danger.\nlocal dangerId = thunder and REAL_THUNDER or THUNDER_DANGER\n\n-- Match the draw lifetime to the danger AOEs (fallback 8s).\nlocal ms = 0\nfor _, a in ipairs(aoes) do\n    if tonumber(a.aoeID) == dangerId then\n        ms = math.max(ms, (tonumber(a.duration) or 6) * 1000)\n    end\nend\nif ms <= 0 then ms = 8000 end\n\n-- FLAG_OCCLUDE carves the draw out as negative space; FLAG_WARP_TERRAIN makes it follow the ground.\nlocal occlude = Argus2.RenderFlags.FLAG_OCCLUDE | Argus2.RenderFlags.FLAG_WARP_TERRAIN\nlocal green   = GUI:ColorConvertFloat4ToU32(0, 1, 0, 0.4)\n\n-- Full-arena green circle (solid fill), then subtract every danger AOE.\nArgus2.addTimedCircleFilled(ms, CENTER.x, CENTER.y, CENTER.z, ARENA_RADIUS, SEG, green, green, nil, 0, nil, nil, nil, 0)\n\nfor _, a in ipairs(aoes) do\n    if tonumber(a.aoeID) == dangerId then\n        PerpCore.DrawAOEShape(green, a.x, a.y, a.z, a.aoeCastType, a.aoeLength, a.aoeWidth, a.heading, ms, occlude)\n    end\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 185.952,
				name = "[MM3] Draw Safespot",
				timeRange = true,
				timelineIndex = 37,
				timerEndOffset = 5,
				timerStartOffset = -10,
				uuid = "fb716bb1-4d74-9862-80a0-7262ccf317bd",
				version = 2,
			},
			inheritedIndex = 5,
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
			inheritedIndex = 7,
		},
	},
	[38] = 
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
				execute = "-- [MM3] Cleanup\n-- Clear everything Mystery Magic 3 recorded/used so a later MM3 (or a fresh pull) starts clean.\n-- Setting to nil (not {}) lets the recorder reactions re-create the tables on their next event,\n-- and keeps the read-only Callout/Draw reactions bailing until data exists again.\ndata.mm3AOEs      = nil\ndata.kefkaMarkers = nil\ndata.partyMarkers = nil\n\nself.used         = true\n",
				executeType = 2,
				mechanicTime = 186.514,
				name = "[MM3] Cleanup",
				timelineIndex = 38,
				uuid = "e6b64e38-f999-9483-8172-6dbe4cd56a1e",
				version = 2,
			},
			inheritedIndex = 1,
		},
	},
	[41] = 
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
							actionLua = "-- Store Markers\n-- OnEntityMarkerAdd (condition already gates to the Forsaken markers: Stack 715, Circle 716, Cone 717)\n-- Record each marker against the name of the player it was placed on, in data.forsakenMarkers\n-- (keyed by player name -> markerID). Loops (self.used each fire) so all players get captured.\n\nlocal entityId = eventArgs.entityID or eventArgs.entityId\nlocal ent      = entityId and TensorCore and TensorCore.mGetEntity(entityId)\nlocal name     = ent and ent.name\n\nif not name or name == \"\" then\n    self.used = true\n    return\nend\n\ndata.forsakenMarkers = data.forsakenMarkers or {}\ndata.forsakenMarkers[name] = eventArgs.markerID\n\nself.used = true\n",
							gVar = "ACR_RikuNIN3_CD",
							uuid = "38bca9d6-da66-f3f1-8786-e6fb25a7c557",
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
							eventArgType = 3,
							markerIDList = 
							{
								715,
								716,
								717,
							},
							name = "Is Forsaken Marker",
							uuid = "515ba360-a107-1174-bc0c-dc7cef108d0e",
							version = 3,
						},
					},
				},
				enabled = false,
				eventType = 4,
				loop = true,
				mechanicTime = 234.608,
				name = "[Forsaken] Store First Markers",
				timeRange = true,
				timelineIndex = 41,
				timerEndOffset = 5,
				timerStartOffset = -5,
				uuid = "06a787e5-5ae2-25f0-9622-7f9552c15e68",
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
				execute = "-- Callout Marker + Role\n-- Uses data.forsakenMarkers (name -> markerID) captured by \"Store Markers\".\n-- Pair each role with its partner, find our buddy, and check whether we share a marker:\n--   shared marker     -> \"Helper\", towers 4,5,6,7\n--   different marker  -> \"Tower\",  towers 1,2,3,8\n-- Stores the buddy's name in data.forsakenBuddy for later reference.\n\n-- Partner groups (both directions so a lookup works from either side).\nlocal PARTNERS = {\n    MT = \"H1\", H1 = \"MT\",\n    OT = \"H2\", H2 = \"OT\",\n    M1 = \"R1\", R1 = \"M1\",\n    M2 = \"R2\", R2 = \"M2\",\n}\n\n-- Forsaken marker IDs -> readable name.\nlocal MARKER_NAMES = {\n    [715] = \"Stack\",\n    [716] = \"Circle\",\n    [717] = \"Cone\",\n}\n\nif not (PerpCore and data.forsakenMarkers) then\n    return\nend\n\n-- Our role.\nlocal me     = PerpCore.GetPlayer()\nlocal myRole = me and PerpCore.GetPlayerRole(me)\nif not myRole then\n    return\nend\n\n-- Our buddy's role -> assigned name. Remember it for later.\nlocal buddyRole = PARTNERS[myRole]\nlocal buddyName = buddyRole and PerpCore.Config.PartyRoles[buddyRole]\ndata.forsakenBuddy = buddyName\n\n-- Both markers must be stored before we can resolve helper vs tower.\nlocal myMarker    = me.name and data.forsakenMarkers[me.name]\nlocal buddyMarker = buddyName and data.forsakenMarkers[buddyName]\nif not myMarker or not buddyMarker then\n    return\nend\n\n-- Sharing the marker with our buddy makes us the helper (towers 4-7); otherwise we're a tower (1,2,3,8).\nlocal shared        = (myMarker == buddyMarker)\nlocal roleLabel     = shared and \"Helper\" or \"Tower\"\nlocal towers        = shared and \"Towers 4,5,6,7\" or \"Towers 1,2,3,8\"\nlocal partnerMarker = MARKER_NAMES[buddyMarker] or tostring(buddyMarker)\n\nlocal callout = roleLabel .. \" | \" .. towers .. \" | Partner is \" .. partnerMarker\nif AnyoneCore and AnyoneCore.Shotcall then\n    AnyoneCore.Shotcall(callout, false, 5, false, 100)\nend\n\nself.used = true\n",
				executeType = 2,
				mechanicTime = 234.608,
				name = "[Forsaken] Callout Marker + Role",
				randomOffset = 5,
				timeRange = true,
				timelineIndex = 41,
				timerEndOffset = 5,
				timerOffset = -5,
				timerStartOffset = -5,
				uuid = "824579df-edd1-7c37-b789-eee1838064c0",
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