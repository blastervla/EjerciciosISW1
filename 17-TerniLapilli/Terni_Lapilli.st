!classDefinition: #TerniLapilliTest category: #'Terni Lapilli'!
TestCase subclass: #TerniLapilliTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/29/2020 19:40:30'!
test01OnGameStartPlayerXBegins
	| game |
	
	game := TerniLapilli new.
	
	self deny: game isOver.
	self assert: game isPlayingX.
	self assert: 0 equals: game playedTokens.! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:52:02'!
test02AfterPlayerXTurnPlayerOShouldPlay
	| game |
	
	game := TerniLapilli new.
	game putXAt: 1@3.
	
	self deny: game isOver.
	self assert: game isPlayingO.
	self deny: game isPlayingX.
	self assert: 1 equals: game playedTokens.			! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:52:19'!
test03AfterPlayerOTurnPlayerXShouldMove
	| game |
	
	game := TerniLapilli new.
	game putXAt: 1@3.
	game putOAt: 2@3.
	
	self assert: game isPlayingX.
	self deny: game isPlayingO.
	self assert: 2 equals: game playedTokens.
	! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:52:27'!
test04PlayerOCantPlayOnPlayerXTurn
	| game |
	
	game := TerniLapilli new.
	self should: [game putOAt: 3@3] 
		raise: Error 
		withExceptionDo: [ :anError |
			self assert: 0 equals: game playedTokens.
			self assert: game isPlayingX.	
			self assert: (TerniLapilli invalidTurnPlayMessage) equals: anError messageText .
		].
		
! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:52:35'!
test05PlayerXCantPlayOnPlayerOTurn
	| game |
	
	game := TerniLapilli new.
	game putXAt: 2@3.
	self should: [game putXAt: 3@3] 
		raise: Error
		withExceptionDo: [ :anError |
			self assert: 1 equals: game playedTokens.
			self assert: game isPlayingO.	
			self assert: (TerniLapilli invalidTurnPlayMessage) equals: anError messageText .
		]
		
	
! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:55:49'!
test06PlayersCantPutMoreThanThreeTokensEach
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.

	self should: [game putXAt:3@3]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: 6 equals: game playedTokens.
			self assert: (TerniLapilli cantPlayMoreTokensMessage ) equals: anError messageText .
		]	! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:52:48'!
test07PlayerXTokenIsPlacedCorrectly
	| game |
	
	game := TerniLapilli new.
	game putXAt: 1@1.
	
	self assert: (game XTokenAt: 1@1).
	self deny: (game OTokenAt: 1@1).! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:53:11'!
test08PlayerOTokenIsPlacedCorrectly
	| game |
	
	game := TerniLapilli new.
	game putXAt: 1@1.
	game putOAt: 2@1.	
	
	self assert: (game XTokenAt: 1@1).
	self assert: (game OTokenAt: 2@1).
	self deny: (game XTokenAt: 2@1).! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:53:20'!
test09PlayersCantStackTokens
	| game |
	
	game := TerniLapilli new.
	game putXAt: 1@1.
	
	self should: [game putOAt: 1@1] 
	raise: Error  
	withExceptionDo: [:anError | 
		self assert: 1 equals: game playedTokens.
		self assert: (game XTokenAt: 1@1).
		self assert: (TerniLapilli cantStackTokensMessage: 1@1) equals: anError messageText .
	]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:11:46'!
test10TokenCantBePutOutsideBoard
	| game |
	
	game := TerniLapilli new.

	
	self should: [	game putXAt: 4@-1.] 
	raise: Error  
	withExceptionDo: [:anError | 
		self assert: 0 equals: game playedTokens.
		self assert: (TerniLapilli tokenOutOfBoardMessage: 4@-1) equals: anError messageText .
	]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:49:18'!
test11TokenFromAnyPointCanBeMovedNonDiagonally
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.
	
	game moveXFrom: 3@2 to: 3@3.
	self assert: (game XTokenAt: 3@3).! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:49:35'!
test12TokenFromNonStarPointCantBeMovedDiagonally
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.
	
	self should: [game moveXFrom: 3@2 to: 2@3]
		raise: Error
		withExceptionDo: [:anError |
			self assert: (game XTokenAt: 3@2).
			self assert: (TerniLapilli cantMoveDiagonallyFrom: 3@2) equals: anError messageText .
		]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:49:38'!
