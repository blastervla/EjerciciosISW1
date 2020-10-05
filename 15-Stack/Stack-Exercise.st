!classDefinition: #OOStackTest category: #'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:48'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'first'.
	secondPushedObject := 'second'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: #'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'VP 10/4/2020 16:44:59'!
test01FindInFinderWithoutSentencesShouldReturnEmptyResults
	
	| finder |
	finder := SentenceFinderByPrefix new.
	self assert: (finder find: 'A') isEmpty.! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'VP 10/4/2020 17:13:44'!
test02FindInFinderWithEmptyPrefixShouldRaiseError
	
	| finder |
	finder := SentenceFinderByPrefix new.
	
	self should: [ (finder find: '') ]
		raise: Error
		withMessageText: SentenceFinderByPrefix emptyPrefixErrorDescription.	! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'VP 10/4/2020 17:14:18'!
test03FindInFinderWithSpacedPrefixShouldRaiseError
	
	| finder |
	finder := SentenceFinderByPrefix new.
	
	self should: [ (finder find: 'Hola ') ]
		raise: Error
		withMessageText: SentenceFinderByPrefix spacedPrefixErrorDescription.	! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'VP 10/4/2020 17:23:33'!
test04FindInFinderWithNonPrefixShouldReturnEmptyResults
	
	| finder |
	finder := SentenceFinderByPrefix newWith: {
		'Einstein dijo'.
		'Hay dos cosas que son infinitas'.
		'Y del universo, no estoy tan seguro'.
	}.
	
	self assert: (finder find: 'o') isEmpty.! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'VP 10/4/2020 17:23:25'!
test05FindInFinderWithWrongCasePrefixShouldReturnEmptyResults
	
	| finder |
	finder := SentenceFinderByPrefix newWith: {
		'Einstein dijo'.
		'Hay dos cosas que son infinitas'.
		'Y del universo, no estoy tan seguro'.
	}.
	
	self assert: (finder find: 'einstein') isEmpty.! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'VP 10/4/2020 17:24:10'!
test06FindInFinderWithPrefixShouldReturnAllPrefixedSenteces
	
	| sentences finder prefixedSentences |
	sentences := {
		'Einstein dijo'.
		'Einstein: Hay dos cosas que son infinitas'.
		'Einstein: Y del universo, no estoy tan seguro'.
	}.
	
	finder := SentenceFinderByPrefix newWith: sentences.
	
	prefixedSentences := finder find: 'Einstein:'.
	
	self assert: prefixedSentences size = 2.
	self assert: (prefixedSentences at: 1) = (sentences at: 2).
	self assert: (prefixedSentences at: 2) = (sentences at: 3).! !

!SentenceFinderByPrefixTest methodsFor: 'tests' stamp: 'VP 10/4/2020 17:25:57'!
test07FindInFinderMultipleTimesShouldYieldSameResults
	
	| sentences finder |
	sentences := {
		'Einstein dijo'.
		'Einstein: Hay dos cosas que son infinitas'.
		'Einstein: Y del universo, no estoy tan seguro'.
	}.
	
	finder := SentenceFinderByPrefix newWith: sentences.
	
	self assert: (finder find: 'Einstein:') = (finder find: 'Einstein:').! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'topNode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:15:21'!
isEmpty
	^topNode isEmpty.! !

!OOStack methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:41:00'!
size
	^topNode size.! !

!OOStack methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:09:57'!
top
	^topNode value.! !


!OOStack methodsFor: 'initialization' stamp: 'VP 10/4/2020 16:07:25'!
initialize
	size := 0.
	topNode := OOStackNullNode new.
! !


!OOStack methodsFor: 'adding' stamp: 'VP 10/4/2020 16:26:20'!
push: anElement 
	
	topNode := OOStackNode newWith: anElement nextNode: topNode.
	size := size + 1.! !


!OOStack methodsFor: 'removing' stamp: 'VP 10/5/2020 18:12:53'!
pop
	| topValue |
	
	topValue := topNode value.
	topNode := topNode next.
	
	size := size - 1.
	^topValue.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: #'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 10/1/2020 18:08:13'!
stackEmptyErrorDescription
	
	^ 'Stack is empty!!'! !


!OOStack class methodsFor: 'instance creation' stamp: 'VP 10/4/2020 15:28:07'!
new
	^self basicNew initialize.! !


!classDefinition: #OOStackNode category: #'Stack-Exercise'!
Object subclass: #OOStackNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:14:48'!
isEmpty
	self subclassResponsibility.! !

!OOStackNode methodsFor: 'accessing' stamp: 'VP 10/4/2020 16:03:05'!
next
	self subclassResponsibility.! !

!OOStackNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:40:21'!
size
	self subclassResponsibility.! !

!OOStackNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:15:45'!
value
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackNode class' category: #'Stack-Exercise'!
OOStackNode class
	instanceVariableNames: ''!

!OOStackNode class methodsFor: 'as yet unclassified' stamp: 'VP 10/4/2020 15:52:07'!
newWith: anElement nextNode: nextNode
	
	^OOStackLinkedNode new initializeWith: anElement nextNode: nextNode.! !


