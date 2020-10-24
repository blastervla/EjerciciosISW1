!classDefinition: #MarsRoverTest category: 'MarsRover'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:24:56'!
test01_deployRover_respectsDeployLocationAndOrientation

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: N.
	
	self assert: 2@3 equals: rover location.
	self assert: N equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:24:45'!
test02_RCommandOnRoverFacingN_leavesRoverFacingE

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: N.
	
	rover sendCommands: 'r'.
	
	self assert: 2@3 equals: rover location.
	self assert: E equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:24:33'!
test03_LCommandOnRoverFacingN_leavesRoverFacingW

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: N.
	
	rover sendCommands: 'l'.
	
	self assert: 2@3 equals: rover location.
	self assert: W equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:24:22'!
test04_RCommandOnRoverFacingW_leavesRoverFacingN

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: W.
	
	rover sendCommands: 'r'.
	
	self assert: 2@3 equals: rover location.
	self assert: N equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:24:09'!
test05_LCommandOnRoverFacingW_leavesRoverFacingS

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: W.
	
	rover sendCommands: 'l'.
	
	self assert: 2@3 equals: rover location.
	self assert: S equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:23:59'!
test06_RCommandOnRoverFacingS_leavesRoverFacingW

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: S.
	
	rover sendCommands: 'r'.
	
	self assert: 2@3 equals: rover location.
	self assert: W equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:23:48'!
test07_LCommandOnRoverFacingS_leavesRoverFacingE

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: S.
	
	rover sendCommands: 'l'.
	
	self assert: 2@3 equals: rover location.
	self assert: E equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:23:36'!
test08_RCommandOnRoverFacingE_leavesRoverFacingS

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: E.
	
	rover sendCommands: 'r'.
	
	self assert: 2@3 equals: rover location.
	self assert: S equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:23:24'!
test09_LCommandOnRoverFacingE_leavesRoverFacingN

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: E.
	
	rover sendCommands: 'l'.
	
	self assert: 2@3 equals: rover location.
	self assert: N equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:23:14'!
test10_LRCommandsOnRover_leavesRoverOrientationIntact

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: N.
	
	rover sendCommands: 'lr'.
	
	self assert: 2@3 equals: rover location.
	self assert: N equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:23:03'!
test11_FCommandOnRoverFacingN_movesRoverNorth

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: N.
	
	rover sendCommands: 'f'.
	
	self assert: 2@4 equals: rover location.
	self assert: N equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:22:51'!
test12_FCommandOnRoverFacingW_movesRoverWest

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: W.
	
	rover sendCommands: 'f'.
	
	self assert: 1@3 equals: rover location.
	self assert: W equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:22:39'!
test13_FCommandOnRoverFacingS_movesRoverSouth

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: S.
	
	rover sendCommands: 'f'.
	
	self assert: 2@2 equals: rover location.
	self assert: S equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:22:27'!
test14_FCommandOnRoverFacingE_movesRoverEast

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: E.
	
	rover sendCommands: 'f'.
	
	self assert: 3@3 equals: rover location.
	self assert: E equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:22:01'!
test15_BCommandOnRover_movesRoverOnOppositeForwardOrientation

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: N.
	
	rover sendCommands: 'b'.
	
	self assert: 2@2 equals: rover location.
	self assert: N equals: rover orientation.! !

!MarsRoverTest methodsFor: 'tests rover' stamp: 'VP 10/24/2020 18:21:41'!
test16_CommandStripWithUnknownCommandOnRover_leavesRoverInStateWhenUnknownCommandWasFound

	| rover |
	
	rover := MarsRover deployAt: 2@3 facing: N.
	
	self should: [rover sendCommands: 'rrfflfflblwbbbbbbb']
	raise: Error
	withExceptionDo: [ :anError |
		self assert: 4@0 equals: rover location.
		self assert: W equals: rover orientation.
	] description: (MarsRover notUnderstoodTextForCommand: 'w').
	
	! !


!classDefinition: #CardinalPoint category: 'MarsRover'!
Object subclass: #CardinalPoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CardinalPoint class' category: 'MarsRover'!
CardinalPoint class
	instanceVariableNames: ''!

!CardinalPoint class methodsFor: 'accessing' stamp: 'VP 10/24/2020 18:02:03'!
unitarianSpherePoint
	^self subclassResponsibility.! !