test13TokenCantBeMovedOutOfBoard
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.
	
	self should: [game moveXFrom: 3@2 to: 4@2]
		raise: Error
		withExceptionDo: [:anError |
			self assert: (game XTokenAt: 3@2).
			self assert: (TerniLapilli tokenOutOfBoardMessage: 4@2) equals: anError messageText .
		]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:49:19'!
test14CantMoveInexistentToken
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.
	
	self should: [game moveXFrom: 3@3 to: 2@3]
		raise: Error
		withExceptionDo: [:anError |	
			self deny: (game XTokenAt: 3@3).
			self deny: (game XTokenAt: 2@3).
			self assert: (TerniLapilli movingInexistentTokenMessage: 3@3) equals: anError messageText .
		]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:49:46'!
test15CantMoveAndStackTokens
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.
	
	self should: [game moveXFrom: 1@1 to: 1@2]
		raise: Error
		withExceptionDo: [:anError |	
			self assert: (game XTokenAt: 1@1).
			self assert: (TerniLapilli cantStackTokensMessage: 1@2) equals: anError messageText .
		]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:49:51'!
test16PlayerCantMoveOnOtherPlayersTurn
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.
	
	game moveXFrom: 3@2 to: 3@1.
	
	self should: [game moveXFrom: 3@1 to: 3@2]
		raise: Error
		withExceptionDo: [:anError |	
			self assert: (game XTokenAt: 3@1).
			self deny: (game XTokenAt: 2@3).
			self assert: (TerniLapilli invalidTurnPlayMessage ) equals: anError messageText .
		]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:46:46'!
test17PlayerCantMoveOnPutPhase
	| game |
	
	game := TerniLapilli new.
	game putXAt: 1@1.
	game putOAt: 2@1.
	game putXAt: 2@2.
	game putOAt: 1@2.
	game putXAt: 3@2.

	self should: [game moveOFrom: 1@2 to: 1@3]
		raise: Error
		withExceptionDo: [:anError |	
			self assert: (game OTokenAt: 1@2).
			self assert: (TerniLapilli cantMoveTokenYetMessage ) equals: anError messageText .
		]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 10/31/2020 19:50:23'!
test18CantMoveToNonNeighborPoint
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.
	
	self should: [game moveXFrom: 1@1 to: 3@3]
		raise: Error
		withExceptionDo: [:anError |	
			self assert: (game XTokenAt: 1@1).
			self deny: (game XTokenAt: 3@3).
			self assert: (TerniLapilli cantMoveToNonNeighborPositionMessage ) equals: anError messageText .
		]! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 20:02:12'!
test19GameIsOverWhen3TokensAreInLine
	| game |
	
	game := TerniLapilli new.
	self fillWithThreeInLineXTokens: game.

	self assert: (game isOver).


		! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 20:02:12'!
test20CantPlayTokenWhenGameIsOver
	| game |
	
	game := TerniLapilli new.
	self fillWithThreeInLineXTokens: game.

	self should: [game putOAt: 1@3]
			raise: Error
			withExceptionDo: [:anError |	
				self assert: (game isOver).
				self assert: (TerniLapilli gameIsAlreadyOverMessage ) equals: anError messageText .
			]	


		! !

!TerniLapilliTest methodsFor: 'test' stamp: 'MG 11/1/2020 19:58:47'!
test21CantMoveTokenWhenGameIsOver
	| game |
	
	game := TerniLapilli new.
	self fillBoard: game.

	game moveXFrom: 3@2 to: 3@3. 
	self should: [game moveOFrom: 1@3 to: 2@3]
			raise: Error
			withExceptionDo: [:anError |	
				self assert: (game isOver).
				self assert: (TerniLapilli gameIsAlreadyOverMessage ) equals: anError messageText .
			]	


		! !


!TerniLapilliTest methodsFor: 'test -- private' stamp: 'MG 10/31/2020 19:48:51'!
fillBoard: aTerniLapilliNewGame
	
	aTerniLapilliNewGame putXAt: 1@1.
	aTerniLapilliNewGame putOAt: 2@1.
	aTerniLapilliNewGame putXAt: 2@2.
	aTerniLapilliNewGame putOAt: 1@2.
	aTerniLapilliNewGame putXAt: 3@2.
	aTerniLapilliNewGame putOAt: 1@3.
	
	! !

