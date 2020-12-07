!classDefinition: #MarsRoverTest category: 'MarsRover'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:30:11'!
test01AnEmptyCommandSequenceLeavesMarsRoverInSamePosition

	| initialPosition initialNavigationDirection marsRover commands |
	
	commands := ''.
	initialPosition := 0@0.
	initialNavigationDirection := #North.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: initialNavigationDirection.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: initialPosition facingTo: initialNavigationDirection).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:31:13'!
test02MovingForwardInAnyDirectionMovesForwardMarsRoverPositionInSaidDirection

	| initialPosition marsRover commands finalPosition initialNavigationDirection |
	
	commands := 'f'.
	initialPosition := Point x: 0 y: 0.
	finalPosition := Point x: 0 y: 1.
	initialNavigationDirection := #North.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: initialNavigationDirection.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: finalPosition facingTo: initialNavigationDirection).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:32:08'!
test03MovingBackwardsInAnyDirectionMovesBackwardsMarsRoverPositionInSaidDirection

	| initialPosition marsRover commands finalPosition initialNavigationDirection |
	
	commands := 'b'.
	initialPosition := Point x: 0 y: 0.
	finalPosition := Point x: 0 y: -1.
	initialNavigationDirection := #North.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: initialNavigationDirection.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: finalPosition facingTo: initialNavigationDirection).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:33:30'!
test04RotateLeftInAnyDirectionLeavesMarsRoverFacingItsLeftDirection

	| initialPosition marsRover commands |
	
	commands := 'l'.
	initialPosition := Point x: 0 y: 0.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: #North.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: initialPosition facingTo: #West).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:34:26'!
test05RotateRightInAnyDirectionLeavesMarsRoverFacingItsRightDirection

	| initialPosition marsRover commands |
	
	commands := 'r'.
	initialPosition := Point x: 0 y: 0.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: #North.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: initialPosition facingTo: #East).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:35:03'!
test06MovingForwardAndBackwardsFacingSameDirectionLeavesMarsRoverInInitialPosition

	| initialPosition marsRover commands |
	
	commands := 'fb'.
	initialPosition := Point x: 0 y: 0.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: #North.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: initialPosition facingTo: #North).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:40:11'!
test07RotatingRightTwiceFacesMarsRoverInOppositeDirection

	| initialPosition marsRover commands |
	
	commands := 'rr'.
	initialPosition := Point x: 0 y: 0.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: #South.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: initialPosition facingTo: #North).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:40:17'!
test08RotatingLeftTwiceFacesMarsRoverInOppositeDirection

	| initialPosition marsRover commands |
	
	commands := 'll'.
	initialPosition := Point x: 0 y: 0.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: #South.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: initialPosition facingTo: #North).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:40:23'!
