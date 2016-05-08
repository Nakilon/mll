#### lib/mll.rb

```
module MLL
  class << self
    def dimensions
      lambda do |list, limit = nil|
        enumerator = Enumerator.new do |e|
          while list.all?{ |i| i.respond_to? :each } &&
            # TODO refactor into depth-first yielding
    def nest_while
      # TODO finish me
    def fold_list
      lambda do |x, list, f = nil|
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
    def grid
      lambda do |table, **options|
        # TODO negative spacings?
        # TODO smth with this #.all?
        # TODO https://reference.wolfram.com/language/ref/Alignment.html
    def riffle
      lambda do |*args|
        case args.size
          when 3
            Enumerator.new do |e|
              args[0].each_with_index do |x, i|
                # TODO make it not destructive
  # TODO not sure if we need any other kind of Listability except of #range[[Array]]
  # TODO #power[]
```

#### spec/_spec.rb

```
# TODO move Properties & Relations to some separate contexts maybe
# TODO @fraggedICE wishes using Rational -- would also allow implementing more examples
# TODO elegantly get rid of repetitive type checks
# TODO ? let(:fake_lambda){ ->(*args){fail} }
# TODO rewrite all Lazy#to_a into Lazy#force (it's not recursive and not documented)
# TODO maybe make indexes count from 0 not 1
# TODO merge similar examples
# TODO deprecate tests that would obviously fail another tests
# TODO check if we check for ArgumentError without being sure we raise it
describe MLL do
  describe "List Manipulation" do
    describe "Constructing Lists" do
      describe "#table" do
        describe "Scope:" do
          # TODO: "Make a triangular array:"
      describe "#range" do
        # TODO take from docs more examples that involve other functions
    describe "Rearranging & Restructuring Lists" do
      describe "#riffle" do
        describe "Scope:" do
          example "intersperse two lists" do
            # TODO check how it works for list2.size == list1.size + 1 in Mathematica
    describe "Applying Functions to Lists" do
      describe "#fold_list" do
        describe "Applications:" do
          # TODO maybe move it to README.md
      describe "#map" do
        # TODO we'll need less nested mappings when we implement stop on depths depletion
        describe "Details:" do
          example "levels n1 though n2" do
            expect(map[[1,[2,[3,[4,[5,6]]]]], [2,4], ->(i){ [i] }].
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
    describe "Elements of Lists" do
      # TODO #rest
    # TODO http://reference.wolfram.com/language/guide/RearrangingAndRestructuringLists.html
    # TODO http://reference.wolfram.com/language/guide/MathematicalAndCountingOperationsOnLists.html
  describe "Functional Programming" do
    describe "Iteratively Applying Functions" do
      # TODO move #nest_list and #fold_list and others here?
      # TODO examples in README.rb
      describe "#nest_while" do
        # TODO examples to README.md
        describe "Details:" do
          # TODO a lot
        describe "Scope:" do
          # TODO "always compare all values generated" do
          # TODO "compare the last two values generated" do
          # TODO "start comparisons after 4 iterations, and compare using the 4 last values" do
          # TODO "start comparisons after 4 iterations, and compare using the 6 last values" do
          # TODO example "stop after at most 4 iterations, even if the test is still true" do
        describe "Generalizations & Extensions:" do
          # TODO "return the last value for which the condition was still true" do
        describe "Applications:" do
          # TODO example "find the next twin prime after 888" do
        describe "Properties & Relations:" do
          # TODO "#nest_while can be expressed in terms of a while loop" do
  describe "Numerical Data" do
    describe "#mean" do
      # TODO examples to README.md
  describe "Grids & Tables" do
    describe "#grid" do
      describe "Details:" do
        # TODO SpanFromLeft SpanFromAbove SpanFromBoth
        # TODO The following options can be given
        # TODO Common settings for Frame
        # TODO The spec(k) can have the following forms
        # TODO With ItemSize->Automatic will break elements across multiple lines
        # TODO "settings can be used for BaselinePosition" do
      describe "Scope:" do
        # TODO Draw all the frames in red
        # TODO Put a frame around the first row and column
        # TODO Draw different frames with different styles
        # TODO Put dividers at all horizontal positions
        # TODO Put dividers at all vertical positions
        # TODO Put dividers at the third horizontal and second vertical positions
        # TODO Make the element 4 span the column to its right
        # TODO Make it span three rows
        # TODO Span throughout a 2×2 block
        # TODO Draw the grid with a pink background
        # TODO Alternating pink and yellow at successive horizontal positions
        # TODO Alternating pink and yellow at successive vertical positions
        # TODO Make the grid contents red
        # TODO "grids can be nested" do
      describe "Options:" do
        # TODO "align elements around the center of the grid" do
        # TODO "align numbers on the decimal point" do
        # TODO draw the grid with a pink background
        # TODO Pink and gray backgrounds for the first and second columns
        # TODO An equivalent syntax
        # TODO Pink and gray backgrounds for the first and second rows
        # TODO Alternating pink and gray backgrounds
        # TODO Alternating backgrounds with yellow superimposed in the first and last positions
        # TODO Set the background for specific items
        # TODO Set the background for a subregion of the grid
        # TODO Draw all interior dividers
        # TODO Draw a divider at every other horizontal position
        # TODO Include the final position
        # TODO Draw dividers with specified styles
        # TODO "frame specific elements" do
        # TODO "frame a region" do
        # TODO "make each item a fixed number of character-widths wide" do
        # TODO "ItemSize->All makes all items the same size" do
        # TODO "prevent line-wrapping" do
        # TODO "set one overall style for grid items" do
        # TODO "style specific elements" do
        # TODO "style a region" do
        # TODO "insert no additional space between rows or columns" do
        # TODO "specify spacing with numeric values" do
        # TODO "use different spacings at the first vertical divider" do
      describe "Properties & Relations:" do
        # TODO "the elements of a Grid can be extracted with #[]" do
      describe "Neat examples:" do
        # TODO "a Sudoku grid" do
# TODO http://reference.wolfram.com/language/guide/HandlingArraysOfData.html
# TODO http://reference.wolfram.com/language/guide/ComputationWithStructuredDatasets.html
```