!classDefinition: #OOStackLinkedNode category: #'Stack-Exercise'!
OOStackNode subclass: #OOStackLinkedNode
	instanceVariableNames: 'content nextNode'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackLinkedNode methodsFor: 'initialization' stamp: 'VP 10/4/2020 15:48:04'!
initializeWith: aContent nextNode: aNextNode
	content := aContent.
	nextNode := aNextNode.! !


!OOStackLinkedNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:15:00'!
isEmpty
	^false.! !

!OOStackLinkedNode methodsFor: 'accessing' stamp: 'VP 10/4/2020 16:03:38'!
next
	^nextNode.! !

!OOStackLinkedNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:40:45'!
size
	^1 + nextNode size.! !

!OOStackLinkedNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 17:57:45'!
tryToPopIn: aStack
	^aStack doPopLinkedNode: self.! !

!OOStackLinkedNode methodsFor: 'accessing' stamp: 'VP 10/4/2020 16:08:40'!
value
	^content.! !


!classDefinition: #OOStackNullNode category: #'Stack-Exercise'!
OOStackNode subclass: #OOStackNullNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackNullNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:15:09'!
isEmpty
	^true.! !

!OOStackNullNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:11:32'!
next
	self error: OOStack stackEmptyErrorDescription.! !

!OOStackNullNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:40:53'!
size
	^0.! !

!OOStackNullNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 17:57:54'!
tryToPopIn: aStack
	
	aStack doPopNullNode: self.! !

!OOStackNullNode methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:09:43'!
value
	self error: OOStack stackEmptyErrorDescription.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackNullNode class' category: #'Stack-Exercise'!
OOStackNullNode class
	instanceVariableNames: ''!

!OOStackNullNode class methodsFor: 'as yet unclassified' stamp: 'VP 10/4/2020 16:09:06'!
noContentErrorDescription
	^'Can not ask for content of NullNode'.! !

!OOStackNullNode class methodsFor: 'as yet unclassified' stamp: 'VP 10/4/2020 16:05:34'!
noNextNodeErrorDescription
	^'Can not ask for next node of NullNode'.! !


!classDefinition: #SentenceFinderByPrefix category: #'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'sentences'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'initialization' stamp: 'VP 10/4/2020 16:41:07'!
initialize

	sentences := OOStack new.! !

!SentenceFinderByPrefix methodsFor: 'initialization' stamp: 'VP 10/4/2020 17:01:25'!
initializeWith: aCollection

	self initialize.
	self fillStackWith: aCollection.! !


!SentenceFinderByPrefix methodsFor: 'accessing' stamp: 'VP 10/5/2020 18:37:38'!
find: aSentencePrefix
	self throwErrorIfEmpty: aSentencePrefix.
	self throwErrorIfContainsSpaces: aSentencePrefix.
	
	^self sentencesFromStack select: [ :sentence | sentence beginsWith: aSentencePrefix ].! !


!SentenceFinderByPrefix methodsFor: 'accessing -- private' stamp: 'VP 10/4/2020 17:00:48'!
fillStackWith: aSentenceCollection
	
	aSentenceCollection do: [ :sentence |
		sentences push: sentence
	].! !

!SentenceFinderByPrefix methodsFor: 'accessing -- private' stamp: 'VP 10/5/2020 18:31:55'!
restoreStackWith: aSentenceCollection
	
	self fillStackWith: aSentenceCollection.! !

!SentenceFinderByPrefix methodsFor: 'accessing -- private' stamp: 'VP 10/5/2020 18:37:38'!
sentencesFromStack
	
	| sentenceCollection |
	sentenceCollection := OrderedCollection new.
	
	1 to: sentences size do: [ :sentenceIndex |
		sentenceCollection addFirst: sentences pop.
	].
	
	self restoreStackWith: sentenceCollection.

	^sentenceCollection.! !


!SentenceFinderByPrefix methodsFor: 'validation -- private' stamp: 'VP 10/5/2020 18:35:09'!
throwErrorIfContainsSpaces: aSentencePrefix
	(aSentencePrefix includesSubString: ' ') ifTrue: [ self error: self class spacedPrefixErrorDescription ].! !

!SentenceFinderByPrefix methodsFor: 'validation -- private' stamp: 'VP 10/5/2020 18:34:52'!
throwErrorIfEmpty: aSentencePrefix
	aSentencePrefix isEmpty ifTrue: [ self error: self class emptyPrefixErrorDescription ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: #'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'instance creation' stamp: 'VP 10/4/2020 16:41:48'!
newWith: aSentenceCollection
	
	^self new initializeWith: aSentenceCollection.! !


!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'VP 10/4/2020 17:05:40'!
emptyPrefixErrorDescription
	^'Search prefix should be non-empty'! !

!SentenceFinderByPrefix class methodsFor: 'as yet unclassified' stamp: 'VP 10/4/2020 17:08:11'!
spacedPrefixErrorDescription
	^'Search prefix should not contain spaces'! !
