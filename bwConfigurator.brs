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

    s.screens = invalid

	s.objectName = "bwConfigurator"

	s.bsp.sign.launchBWConfiguratorAA	=	{ HandleEvent: LaunchBWConfigurator, mVar: s }
    s.bsp.sign.localServer.AddGetFromEvent({ url_path: "/LaunchBWConfigurator", user_data: s.bsp.sign.launchBWConfiguratorAA})

	return s

End Function


Function bwConfigurator_ProcessEvent(event As Object) as boolean

	print "bwConfigurator_ProcessEvent: eventType = ";type(event)
    retval = false

    if type(event) = "roUrlEvent" and event.GetResponseCode() = 200

        userData = event.GetUserData()
        if type(userData) = "roAssociativeArray" then

            if type(userData.application) = "roString" then

                if userData.application = "brightWallApp" then

                    retVal = true
                    ipAddress$ = userData.ipAddress

                    status$ = event

                    if len(status$) > 0 then
                        currentStatusXML = CreateObject("roXMLElement")
                        currentStatusXML.Parse(status$)

                        if lcase(currentStatusXML.isBrightWall.getText()) = "true" then

                            stop

                            videoWallNumRows = currentStatusXML.videoWallNumRows.getText()
                            videoWallNumColumns = currentStatusXML.videoWallNumColumns.getText()
                            videoWallRowPosition = currentStatusXML.videoWallRowPosition.getText()
                            videoWallColumnPosition = currentStatusXML.videoWallColumnPosition.getText()

                            if videoWallNumRows<>"" and videoWallNumColumns<>"" and videoWallRowPosition<>"" and videoWallColumnPosition<>"" then
                                videoWallNumRows% = int(val(videoWallNumRows))
                                videoWallNumColumns% = int(val(videoWallNumColumns))
                                videoWallRowPosition% = int(val(videoWallRowPosition))
                                videoWallColumnPosition% = int(val(videoWallColumnPosition))

                                if m.screens = invalid then
                                    m.screens = CreateObject("roArray", videoWallNumRows% * videoWallNumColumns%, false)
                                    index% = (videoWallRowPosition% * videoWallNumColumns%) + videoWallRowPosition%

                                    screen = {}
                                    screen.ipAddress = ipAddress$
                                    m.screens[index%] = screen
                                endif
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endif

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

		' is it a BrightSign unit
		if instr(1, data.name, "BrightSign Web Service") = 1 then

			' FIXME - see hacks below
			' check the address
			' hack - weird stuff coming back - need to figure it out
			' also - don't make call on myself - not sure why it doesn't work
''			if instr(1, data.address, "10.1") = 1 and data.address <> "10.1.0.169" then
			if instr(1, data.address, "10.1") = 1 then

''				print "DATA:"; data
''				textdata = data[ "txt" ]
''				if textdata <> invalid then
''					print "TEXT: "; textdata
''				endif

				ipAddress$ = data.address
				url = "http://" + ipAddress$ + ":8080/GetCurrentStatus"
				m.statusXfer = CreateObject("roUrlTransfer")
				m.statusXfer.SetUrl(url)

				'FIXME need to set something that uniquely identifies this BrightWall - BrightWall name might be as good as it gets
				userData = {}
				userData.application = "brightWallApp"
				userData.ipAddress = ipAddress$
				m.statusXfer.SetUserData(userData)

            	m.statusXfer.SetPort(m.bsp.msgPort)

				print "IP address: ";ipAddress$
                ok = m.statusXfer.AsyncGetToString()
                if not ok stop

                return true


				' FIXME - make this asynchronous
				status$ = xfer.GetToString()
				if len(status$) > 0 then
					currentStatusXML = CreateObject("roXMLElement")
					currentStatusXML.Parse(status$)

					if lcase(currentStatusXML.isBrightWall.getText()) = "true" then

					    videoWallNumRows = currentStatusXML.videoWallNumRows.getText()
					    videoWallNumColumns = currentStatusXML.videoWallNumColumns.getText()
					    videoWallRowPosition = currentStatusXML.videoWallRowPosition.getText()
					    videoWallColumnPosition = currentStatusXML.videoWallColumnPosition.getText()

					    if videoWallNumRows<>"" and videoWallNumColumns<>"" and videoWallRowPosition<>"" and videoWallColumnPosition<>"" then
					        videoWallNumRows% = int(val(videoWallNumRows))
					        videoWallNumColumns% = int(val(videoWallNumColumns))
					        videoWallRowPosition% = int(val(videoWallRowPosition))
					        videoWallColumnPosition% = int(val(videoWallColumnPosition))

					        if m.screens = invalid then
					            m.screens = CreateObject("roArray", videoWallNumRows% * videoWallNumColumns%, false)
					            index% = (videoWallRowPosition% * videoWallNumColumns%) + videoWallRowPosition%

					            screen = {}
					            screen.ipAddress = ipAddress$
					            m.screens[index%] = screen
					        endif

					    endif

					endif

				endif
    


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