!TerniLapilliTest methodsFor: 'test -- private' stamp: 'MG 11/1/2020 20:02:12'!
fillWithThreeInLineXTokens: aNewTerniLapilliGame
	aNewTerniLapilliGame putXAt: 1@1.
	aNewTerniLapilliGame putOAt: 2@1.
	aNewTerniLapilliGame putXAt: 2@2.
	aNewTerniLapilliGame putOAt: 1@2.
	aNewTerniLapilliGame putXAt: 3@3.



		! !


!classDefinition: #Player category: #'Terni Lapilli'!
Object subclass: #Player
	instanceVariableNames: 'tokens'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!Player methodsFor: 'initialization' stamp: 'MG 10/31/2020 14:39:52'!
initialize
	tokens := OrderedCollection new.! !


!Player methodsFor: 'accessing' stamp: 'MG 10/31/2020 14:54:44'!
hasTokenAt: aPoint
	^tokens includes: aPoint.! !

!Player methodsFor: 'accessing' stamp: 'MG 10/31/2020 16:44:27'!
hasWon
	
	^self tokenAmount = 3 and: [ | token1 token2 token3 |
		token1 := tokens at: 1.
		token2 := tokens at: 2.
		token3 := tokens at: 3.
		
		(self calculateTriangleAreaFrom: token1 to: token2 to: token3) = 0.
	]! !

!Player methodsFor: 'accessing' stamp: 'MG 10/31/2020 14:46:38'!
tokenAmount
	^tokens size.! !


!Player methodsFor: 'gameplay' stamp: 'MG 10/31/2020 14:38:41'!
addTokenAt: aPoint
	tokens add: aPoint.! !

!Player methodsFor: 'gameplay' stamp: 'MG 10/31/2020 14:49:06'!
moveFrom: srcPoint to: dstPoint
	tokens replaceAll: srcPoint with: dstPoint.! !


!Player methodsFor: 'accessing -- private' stamp: 'MG 10/31/2020 16:43:00'!
calculateTriangleAreaFrom: point1 to: point2 to: point3
	
	^(point1 x * ( point2 y - point3 y)) + (point2 x * (point3 y - point1 y)) + (point3 x * (point1 y - point2 y)).
! !


!classDefinition: #TerniLapilli category: #'Terni Lapilli'!
Object subclass: #TerniLapilli
	instanceVariableNames: 'playerX playerO currentTurn gameState'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 18:53:30'!
OTokenAt: aPoint 
	
	^playerO hasTokenAt: aPoint.! !

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 18:53:33'!
XTokenAt: aPoint 
	
	^playerX hasTokenAt: aPoint.! !

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 16:31:16'!
hasPlayerOWon
	^playerO hasWon.! !

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 16:31:07'!
hasPlayerXWon
	^playerX hasWon.! !

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 16:30:33'!
isOver
	^self hasPlayerXWon or: [self hasPlayerOWon].! !

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 14:47:34'!
isPlayingO
	^self isPlaying: playerO.! !

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 14:47:40'!
isPlayingX
	^self isPlaying: playerX.! !

!TerniLapilli methodsFor: 'game state' stamp: 'MG 10/31/2020 18:18:21'!
playedTokens
	^playerO tokenAmount + playerX tokenAmount . ! !


!TerniLapilli methodsFor: 'gameplay' stamp: 'MG 10/31/2020 18:36:34'!
moveOFrom: srcPoint to: dstPoint 

	gameState tryMove: playerO tokenFrom: srcPoint to: dstPoint.
	
! !

!TerniLapilli methodsFor: 'gameplay' stamp: 'MG 10/31/2020 18:36:41'!
moveXFrom: srcPoint to: dstPoint 

	gameState tryMove: playerX tokenFrom: srcPoint to: dstPoint.! !

!TerniLapilli methodsFor: 'gameplay' stamp: 'MG 10/31/2020 18:30:14'!
putOAt: aPoint 
	
	gameState tryPut: playerO tokenAt: aPoint.
! !

!TerniLapilli methodsFor: 'gameplay' stamp: 'MG 10/31/2020 18:25:38'!
putXAt: aPoint 
	
	gameState tryPut: playerX tokenAt: aPoint.

	! !


