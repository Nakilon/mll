# MLL (Mathematica Language Library)

[![Gem Version](https://badge.fury.io/rb/mll.svg)](http://badge.fury.io/rb/mll)

## What

This gem isn't supposed to mimic all data types, exact syntax of Wolfram Mathematica or make Ruby able to make the same visualisations.

The main goal is to make Ruby more powerful by including the most used functions, that Ruby lacks, such as `Table[]`, `FoldList[]`, etc. Visualisations are possible later by using additional gems.

## Why

0. `::map` can map Arrays at specified depth!
1. One of the most useful things is automatic zipping vectors (`Array`s) when you apply scalar functions to them. https://reference.wolfram.com/language/ref/Listable.html
2. unlike Ruby's `Range` class, `::range` can handle negative `step` and even have `float` starting value
3. unlike Ruby's `Array.new`, `::table` can create multidimensional arrays with a single call, not nested
4. `::fold_list` was wanted [here](http://stackoverflow.com/q/1475808/322020) in Ruby while being already implemented as [FoldList[]](http://reference.wolfram.com/language/ref/FoldList.html) in Mathematica and [scanl](http://hackage.haskell.org/package/base-4.8.0.0/docs/Prelude.html#v:scanl) in Haskell
5. `::nest` (n times) and `::nest_list` for repetitive applying the same function -- `::nest_while` and `::nest_while_list` are going to be implemented later
6. `::tally` -- shortcut to a probably the most common usage of `#group_by` -- calculating total occurences.

## How

    MLL::range[ 2, 3 ] # => 2..3
    MLL::range[[2, 3]] # => [1..2, 1..3]
    MLL::range[ 1..3 ] # => [1..1, 1..2, 1..3]

    t = MLL::table[ ->(i,j){ i+j }, [[1, 0, 1]], [[0, 2, 0]] ]
                       # => [[1, 3, 1],
                             [0, 2, 0],
                             [1, 3, 1]]
    t = MLL::map[ ->(i){ [i] }, t, [2] ]
                       # => [[ [1], [3], [1] ],
                             [ [0], [2], [0] ],
                             [ [1], [3], [1] ]]
    MLL::map[ ->(i){ -i }, t, [3] ]
                       # => [[ [-1], [-3], [-1] ],
                             [ [ 0], [-2], [ 0] ],
                             [ [-1], [-3], [-1] ]]

    MLL::table[ MLL::times, 9, 9 ]
                       # => [[1,  2,  3,  4,  5,  6,  7,  8,  9],
                             [2,  4,  6,  8, 10, 12, 14, 16, 18],
                             [3,  6,  9, 12, 15, 18, 21, 24, 27],
                             [4,  8, 12, 16, 20, 24, 28, 32, 36],
                             [5, 10, 15, 20, 25, 30, 35, 40, 45],
                             [6, 12, 18, 24, 30, 36, 42, 48, 54],
                             [7, 14, 21, 28, 35, 42, 49, 56, 63],
                             [8, 16, 24, 32, 40, 48, 56, 64, 72],
                             [9, 18, 27, 36, 45, 54, 63, 72, 81]]
    # ::times     means  *
    # ::divide    means  /
    # ::subtract  means  -
    # ::plus      means  +

    MLL::fold_list[ MLL::times, MLL::range[10] ]
                       # => [1,2,6,24,120,720,5040,40320,362880,3628800]

    # here is `Listable' magic, allowing to zip arrays
    #   even of different dimensions with basic operations
    MLL::times[ [[1,2],[3,4]], [5,6] ]
                       # => [[5,10], [18,24]]
    
    # http://en.wikipedia.org/wiki/Collatz_conjecture
    MLL::nest_list[ ->(i){ i.even? ? i/2 : (i*3+1)/2 }, 20, 10 ]
                       # => [20, 10, 5, 8, 4, 2, 1, 2, 1, 2, 1]

    MLL::fold_list[ ->(a,b){ 10*a + b }, 0, [4,5,1,6,7,8] ]
                       # => [0,4,45,451,4516,45167,451678]

    MLL::subdivide[ 5, 10, 4 ]
                       # => [5.0, 6.25, 7.5, 8.75, 10.0]
    
    MLL::tally[ "the quick brown fox jumps over the lazy dog".chars ]
    # => {"t"=>2, "h"=>2, "e"=>3, " "=>8, "q"=>1, "u"=>2, "i"=>1, "c"=>1, "k"=>1,
          "b"=>1, "r"=>2, "o"=>4, "w"=>1, "n"=>1, "f"=>1, "x"=>1, "j"=>1, "m"=>1,
          "p"=>1, "s"=>1, "v"=>1, "l"=>1, "a"=>1, "z"=>1, "y"=>1, "d"=>1, "g"=>1}

Note that to see some of above examples working in the same way you need `.to_a`, `.map(&:to_a)` or even `.to_a.map(&:to_a)` since lazyness is intensively used.

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
  class << self
    def dimensions
      # TODO refactor into depth-first traversing
    def fold_list
      lambda do |f, x, list = nil|
        # TODO use Ruby#inject ?
    def map
      # TODO validate depths
      # TODO break on passing all depths
    def table
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
describe MLL do
  describe "List Manipulation" do
    describe "Constructing Lists" do
      describe "#table" do
        describe "Scope:" do
          # TODO: "Make a triangular array:"
      describe "#range" do
        # TODO take from docs more examples that involve other functions
    describe "Applying Functions to Lists" do
      describe "#fold_list" do
        describe "Applications:" do
          # TODO maybe move it to README.md
      describe "#map" do
        # TODO we'll need less nested mappings when we implement stop on depths depletion
        describe "Details and Options:" do
          example "levels n1 though n2" do
            expect(map[->(i){ [i] }, [1,[2,[3,[4,[5,6]]]]], [2,4]].
              # TODO smth _<>
          # TODO "Level corresponds to the whole expression"
          # TODO currying "Map[f][expr] is equivalent to Map[f,expr]"
        describe "Scope:" do
          # TODO "Map on all levels, starting at level" ant other about Infinity
        describe "Properties & Relations:" do
          # TODO #mapall
          # TODO #mapthread ?
          # TODO #mapindexed ?
          # TODO "negative levels"
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
