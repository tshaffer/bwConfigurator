Function bwConfigurator_Initialize(msgPort As Object, userVariables As Object, bsp as Object)

    print "bwConfigurator_Initialize - entry"
    print "type of msgPort is ";type(msgPort)
    print "type of userVariables is ";type(userVariables)
	print "type of bsp is ";type(bsp)

    bwConfigurator = newBWConfigurator_Initialize(msgPort, userVariables, bsp)

    return bwConfigurator

End Function


Function newBWConfigurator(msgPort As Object, userVariables As Object, bsp as Object)
	print "initBWConfigurator"

	' Create the object to return and set it up
	s = {}
	s.version = 1.0
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = bwConfigurator_ProcessEvent

	s.objectName = "bwConfigurator"

	s.bsp.sign.launchBWConfiguratorAA	=	{ HandleEvent: LaunchBWConfigurator, mVar: s }
    s.bsp.sign.localServer.AddPostToFormData({ url_path: "/LaunchBWConfigurator", user_data: s.bsp.sign.launchBWConfiguratorAA})

	return s

End Function


Function bwConfigurator_ProcessEvent(event As Object) as boolean

	print "ProcessEvent: eventType = ";type(event)
    retval = false

	return retval

End Function


' Handler for start setup from web page
Sub LaunchBWConfigurator(userData as Object, e as Object)

	bwConfigurator = userData.mVar
	bwConfigurator.e = e

    args = e.GetFormData()

	userVariables = playerSetup.userVariables

	if type(userVariables) = "roAssociativeArray" then
		for each userVariableName in args
			if userVariables.DoesExist(userVariableName) then
				userVariable = userVariables.Lookup(userVariableName)
				userVariable.SetCurrentValue(args.Lookup(userVariableName), false)
			endif
		next
	endif

	bwConfigurator.StartSetup(userData)

End Sub