!TerniLapilli methodsFor: 'initialization' stamp: 'MG 11/1/2020 20:22:54'!
initialize 
	
	playerX := Player new.
	playerO := Player new.
	currentTurn := TerniLapilliPlayerXTurn newWith: playerX.
	gameState := TerniLapilliState gameStateFor: self.! !


!TerniLapilli methodsFor: 'gameplay -- private' stamp: 'MG 10/31/2020 11:00:13'!
hasTokenAt: aPoint
	
	^(self XTokenAt: aPoint) or: [self OTokenAt: aPoint]! !

!TerniLapilli methodsFor: 'gameplay -- private' stamp: 'MG 10/31/2020 18:53:07'!
isStarPoint: aPoint 
	
	^(aPoint x + aPoint y) even.! !

!TerniLapilli methodsFor: 'gameplay -- private' stamp: 'MG 10/31/2020 14:42:58'!
isWithinBoardLimits: aPoint
	
	^aPoint between: 1@1 and: 3@3
	
	! !

!TerniLapilli methodsFor: 'gameplay -- private' stamp: 'MG 10/31/2020 18:52:44'!
move: aPlayer tokenFrom: srcPoint to: dstPoint 
	
	self verifyPlayerTurn: aPlayer.	
	self verifyValidMoveFrom: srcPoint to: dstPoint.
	
	aPlayer moveFrom: srcPoint to: dstPoint.
	self updateGameStateAfterPlayFrom: aPlayer.! !

!TerniLapilli methodsFor: 'gameplay -- private' stamp: 'MG 10/31/2020 18:52:29'!
put: aPlayer tokenAt: aPoint 
	
	self verifyPlayerTurn: aPlayer.
	self verifyValidPlayPosition: aPoint.
			
	aPlayer addTokenAt: aPoint.
	self updateGameStateAfterPlayFrom: aPlayer.
	
	! !


!TerniLapilli methodsFor: 'game state -- private' stamp: 'MG 11/1/2020 20:28:14'!
changeTurnToPlayerO

	currentTurn := TerniLapilliPlayerOTurn newWith: playerO.! !

!TerniLapilli methodsFor: 'game state -- private' stamp: 'MG 11/1/2020 20:28:06'!
changeTurnToPlayerX

	currentTurn := TerniLapilliPlayerXTurn newWith: playerX.! !

!TerniLapilli methodsFor: 'game state -- private' stamp: 'MG 11/1/2020 20:25:06'!
isPlaying: aPlayer
	
	^currentTurn isPlaying: aPlayer.
! !

!TerniLapilli methodsFor: 'game state -- private' stamp: 'MG 11/1/2020 20:27:14'!
updateGameStateAfterPlayFrom: aPlayer
	
	currentTurn changeTurn: self.
	gameState := TerniLapilliState gameStateFor: self.
	! !


!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 10/31/2020 19:06:07'!
verifyMoveToNeighborFrom: srcPoint to: dstPoint

"Se podria para mas claridad modificar la guarda del if implementando en la clase Point
el mensaje isNeighbor:aPoint "
	(srcPoint eightNeighbors includes: dstPoint) ifFalse: [^self error: (self class cantMoveToNonNeighborPositionMessage)]! !

!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 11/1/2020 20:29:53'!
verifyPlayerTurn: aPlayer 
	
	(self isPlaying: aPlayer) ifFalse: [^self error: (self class invalidTurnPlayMessage)].
	
	! !

!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 10/31/2020 19:06:15'!
verifyPositionInBoard: aPoint
	
	(self isWithinBoardLimits: aPoint) ifFalse:[^self error: (self class tokenOutOfBoardMessage: aPoint)].
	
	! !

!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 10/31/2020 19:06:18'!
verifyPositionIsNotOccupied: aPoint
	
	(self hasTokenAt: aPoint) ifTrue: [^self error: (self class cantStackTokensMessage: aPoint)].

	
	! !

!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 11/1/2020 19:49:19'!
verifyPositionIsOccupied: aPoint 

	(self hasTokenAt: aPoint) ifFalse: [^self error: (self class movingInexistentTokenMessage: aPoint)].

	! !

