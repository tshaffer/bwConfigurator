Function bwConfigurator_Initialize(eventPort As Object, userVariables As Object, bsp as Object)

    print "bwConfigurator_Initialize - entry"
    print "type of eventPort is ";type(eventPort)
    print "type of userVariables is ";type(userVariables)
	print "type of bsp is ";type(bsp)

    bwConfigurator = newBWConfigurator(eventPort, userVariables, bsp)

    return bwConfigurator

End Function


Function newBWConfigurator(eventPort As Object, userVariables As Object, bsp as Object)
	print "initBWConfigurator"

	' Create the object to return and set it up
	s = {}
	s.version = 1.0
	s.eventPort = eventPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = bwConfigurator_ProcessEvent

	s.objectName = "bwConfigurator"

	s.bsp.sign.launchBWConfiguratorAA	=	{ HandleEvent: LaunchBWConfigurator, mVar: s }
    s.bsp.sign.localServer.AddGetFromEvent({ url_path: "/LaunchBWConfigurator", user_data: s.bsp.sign.launchBWConfiguratorAA})

	return s

End Function


Function bwConfigurator_ProcessEvent(event As Object) as boolean

	print "bwConfigurator_ProcessEvent: eventType = ";type(event)
    retval = false

	if type(event) = "roNetworkDiscoveryCompletedEvent" then
		print "roNetworkDiscoveryCompletedEvent"
		retval = true
	end if

	if type(event) = "roNetworkDiscoveryGeneralEvent" then
		print "roNetworkDiscoveryGeneralEvent"
		retval = true
	end if

	if type(event) = "roNetworkDiscoveryResolvedEvent" then
		complete = true
		data = event.GetData()
		if instr(1, data.name, "BrightSign Web Service") = 1 then
			print "DATA:"; data
			textdata = data[ "txt" ]
			if textdata <> invalid then
				print "TEXT: "; textdata
			endif
		endif
		retval = true
	end if

	return retval

End Function


' Handler for start setup from web page
Sub LaunchBWConfigurator(userData as Object, e as Object)

	bwConfigurator = userData.mVar
	bwConfigurator.e = e

	mVar = userData.mVar
	mVar.discovery = CreateObject("roNetworkDiscovery")
	if type(mVar.discovery) <> "roNetworkDiscovery" then
		stop
	end if

	print "type of message port is "; type(mVar.bsp.msgPort)

	mVar.discovery.SetPort(mVar.bsp.msgPort)
	mVar.discovery.Search({type: "_http._tcp"})		

	e.AddResponseHeader("Content-type", "text/plain")
	e.SetResponseBodyString("ok")
	e.SendResponse(200)

End Sub