!CardinalPoint class methodsFor: 'associating' stamp: 'VP 10/24/2020 18:01:51'!
leftPoint
	^self subclassResponsibility.! !

!CardinalPoint class methodsFor: 'associating' stamp: 'VP 10/24/2020 18:01:56'!
rightPoint
	^self subclassResponsibility.! !


!classDefinition: #E category: 'MarsRover'!
CardinalPoint subclass: #E
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'E class' category: 'MarsRover'!
E class
	instanceVariableNames: ''!

!E class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:26:49'!
leftPoint
	^N.! !

!E class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:26:14'!
rightPoint
	^S.! !


!E class methodsFor: 'accessing' stamp: 'VP 10/24/2020 17:57:16'!
unitarianSpherePoint

	^1@0.! !


!classDefinition: #N category: 'MarsRover'!
CardinalPoint subclass: #N
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'N class' category: 'MarsRover'!
N class
	instanceVariableNames: ''!

!N class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:16:55'!
leftPoint
	^W.! !

!N class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:16:18'!
rightPoint
	^E.! !


!N class methodsFor: 'accessing' stamp: 'VP 10/24/2020 17:54:54'!
unitarianSpherePoint

	^0@1.! !


!classDefinition: #S category: 'MarsRover'!
CardinalPoint subclass: #S
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'S class' category: 'MarsRover'!
S class
	instanceVariableNames: ''!

!S class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:25:23'!
leftPoint
	^E.! !

!S class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:24:15'!
rightPoint
	^W.! !


!S class methodsFor: 'accessing' stamp: 'VP 10/24/2020 17:55:59'!
unitarianSpherePoint

	^0@-1.! !


!classDefinition: #W category: 'MarsRover'!
CardinalPoint subclass: #W
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'W class' category: 'MarsRover'!
W class
	instanceVariableNames: ''!

!W class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:23:31'!
leftPoint
	^S.! !

!W class methodsFor: 'associating' stamp: 'VP 10/24/2020 17:22:39'!
rightPoint
	^N.! !


!W class methodsFor: 'accessing' stamp: 'VP 10/24/2020 17:55:42'!
unitarianSpherePoint

	^-1@0.! !


!classDefinition: #MarsRover category: 'MarsRover'!
Object subclass: #MarsRover
	instanceVariableNames: 'location orientation'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'initialization' stamp: 'VP 10/24/2020 16:56:09'!
initializeDeployAt: aLocation facing: anOrientation 
	
	location := aLocation.
	orientation := anOrientation.! !


!MarsRover methodsFor: 'accessing' stamp: 'VP 10/24/2020 16:54:35'!
location
	^location.! !

!MarsRover methodsFor: 'accessing' stamp: 'VP 10/24/2020 16:55:23'!
orientation
	^orientation.! !


!MarsRover methodsFor: 'operation' stamp: 'VP 10/24/2020 18:25:50'!
sendCommands: aCommandStream
	aCommandStream do: [ :command |
		(self isUnknownCommand: command) ifTrue: [self raiseUnknownCommandErrorFor: command].
		
		command = $r ifTrue: [orientation := orientation rightPoint].
		command = $l ifTrue: [orientation := orientation leftPoint].
		command = $f ifTrue: [location := location + orientation unitarianSpherePoint].
		command = $b ifTrue: [location := location - orientation unitarianSpherePoint].
	].! !


!MarsRover methodsFor: 'error handling' stamp: 'VP 10/24/2020 18:19:30'!
raiseUnknownCommandErrorFor: aCommand

	^self signalErrorWith: (self class notUnderstoodTextForCommand: aCommand).! !


!MarsRover methodsFor: 'operation -- private' stamp: 'VP 10/24/2020 18:25:50'!
isUnknownCommand: command

	^ command ~= $r and: [command ~= $l] and: [command ~= $f] and: [command ~= $b]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'VP 10/24/2020 16:53:36'!
deployAt: aLocation facing: aCardinalPoint

	^self new initializeDeployAt: aLocation facing: aCardinalPoint. ! !


!MarsRover class methodsFor: 'error handling' stamp: 'VP 10/24/2020 18:14:15'!
notUnderstoodTextForCommand: anUnknownCommand 
	
	^'Received unknown command: ', anUnknownCommand.! !