!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 10/31/2020 19:06:27'!
verifyValidDiagonalMoveFrom: srcPoint to: dstPoint
	((self isStarPoint: srcPoint) or: [self isStarPoint: dstPoint]) ifFalse:[self error: (self class cantMoveDiagonallyFrom: srcPoint )].
	! !

!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 10/31/2020 18:39:55'!
verifyValidMoveFrom: srcPoint to: dstPoint 


	self verifyPositionInBoard: dstPoint.
	self verifyMoveToNeighborFrom: srcPoint to: dstPoint.
	self verifyPositionIsOccupied: srcPoint.
	self verifyPositionIsNotOccupied: dstPoint.
	self verifyValidDiagonalMoveFrom: srcPoint to: dstPoint.
	
	! !

!TerniLapilli methodsFor: 'gameplay verifies -- private' stamp: 'MG 10/31/2020 11:03:36'!
verifyValidPlayPosition: aPoint
	
	self verifyPositionIsNotOccupied: aPoint.
	self verifyPositionInBoard: aPoint.
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilli class' category: #'Terni Lapilli'!
TerniLapilli class
	instanceVariableNames: ''!

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/31/2020 15:15:36'!
cantMoveDiagonallyFrom: srcPoint
	
	^'Token from: ', srcPoint asString, ' can not be moved diagonally'! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/31/2020 16:13:11'!
cantMoveToNonNeighborPositionMessage
	^'Cant move to non neighbor position'! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/31/2020 16:03:26'!
cantMoveTokenYetMessage
	^'Can not move tokens until all tokens have been put'! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/29/2020 18:58:14'!
cantPlayMoreTokensMessage
	^'Can not play more than 3 tokens per player. Players can move tokens'.! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/29/2020 20:26:44'!
cantStackTokensMessage: aPoint
	^'Can not place more tokens in ', aPoint asString.! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/31/2020 16:49:09'!
gameIsAlreadyOverMessage
	^'Can not play when a player has already won'! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/31/2020 19:00:31'!
invalidTurnPlayMessage 
	^'You can not play on this turn'.! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 11/1/2020 19:50:16'!
movingInexistentTokenMessage: aPoint
	^'There is no token to move at ', aPoint asString.! !

!TerniLapilli class methodsFor: 'as yet unclassified' stamp: 'MG 10/29/2020 20:34:53'!
tokenOutOfBoardMessage: aPoint
	^'Point ', aPoint asString , ' is outside of the board'.! !


!classDefinition: #TerniLapilliPlayerTurn category: #'Terni Lapilli'!
Object subclass: #TerniLapilliPlayerTurn
	instanceVariableNames: 'player'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliPlayerTurn methodsFor: 'game state' stamp: 'MG 11/1/2020 20:18:08'!
changeTurn: aTerniLapilliGame
	
	self subclassResponsibility.
	
	! !

!TerniLapilliPlayerTurn methodsFor: 'game state' stamp: 'MG 11/1/2020 20:16:42'!
isPlaying: aPlayer

	^aPlayer = player.! !


!TerniLapilliPlayerTurn methodsFor: 'initialization' stamp: 'MG 11/1/2020 20:24:03'!
initializeWith: aPlayer
	
	player := aPlayer.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliPlayerTurn class' category: #'Terni Lapilli'!
TerniLapilliPlayerTurn class
	instanceVariableNames: ''!

!TerniLapilliPlayerTurn class methodsFor: 'instance creation' stamp: 'MG 11/1/2020 20:23:37'!
newWith: aPlayer
	
	^self new initializeWith: aPlayer.! !


!classDefinition: #TerniLapilliPlayerOTurn category: #'Terni Lapilli'!
TerniLapilliPlayerTurn subclass: #TerniLapilliPlayerOTurn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliPlayerOTurn methodsFor: 'game state' stamp: 'MG 11/1/2020 20:20:34'!
changeTurn: aTerniLapilliGame

	aTerniLapilliGame changeTurnToPlayerX.! !


!classDefinition: #TerniLapilliPlayerXTurn category: #'Terni Lapilli'!
TerniLapilliPlayerTurn subclass: #TerniLapilliPlayerXTurn
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliPlayerXTurn methodsFor: 'game state' stamp: 'MG 11/1/2020 20:20:41'!
changeTurn: aTerniLapilliGame

	aTerniLapilliGame changeTurnToPlayerO.! !


