use("ispec")

countCorrectColorAndPosition = method(secret, guess,
	secret zip(guess) count(equals?)
)

countCorrectColorWrongPosition = method(secret, guess,
	pairsWithWrongPosition = secret zip(guess) filter(different?)

	secret distinct map(color, countWrongPositionForOneColor(pairsWithWrongPosition, color)) sum
)

countWrongPositionForOneColor = method(pairsWithWrongPosition, color,
	[pairsWithWrongPosition count(first == color), pairsWithWrongPosition count(second == color)] min
)

Mixins Enumerable sum = method(self inject(+))
Mixins Enumerable distinct = method(set(*self))
Mixins Enumerable equals? = method(self inject(==))
Mixins Enumerable different? = method(self inject(!=))

describe("countCorrectColorAndPosition",
	it("should recognize when no peg is correct position or color",
		countCorrectColorAndPosition(["B","B","B","B"], ["N","N","N","N"]) should == 0
	)
	it("should recognize when one peg is correct position and color",
		countCorrectColorAndPosition(["B","B","B","B"], ["B","N","N","N"]) should == 1
	)
	it("should recognize when all pegs are correct positions and colors",
		countCorrectColorAndPosition(["B","B","B","B"], ["B","B","B","B"]) should == 4
	)
)

describe("countCorrectColorWrongPosition",
	it("should recognize when no peg is correct color",
		countCorrectColorWrongPosition(["B","B","B","B"], ["N","N","N","N"]) should == 0
	)
	it("should recognize when a peg is correct color and wrong position",
		countCorrectColorWrongPosition(["V","B","B","B"], ["N","V","N","N"]) should == 1
	)
	it("should recognize when there are more pegs of a given color in the guess than in the secret, and ignore these pegs",
		countCorrectColorWrongPosition(["V","B","B","B"], ["N","V","V","N"]) should == 1
	)
	it("should ignore pegs with correct position and color",
		countCorrectColorWrongPosition(["V","B","B","V"], ["V","V","N","N"]) should == 1
	)
	it("should recognize when pegs are correct colors for multiple colors",
		countCorrectColorWrongPosition(["V","R","B","B"], ["R","V","N","N"]) should == 2
	)
)