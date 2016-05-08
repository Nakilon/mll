# MLL (Mathematica Language Library)

[![Join the chat at https://gitter.im/Nakilon/mll](https://badges.gitter.im/Nakilon/mll.svg)](https://gitter.im/Nakilon/mll?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Gem Version](https://badge.fury.io/rb/mll.svg)](http://badge.fury.io/rb/mll)  
[![Build Status](https://travis-ci.org/Nakilon/mll.svg)](https://travis-ci.org/Nakilon/mll)

### What

This gem isn't supposed to mimic all data types, exact syntax of Wolfram Mathematica or make Ruby able to make the same visualisations.

The main goal is to make Ruby more powerful by including the most used functions, that Ruby lacks, such as `Table[]`, `FoldList[]`, etc. Visualisations are possible later by using additional gems.

### Why

0. `::map` can map Arrays at specified depth!
1. One of the most useful things is automatic zipping vectors (`Array`s) when you apply scalar functions to them. https://reference.wolfram.com/language/ref/Listable.html
2. unlike Ruby's `Range` class, `::range` can handle negative `step` and even have `float` starting value
3. unlike Ruby's `Array.new`, `::table` can create multidimensional arrays with a single call, not nested
4. `::fold_list` was wanted [here](http://stackoverflow.com/q/1475808/322020) in Ruby while being already implemented as [FoldList[]](http://reference.wolfram.com/language/ref/FoldList.html) in Mathematica and [scanl](http://hackage.haskell.org/package/base-4.8.0.0/docs/Prelude.html#v:scanl) in Haskell
5. `::nest` (n times) and `::nest_list` for repetitive applying the same function -- `::nest_while` and `::nest_while_list` are going to be implemented later
6. `::tally` -- shortcut to a probably the most common usage of `#group_by` -- calculating total occurences.
7. TODO write smth about `::riffle`, `::subdivide`, `::grid`

### How

    MLL::range[ 2, 3 ] # => 2..3
    MLL::range[[2, 3]] # => [1..2, 1..3]
    MLL::range[ 1..3 ] # => [1..1, 1..2, 1..3]

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

    # similar to Ruby's #product with #map...
    t = MLL::table[ ->(i,j){ i+j }, [[1, 0, 1]], [[0, 2, 0]] ]
                       # => [[1, 3, 1],
                             [0, 2, 0],
                             [1, 3, 1]]
    # ... but our #map...
    t = MLL::map[ ->(i){ [i] }, t, [2] ]
                       # => [[ [1], [3], [1] ],
                             [ [0], [2], [0] ],
                             [ [1], [3], [1] ]]
    # ... can go deeper
    MLL::map[ ->(i){ -i }, t, [3] ]
                       # => [[ [-1], [-3], [-1] ],
                             [ [ 0], [-2], [ 0] ],
                             [ [-1], [-3], [-1] ]]

    # ::times     means  *
    # ::divide    means  /
    # ::subtract  means  -
    # ::plus      means  +

    # here is another `Listable' magic, allowing to zip arrays
    #   even of different dimensions with basic operations
    MLL::times[ [[1,2],[3,4]], [5,6] ]
                       # => [[5,10], [18,24]]

    # listing factorials # http://stackoverflow.com/a/3590520/322020
    MLL::fold_list[ MLL::times, MLL::range[8] ]
                       # => [1, 2, 6, 24, 120, 720, 5040, 40320]
    
    MLL::fold_list[ ->(a,b){ 10*a + b }, 0, [4,5,1,6,7,8] ]
                       # => [0, 4, 45, 451, 4516, 45167, 451678]

    # http://en.wikipedia.org/wiki/Collatz_conjecture
    MLL::nest_list[ ->(i){ i.even? ? i/2 : (i*3+1)/2 }, 20, 10 ]
                       # => [20, 10, 5, 8, 4, 2, 1, 2, 1, 2, 1]

    # counting characters and nice printing the resulting table
    MLL::grid[ MLL::tally[ "the quick brown fox jumps over the lazy dog".chars ].
                 sort_by(&:last).reverse.take(10),
               frame: :all, spacings: [2, 0] ]
                       # => ┏━━━┳━━━┓
                            ┃   ┃ 8 ┃
                            ┃ o ┃ 4 ┃
                            ┃ e ┃ 3 ┃
                            ┃ u ┃ 2 ┃
                            ┃ h ┃ 2 ┃
                            ┃ r ┃ 2 ┃
                            ┃ t ┃ 2 ┃
                            ┃ n ┃ 1 ┃
                            ┃ p ┃ 1 ┃
                            ┃ m ┃ 1 ┃
                            ┗━━━┻━━━┛
    # current implementation of #grid sucks and needs your help ,.)

    MLL::riffle[ "4345252523535".chars, ",", [-4,1,-4] ]
                       # => "4,345,252,523,535"

    MLL::subdivide[ 5, 10, 4 ]
                       # => [5.0, 6.25, 7.5, 8.75, 10.0]

    MLL::most[ [1, 2, 3, 4] ]  # => [1, 2, 3]
    # now it's possible to extend core classes with some of those methods
    require "mll/core_ext"
    [1, 2, 3, 4].most          # => [1, 2, 3]

Note that to see some of above examples working in the same way you need `.to_a`, `.map(&:to_a)` or even `.to_a.map(&:to_a)` since lazyness is intensively used.

### Installation

    $ gem install mll

### Testing with RSpec before contributing

    rspec

or

    rake spec

or

    rake    # to implicitly run 'rake todo'
