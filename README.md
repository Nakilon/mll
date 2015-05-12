# MLL (Mathematica Language Library)

## What

Этот гем не ставит перед собой цель полностью имитировать типы данных, синтаксис Wolfram Mathematica Language, или научить Ruby крутым визуализациям. Целью является вложить в Ruby мощь стандартной библиотеки. В перспективе визуализация возможна при помощи других гемов.

## Why

1. Важной является реализация https://reference.wolfram.com/language/ref/Listable.html: автоматическое применение функции ко всем элементам аргумента, если тот является List-ом (Array-ем в среде Ruby).
2. `::range`, в отличие от рубишного, может иметь отрицательный step.
3. `::table`, в отличие от рубишного `.map`, может создавать многомерные массивы одним вызовом, а не только вложенными.

## How

    MLL::range[ 2, 3 ] # => 2..3
    MLL::range[[2, 3]] # => [1..2, 1..3]
    MLL::range[ 1..3 ] # => [1..1, 1..2, 1..3]

    MLL::table[ ->(i,j){ i+j }, [[1, 0, 1]], [[0, 2, 0]] ]
                       # => [[1, 3, 1],
                             [0, 2, 0],
                             [1, 3, 1]]
    MLL::table[ MLL.method(:times), 9, 9 ]
                       # => [[1,  2,  3,  4,  5,  6,  7,  8,  9],
                             [2,  4,  6,  8, 10, 12, 14, 16, 18],
                             [3,  6,  9, 12, 15, 18, 21, 24, 27],
                             [4,  8, 12, 16, 20, 24, 28, 32, 36],
                             [5, 10, 15, 20, 25, 30, 35, 40, 45],
                             [6, 12, 18, 24, 30, 36, 42, 48, 54],
                             [7, 14, 21, 28, 35, 42, 49, 56, 63],
                             [8, 16, 24, 32, 40, 48, 56, 64, 72],
                             [9, 18, 27, 36, 45, 54, 63, 72, 81]]

    # http://stackoverflow.com/q/1475808/322020
    MLL::fold_list[ MLL::times, MLL::range[10] ]
                       # => [1,2,6,24,120,720,5040,40320,362880,3628800]

    # here is `Listable' magic, allowing to zip arrays
    #   even of different dimensions with basic operations
    MLL::times[ [[1,2],[3,4]], [5,6] ]
                       # => [[5,10], [18,24]]
    # ::times     means  *
    # ::divide    means  /
    # ::subtract  means  -
    # ::plus      means  +
    
    # http://en.wikipedia.org/wiki/Collatz_conjecture
    MLL::nest_list[ ->(i){ i.even? ? i/2 : (i*3+1)/2 }, 20, 10 ]
                       # => [20, 10, 5, 8, 4, 2, 1, 2, 1, 2, 1]

    MLL::subdivide[ 5, 10, 4 ]
                       # => [5.0, 6.25, 7.5, 8.75, 10.0]
    
    MLL::fold_list[ ->(a,b){ 10*a + b }, 0, [4,5,1,6,7,8] ]
                       # => [0,4,45,451,4516,45167,451678]

Note that to see some of above examples working you need `.to_a`, `.map(&:to_a)` or even `.to_a.map(&:to_a)` since lazyness is intensively used.

## Installation

    $ gem install mll

## Testing with RSpec before contributing

    rspec

or

    rake spec

## TODO (this section is filled automatically by `rake todo` task -- do not remove)

#### lib/mll.rb

```
module MLL
  def self.fold_list
    lambda do |f, x, list = nil|
      # TODO use Ruby#inject ?
  def self.table
    lambda do |f, *args|
      [].tap do |result|
        }]].tap do |stack|
          stack.each do |ai, ri|
            # TODO try to make #table lazy (Enumerator instead of Array)
  # TODO not sure if we need any other kind of Listability except of #range[[Array]]
```

#### spec/_spec.rb

```
# TODO move Properties & Relations to some separate contexts maybe
# TODO @fraggedICE wishes using Rational -- would also allow implementing more examples
# TODO elegantly get rid of repetitive type checks
# TODO ? let(:fake_lambda){ ->(*args){fail} }
=begin #power is Listable but not Orderless, but should accept *args
```
 Orderless, but should accept *args
```
s according to their description not content
# TODO elegantly get rid of repetitive type checks
# TODO ? implement #power for use in unittests
# TODO ? let(:fake_lambda){ ->(*args){fail} }
describe MLL do
  describe "List Manipulation" do
    describe "Constructing Lists" do
      describe "#table" do
        describe "Basic Examples" do
          example "table(lambda, n1, n2)" do
            # TODO example to README.rb about multiplication table
        describe "Scope" do
          # TODO: "Make a triangular array:"
      describe "#range" do
        # TODO take from docs more examples that involve other functions
        describe "Neat Examples" do
          example "range(range(range(n)))" do
            # TODO do the same .tap thing in other type tests
          # TODO Nest[Range,3,6]
        # TODO "Find an inverse permutation:"
        # TODO "Use Range or Span (;;) as Part specification:"
      describe "#nest_list" do
        describe "Properties & Relations" do
          # TODO "Nest gives the last element of NestList:"
    describe "Applying Functions to Lists" do
      describe "#fold_list" do
        describe "Applications" do
          # TODO "Find successively deeper parts in an expression:"
        describe "Properties & Relations" do
          # TODO "Functions that ignore their second argument give the same result as in NestList:"
          # TODO "Accumulate is equivalent to FoldList with Plus:"
    # TODO http://reference.wolfram.com/language/guide/ElementsOfLists.html
    # TODO http://reference.wolfram.com/language/guide/RearrangingAndRestructuringLists.html
    # TODO http://reference.wolfram.com/language/guide/MathematicalAndCountingOperationsOnLists.html
  describe "Functional Programming" do
    describe "Iteratively Applying Functions" do
      # TODO move #nest_list and #fold_list and others here?
      describe "#nest" do
        # TODO neat graphic examples
# TODO http://reference.wolfram.com/language/guide/HandlingArraysOfData.html
# TODO http://reference.wolfram.com/language/guide/ComputationWithStructuredDatasets.html
```