test09MovingInDifferentDirectionsEndsUpInExpectedPosition

	| initialPosition finalPosition marsRover commands |
	
	commands := 'flflfrrb'.
	initialPosition := Point x: 0 y: 0.
	finalPosition := Point x: 1 y: 1.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: #South.
	
	marsRover executeCommands: commands.
	
	self assert: (marsRover isAt: finalPosition facingTo: #South).! !

!MarsRoverTest methodsFor: 'tests' stamp: 'SO 12/7/2020 16:40:28'!
test10MarsRoverStopsMovingAfterAnInvalidCommand

	| initialPosition finalPosition marsRover commands |
	
	commands := 'ffllifrb'.
	initialPosition := Point x: 0 y: 0.
	finalPosition := Point x: 0 y: -2.
	marsRover := MarsRover atPosition: initialPosition facingAtDirection: #South.
	
	[ marsRover executeCommands: commands. ]
		on: Error
		do: [ :anError |
			self assert: (marsRover isAt: finalPosition facingTo: #North).
			].! !


!classDefinition: #MarsRover category: 'MarsRover'!
Object subclass: #MarsRover
	instanceVariableNames: 'position navigationDirection'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'initialization' stamp: 'SO 12/5/2020 18:55:34'!
initializeAtPosition: aPoint withNavigationDirection: aNavigationDirection 
	
	position := aPoint.
	navigationDirection := aNavigationDirection.! !


!MarsRover methodsFor: 'navigation' stamp: 'SO 12/5/2020 18:07:16'!
executeCommands: aCommandSequence 

	| commandsArray |
	
	commandsArray := aCommandSequence asArray.
	
	commandsArray do: [ :aCommand | 
			self processCommand: aCommand
		].
	
	! !

!MarsRover methodsFor: 'navigation' stamp: 'SO 12/7/2020 12:36:52'!
faceToDirection: aNavigationDirection

	navigationDirection := 	aNavigationDirection.! !

!MarsRover methodsFor: 'navigation' stamp: 'SO 12/7/2020 12:30:50'!
moveWithPoint: aPoint

	position := position + aPoint.! !


!MarsRover methodsFor: 'navigation - private' stamp: 'SO 12/7/2020 15:28:27'!
processCommand: aCommand

	navigationDirection executeCommand: aCommand for: self.
	! !


!MarsRover methodsFor: 'testing' stamp: 'SO 12/7/2020 12:25:15'!
isAt: aPoint facingTo: aNavigationDirection 
	
	^(position = aPoint) and: [navigationDirection direction = aNavigationDirection]
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'SO 12/7/2020 12:58:10'!
atPosition: aPoint facingAtDirection: aNavigationDirection 

	| actualNavigationDirection |
	
	actualNavigationDirection := MarsRoverNavigation initializeFor: aNavigationDirection ifNone: [].
	
	^self new initializeAtPosition: aPoint withNavigationDirection: actualNavigationDirection ! !


!classDefinition: #MarsRoverNavigation category: 'MarsRover'!
Object subclass: #MarsRoverNavigation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverNavigation methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:27:37'!
executeCommand: aCommand for: aMarsRover

	| navigationCommand |

	navigationCommand := MarsRoverNavigationCommand initializeFor: aCommand ifNone: [self fail].
	
	navigationCommand moveTowardsDirection: self for: aMarsRover.! !

!MarsRoverNavigation methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:45:21'!
moveBackwardsFor: aMarsRover

	^self subclassResponsibility ! !

!MarsRoverNavigation methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:00:52'!
moveForwardFor: aMarsRover

	^self subclassResponsibility ! !

!MarsRoverNavigation methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:45:34'!
rotateLeftFor: aMarsRover

	^self subclassResponsibility ! !

!MarsRoverNavigation methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:45:39'!
rotateRightFor: aMarsRover

	^self subclassResponsibility ! !


!MarsRoverNavigation methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:50:50'!
direction

	^self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverNavigation class' category: 'MarsRover'!
MarsRoverNavigation class
	instanceVariableNames: ''!

!MarsRoverNavigation class methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:57:03'!
direction

	^self subclassResponsibility ! !


!MarsRoverNavigation class methodsFor: 'initialization' stamp: 'SO 12/7/2020 12:59:13'!
initializeFor: aDirection ifNone: aNoneBlock

	^self subclasses 
		detect: [ :aNavigationDirection |
			aNavigationDirection direction = aDirection.
		]
		ifFound: [ :aNavigationDirection | aNavigationDirection new ]
		ifNone: aNoneBlock ! !


!classDefinition: #EastDirection category: 'MarsRover'!
MarsRoverNavigation subclass: #EastDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!EastDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:02:55'!
moveBackwardsFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: -1 y: 0)! !

!EastDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 15:59:21'!
moveForwardFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: 1 y: 0)! !

!EastDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:07:05'!
rotateLeftFor: aMarsRover

	aMarsRover faceToDirection: NorthDirection new! !

!EastDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:09:05'!
rotateRightFor: aMarsRover

	aMarsRover faceToDirection: SouthDirection new! !


!EastDirection methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:38:55'!
direction

	^#East! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EastDirection class' category: 'MarsRover'!
EastDirection class
	instanceVariableNames: ''!

!EastDirection class methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:56:08'!
direction

	^#East! !


!classDefinition: #NorthDirection category: 'MarsRover'!
MarsRoverNavigation subclass: #NorthDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!NorthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:02:17'!
moveBackwardsFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: 0 y: -1)! !

!NorthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 15:58:24'!
moveForwardFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: 0 y: 1)! !

!NorthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:05:41'!
rotateLeftFor: aMarsRover

	aMarsRover faceToDirection: WestDirection new! !

!NorthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:08:33'!
rotateRightFor: aMarsRover

	aMarsRover faceToDirection: EastDirection new! !


!NorthDirection methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:24:40'!
direction

	^#North! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NorthDirection class' category: 'MarsRover'!
NorthDirection class
	instanceVariableNames: ''!

!NorthDirection class methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:56:22'!
direction

	^#North! !


!classDefinition: #SouthDirection category: 'MarsRover'!
MarsRoverNavigation subclass: #SouthDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!SouthDirection methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:41:22'!
direction

	^#South! !


!SouthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:02:26'!
moveBackwardsFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: 0 y: 1)! !

!SouthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 15:59:00'!
moveForwardFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: 0 y: -1)! !

!SouthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:06:43'!
rotateLeftFor: aMarsRover

	aMarsRover faceToDirection: EastDirection new! !

!SouthDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:08:47'!
rotateRightFor: aMarsRover

	aMarsRover faceToDirection: WestDirection new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SouthDirection class' category: 'MarsRover'!
SouthDirection class
	instanceVariableNames: ''!

!SouthDirection class methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:56:31'!
direction

	^#South! !


!classDefinition: #WestDirection category: 'MarsRover'!
MarsRoverNavigation subclass: #WestDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!WestDirection methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:37:13'!
direction

	^#West! !


!WestDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:02:44'!
moveBackwardsFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: 1 y: 0)! !

!WestDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 15:59:11'!
moveForwardFor: aMarsRover

	aMarsRover moveWithPoint: (Point x: -1 y: 0)! !

!WestDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:06:56'!
rotateLeftFor: aMarsRover

	aMarsRover faceToDirection: SouthDirection new! !

!WestDirection methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:08:57'!
rotateRightFor: aMarsRover

	aMarsRover faceToDirection: NorthDirection new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WestDirection class' category: 'MarsRover'!
WestDirection class
	instanceVariableNames: ''!

!WestDirection class methodsFor: 'accessing' stamp: 'SO 12/7/2020 12:56:38'!
direction

	^#West! !


!classDefinition: #MarsRoverNavigationCommand category: 'MarsRover'!
Object subclass: #MarsRoverNavigationCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverNavigationCommand methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:11:04'!
moveTowardsDirection: aDirection for: aMarsRover

	^self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverNavigationCommand class' category: 'MarsRover'!
MarsRoverNavigationCommand class
	instanceVariableNames: ''!

!MarsRoverNavigationCommand class methodsFor: 'accessing' stamp: 'SO 12/7/2020 16:17:13'!
commandType

	^self subclassResponsibility ! !


!MarsRoverNavigationCommand class methodsFor: 'initialization' stamp: 'SO 12/7/2020 16:16:55'!
initializeFor: aCommand ifNone: aNoneBlock

	^self subclasses 
		detect: [ :aNavigationCommand |
			aNavigationCommand commandType = aCommand.
		]
		ifFound: [ :aNavigationCommand | aNavigationCommand new ]
		ifNone: aNoneBlock ! !


!classDefinition: #BackwardsCommand category: 'MarsRover'!
MarsRoverNavigationCommand subclass: #BackwardsCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!BackwardsCommand methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:01:56'!
moveTowardsDirection: aDirection for: aMarsRover

	aDirection moveBackwardsFor: aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'BackwardsCommand class' category: 'MarsRover'!
BackwardsCommand class
	instanceVariableNames: ''!

!BackwardsCommand class methodsFor: 'accessing' stamp: 'SO 12/7/2020 16:17:32'!
commandType

	^$b! !


!classDefinition: #ForwardCommand category: 'MarsRover'!
MarsRoverNavigationCommand subclass: #ForwardCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!ForwardCommand methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:01:13'!
moveTowardsDirection: aDirection for: aMarsRover

	aDirection moveForwardFor: aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ForwardCommand class' category: 'MarsRover'!
ForwardCommand class
	instanceVariableNames: ''!

!ForwardCommand class methodsFor: 'accessing' stamp: 'SO 12/7/2020 16:17:43'!
commandType

	^$f! !


!classDefinition: #RotateLeftCommand category: 'MarsRover'!
MarsRoverNavigationCommand subclass: #RotateLeftCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!RotateLeftCommand methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:05:13'!
moveTowardsDirection: aDirection for: aMarsRover

	aDirection rotateLeftFor: aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RotateLeftCommand class' category: 'MarsRover'!
RotateLeftCommand class
	instanceVariableNames: ''!

!RotateLeftCommand class methodsFor: 'accessing' stamp: 'SO 12/7/2020 16:17:49'!
commandType

	^$l! !


!classDefinition: #RotateRightCommand category: 'MarsRover'!
MarsRoverNavigationCommand subclass: #RotateRightCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!RotateRightCommand methodsFor: 'navigation' stamp: 'SO 12/7/2020 16:08:16'!
moveTowardsDirection: aDirection for: aMarsRover

	aDirection rotateRightFor: aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RotateRightCommand class' category: 'MarsRover'!
RotateRightCommand class
	instanceVariableNames: ''!

!RotateRightCommand class methodsFor: 'accessing' stamp: 'SO 12/7/2020 16:17:54'!
commandType

	^$r! !