!classDefinition: #TerniLapilliState category: #'Terni Lapilli'!
Object subclass: #TerniLapilliState
	instanceVariableNames: 'game'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliState methodsFor: 'initialization' stamp: 'MG 10/31/2020 18:27:08'!
initializeWith: aTerniLapilliGame 
	
	game := aTerniLapilliGame.! !


!TerniLapilliState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 18:34:00'!
tryMove: aPlayer tokenFrom: srcPoint to: dstPoint

	self subclassResponsibility ! !

!TerniLapilliState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 18:26:13'!
tryPut: aPlayer tokenAt: aPoint

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliState class' category: #'Terni Lapilli'!
TerniLapilliState class
	instanceVariableNames: ''!

!TerniLapilliState class methodsFor: 'instance creation' stamp: 'MG 10/31/2020 18:47:49'!
gameStateFor: aTerniLapilliGame

	^(self subclasses detect: [:aTerniLapilliState | aTerniLapilliState canHandle: aTerniLapilliGame]) newWith: aTerniLapilliGame.! !

!TerniLapilliState class methodsFor: 'instance creation' stamp: 'MG 10/31/2020 18:27:50'!
newWith: aTerniLapilliGame

	^self new initializeWith: aTerniLapilliGame.! !


!TerniLapilliState class methodsFor: 'instance creation -- private' stamp: 'MG 10/31/2020 18:47:02'!
canHandle: aTerniLapilliGame

	^self subclassResponsibility.! !


!classDefinition: #TerniLapilliGameOverState category: #'Terni Lapilli'!
TerniLapilliState subclass: #TerniLapilliGameOverState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliGameOverState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 19:29:18'!
tryMove: aPlayer tokenFrom: srcPoint to: dstPoint

	^self error: (game class gameIsAlreadyOverMessage )! !

!TerniLapilliGameOverState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 19:29:21'!
tryPut: aPlayer tokenAt: aPoint

	^self error: (game class gameIsAlreadyOverMessage )! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliGameOverState class' category: #'Terni Lapilli'!
TerniLapilliGameOverState class
	instanceVariableNames: ''!

!TerniLapilliGameOverState class methodsFor: 'instance creation -- private' stamp: 'MG 10/31/2020 18:49:38'!
canHandle: aTerniLapilliGame

	^aTerniLapilliGame isOver! !


!classDefinition: #TerniLapilliMoveState category: #'Terni Lapilli'!
TerniLapilliState subclass: #TerniLapilliMoveState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliMoveState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 18:35:04'!
tryMove: aPlayer tokenFrom: srcPoint to: dstPoint

	^game move: aPlayer tokenFrom: srcPoint to: dstPoint.! !

!TerniLapilliMoveState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 19:28:40'!
tryPut: aPlayer tokenAt: aPoint

	^self error: (game class cantPlayMoreTokensMessage)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliMoveState class' category: #'Terni Lapilli'!
TerniLapilliMoveState class
	instanceVariableNames: ''!

!TerniLapilliMoveState class methodsFor: 'instance creation -- private' stamp: 'MG 10/31/2020 18:50:07'!
canHandle: aTerniLapilliGame

	^aTerniLapilliGame playedTokens = 6! !


!classDefinition: #TerniLapilliPutState category: #'Terni Lapilli'!
TerniLapilliState subclass: #TerniLapilliPutState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Terni Lapilli'!

!TerniLapilliPutState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 19:29:32'!
tryMove: aPlayer tokenFrom: srcPoint to: dstPoint

	^self error: (game class cantMoveTokenYetMessage)! !

!TerniLapilliPutState methodsFor: 'gameplay' stamp: 'MG 10/31/2020 19:29:28'!
tryPut: aPlayer tokenAt: aPoint
	
	game put: aPlayer tokenAt: aPoint.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TerniLapilliPutState class' category: #'Terni Lapilli'!
TerniLapilliPutState class
	instanceVariableNames: ''!

!TerniLapilliPutState class methodsFor: 'instance creation -- private' stamp: 'MG 10/31/2020 18:50:21'!
canHandle: aTerniLapilliGame

	^aTerniLapilliGame playedTokens < 6! !
