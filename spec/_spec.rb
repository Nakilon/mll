require_relative File.join "..", "lib", "mll"


# PERMATODO test all implemented exceptions
# PERMATODO test all types returned (not actually all but about lazyness)
# PERMATODO check for "Details" paragraphs to make more trivial examples
# PERMATODO leave here only useful tests, not demostrations -- move them to README.rb
# PERMATODO single element Arrays tests
# PERMATODO move Properties & Relations to some separate contexts maybe

# TODO test all implemented exceptions
# TODO test all types returned (not actually all but about lazyness)
# TODO check for "Details" paragraphs to make more trivial examples
# TODO leave here only useful tests, not demostrations -- move them to README.rb
# TODO single element Arrays tests
# TODO move Properties & Relations to some separate contexts maybe

# TODO @fraggedICE wishes using Rational -- would also allow implementing more examples
# TODO rename examples according to their description not content
# TODO elegantly get rid of repetitive type checks
# TODO implement #power for use in unittests
# TODO let(:fake_lambda){ ->(*args){fail} } ?
# TODO include MLL


# http://reference.wolfram.com/language/guide/LanguageOverview.html
describe MLL do

  # http://reference.wolfram.com/language/guide/Syntax.html
  describe "Syntax" do

    # NO URL
    describe "Mathematics & Operators" do

      # http://reference.wolfram.com/language/ref/Subtract.html
      describe "#subtract" do

        describe "Basic Examples" do

          example "subtract(n1, n2)" do
            expect(MLL::subtract(10,3)).to eq 7
          end

        end

        describe "Scope" do

          example "subtract(list, n)" do
            expect(MLL::subtract([1,2,3,4],0.5)).to be_a Enumerator
            expect(MLL::subtract([1,2,3,4],0.5).to_a).to eq [0.5,1.5,2.5,3.5]
          end

        end

      end

      # http://reference.wolfram.com/language/ref/Divide.html
      describe "#divide" do

        describe "Basic Examples" do

          example "divide(n1, n2)" do
            # expect(MLL::divide(77,11)).to be_a Fixnum
            expect(MLL::divide(77,11)).to eq 7
          end

        end

        describe "Scope" do

          example "divide(list, n)" do
            expect(MLL::divide([2,3,4,5],2.0)).to be_a Enumerator
            expect(MLL::divide([2,3,4,5],2.0).to_a).to eq [1,1.5,2,2.5]
          end
          example "divide(list, list)" do
            expect(MLL::divide([2,3,4],[2,1,4])).to be_a Enumerator
            expect(MLL::divide([2,3,4],[2,1,4]).to_a).to eq [1,3,1]
          end

        end

        describe "Applications" do

          # TODO: "Successive ratios in a list:"

        end

        describe "Neat Examples" do

          example "nest_list(lambda_with_divide), n" do
            pending "#nestlist is yet to be implemented"
            fail
          end
          example "table(function, n1, n2)" do
            expect(MLL::table(MLL.method(:divide), [[3,6]], 4.0)).to be_a Array
            expect(MLL::table(MLL.method(:divide), [[6]], 4.0)).to eq [[6.0,3.0,2.0,1.5]]
          end

        end

      end

      # TODO common tests for threading functions like times, plus, etc.

      # http://reference.wolfram.com/language/ref/Plus.html
      describe "#plus" do

        describe "Basic Examples" do

          example "plus(n1, n2, n3)" do
            expect(MLL::plus(2,3,4)).to eq 9
          end
          example "plus([n1, n2, n3], n)" do
            expect(MLL::plus([3,4,5],2)).to be_a Enumerator
            expect(MLL::plus([3,4,5],2).to_a).to eq [5,6,7]
          end
          example "plus(n1, n2, [n3, n4])" do
            expect(MLL::plus(2,3,[4,5])).to be_a Enumerator
            expect(MLL::plus(2,3,[4,5]).to_a).to eq [9,10]
          end
          example "plus(list, list)" do
            expect(MLL::plus([10,20,30],[1,2,3])).to be_a Enumerator
            expect(MLL::plus([10,20,30],[1,2,3]).to_a).to eq [11,22,33]
          end
          example "plus(list_of_lists, n)" do
            expect(MLL::plus([[1,2],[3,4]],5)).to be_a Enumerator
            expect(MLL::plus([[1,2],[3,4]],5).to_a.map(&:to_a)).to eq [[6,7],[8,9]]
          end
          example "plus(list_of_lists, list_of_lists)" do
            expect(MLL::plus([[1,2],[3,4]],[[5,6],[7,8]])).to be_a Enumerator
            expect(MLL::plus([[1,2],[3,4]],[[5,6],[7,8]]).to_a.map(&:to_a)).to eq [[6,8],[10,12]]
          end
          example "plus([[n1, n2], [n3, n4]], [n5, n6])" do
            expect(MLL::plus([[1,2],[3,4]],[5,6])).to be_a Enumerator
            expect(MLL::plus([[1,2],[3,4]],[5,6]).to_a.map(&:to_a)).to eq [[6,7],[9,10]]
          end

        end

        # TODO "Accumulate makes a cumulative sum:"

      end

      # http://reference.wolfram.com/language/ref/Times.html
      describe "#times" do

        describe "Basic Examples" do

          example "times(n1, n2, n3)" do
            # expect(MLL::times(2,3,4)).to be_a Fixnum
            expect(MLL::times(2,3,4)).to eq 24
          end
          example "times(n, [n1, n2, n3])" do
            expect(MLL::times(2,[3,4,5])).to be_a Enumerator
            expect(MLL::times(2,[3,4,5]).to_a).to eq [6,8,10]
          end
          example "times(n1, n2, [n3, n4])" do
            expect(MLL::times(2,3,[4,5])).to be_a Enumerator
            expect(MLL::times(2,3,[4,5]).to_a).to eq [24,30]
          end
          example "times([[n1, n2], [n3, n4]], [n5, n6])" do
            expect(MLL::times([[1,2],[3,4]],[5,6])).to be_a Enumerator
            expect(MLL::times([[1,2],[3,4]],[5,6]).to_a.map(&:to_a)).to eq [[5,10],[18,24]]
          end

        end

      end

    end

  end

  # http://reference.wolfram.com/language/guide/ListManipulation.html
  describe "List Manipulation" do

    # http://reference.wolfram.com/language/guide/ConstructingLists.html
    describe "Constructing Lists" do

      # http://reference.wolfram.com/language/ref/Table.html
      describe "#table" do

        describe "Basic Examples" do

          example "table(lambda, n)" do
            expect(MLL::table(->(i){ i**2 }, 10)).to be_a Array
            expect(MLL::table(->(i){ i**2 }, 10)).to eq [1,4,9,16,25,36,49,64,81,100]
          end
          example "table(lambda, [min, max, step])" do
            expect(MLL::table(->(i){ i+2 }, [0, 20, 2])).to be_a Array
            expect(MLL::table(->(i){ i+2 }, [0, 20, 2])).to eq [2,4,6,8,10,12,14,16,18,20,22]
          end
          example "table(lambda, n1, n2)" do
            # TODO example to README.rb about multiplication table
            expect(MLL::table(->(i,j){ 10*i + j }, 4, 3)).to be_a Array
            expect(MLL::table(->(i,j){ 10*i + j }, 4, 3)).to eq [[11,12,13],[21,22,23],[31,32,33],[41,42,43]]
          end
          example "table(lambda, n1, min..max, [max, min, -step])" do
            expect(MLL::table(->(i,j,k){ [i,j,k] }, 3, 2..3, [5, 1, -2])).to be_a Array
            expect(MLL::table(->(i,j,k){ [i,j,k] }, 3, 2..3, [5, 1, -2])).to eq \
            [
             [[[1, 2, 5], [1, 2, 3], [1, 2, 1]], [[1, 3, 5], [1, 3, 3], [1, 3, 1]]],
             [[[2, 2, 5], [2, 2, 3], [2, 2, 1]], [[2, 3, 5], [2, 3, 3], [2, 3, 1]]],
             [[[3, 2, 5], [3, 2, 3], [3, 2, 1]], [[3, 3, 5], [3, 3, 3], [3, 3, 1]]]
            ]
          end

          example "matrix_form table(lambda, n1, n2)" do
            pending "#matrix_form is yet to be implemented"
            expect(MLL::matrix_form MLL::table(->(i,j){ 10*i + j }, 4, 3)).to eq "
            "
          end

        end

        describe "Scope" do

          # TODO: "Make a triangular array:"

          example "table(lambda, [list1], [list2])" do
            expect(MLL::table(->(base, power){ base ** power }, [[1,2,4]], [[1,3,4]])).to be_a Array
            expect(MLL::table(->(base, power){ base ** power }, [[1,2,4]], [[1,3,4]])).to eq [[1,1,1],[2,8,16],[4,64,256]]
            expect(MLL::table(MLL::method(:plus), [[1]], [[2]])).to be_a Array
            expect(MLL::table(MLL::method(:plus), [[1]], [[2]])).to eq [[3]]
          end

        end

        describe "Applications" do

          example "column table(binomial, )" do
            pending "#binomial and #column are yet to be implemented"
            fail
          end

        end

      end

      # http://reference.wolfram.com/language/ref/Range.html
      describe "#range" do

        # TODO take from docs more examples that involve other functions

        example "range( >3 args )" do
          expect{ MLL::range(1,2,3,4) }.to raise_error ArgumentError
        end

        describe "Basic Examples" do

          example "range(n)" do
            expect(MLL::range(4)).to be_a Enumerator
            expect(MLL::range(4).to_a).to eq [1,2,3,4]
          end
          example "range(min, max)" do
            expect(MLL::range(2,5)).to be_a Enumerator
            expect(MLL::range(2,5).to_a).to eq [2,3,4,5]
          end
          example "range(min, max, step)" do
            expect(MLL::range(1,2,3)).to be_a Enumerator
            expect(MLL::range(1,2,0.5).to_a).to eq [1,1.5,2] # can be precision problems
            expect(MLL::range(2,6,2).to_a).to eq [2,4,6]
            expect(MLL::range(-4,9,3).to_a).to eq [-4,-1,2,5,8]
          end
          example "range(max, min, -step)" do
            expect(MLL::range(10,-5,-2).to_a).to eq [10,8,6,4,2,0,-2,-4]
            expect(MLL::range(3,1,-1).to_a).to eq [3,2,1]
          end

        end

        describe "Generalizations & Extensions" do

          example "range([n1, n2, n3, n4])" do
            expect(MLL::range([5,2,6,3])).to be_a Enumerator
            MLL::range([5,2,6,3]).each do |i|
              expect(i).to be_a Enumerator
            end
            expect(MLL::range([5,2,6,3]).to_a.map(&:to_a)).to eq [[1,2,3,4,5],[1,2],[1,2,3,4,5,6],[1,2,3]]
          end

        end

        describe "Applications" do

          example "power(n1, range(n2))" do
            pending "#power is yet to be implemented"
            expect(power(2, range(5))).to eq [2,4,8,16,32]
          end

        end

        describe "Neat Examples" do

          example "range(min..max)" do
            expect(MLL::range(1..3)).to be_a Enumerator
            MLL::range(1..3).each do |i|
              expect(i).to be_a Enumerator
            end
            expect(MLL::range(1..3).to_a.map(&:to_a)).to eq [[1],[1,2],[1,2,3]]
          end
          example "range(range(range(n)))" do
            # TODO do the same .tap thing in other type tests
            MLL::range(MLL::range(MLL::range(3))).tap do |o|
              expect(o).to be_a Enumerator
              o.each do |i|
                expect(i).to be_a Enumerator
                i.each do |j|
                  expect(j).to be_a Enumerator
                end
              end
            end
            expect(MLL::range(MLL::range(MLL::range(3))).to_a.map{ |i| i.to_a.map(&:to_a) }).to eq [[[1]],[[1],[1,2]],[[1],[1,2],[1,2,3]]]
          end

          # TODO Nest[Range,3,6]

        end

        # TODO "Find an inverse permutation:"
        # TODO "Use Range or Span (;;) as Part specification:"

      end

      # http://reference.wolfram.com/language/ref/Subdivide.html
      describe "#subdivide" do

        example "subdivide(n)" do
          expect(MLL::subdivide(4)).to be_a Enumerator
          expect(MLL::subdivide(4).to_a).to eq [0,0.25,0.5,0.75,1]
        end
        example "subdivide(max, n)" do
          expect(MLL::subdivide(10,5)).to be_a Enumerator
          expect(MLL::subdivide(10,5).to_a).to eq [0,2,4,6,8,10]
        end
        example "subdivide(min, max, n)" do
          expect(MLL::subdivide(-1,1,8)).to be_a Enumerator
          expect(MLL::subdivide(-1,1,8).to_a).to eq [-1,-0.75,-0.5,-0.25,0,0.25,0.5,0.75,1]
        end
        example "subdivide(max, min, n)" do
          expect(MLL::subdivide(1,-1,8)).to be_a Enumerator
          expect(MLL::subdivide(1,-1,8).to_a).to eq [1,0.75,0.5,0.25,0,-0.25,-0.5,-0.75,-1]
        end

      end

      # http://reference.wolfram.com/language/ref/NestList.html
      describe "#nest_list" do

        example "#nest_list  gives a list of length n+1" do
          expect(MLL::nest_list(->{}, 0, 5)).to be_a Enumerator
          expect(MLL::nest_list(->(*args){}, 0, 5).to_a.size).to eq 6
        end

        describe "Basic Examples" do

          example "'nest_list with #cos starting with 1.0)'" do
            pending "#cos is yet to be implemented"
            fail
          end

        end

        describe "Scope" do

          example "nesting can return a single number" do
            pending "#sqrt is yet to be implemented"
            fail
          end

        end

        describe "Applications" do

          example "powers of 2" do
            expect(MLL::nest_list(->(i){ 2*i }, 1, 10)).to be_a Enumerator
            expect(MLL::nest_list(->(i){ 2*i }, 1, 10).to_a).to eq [1,2,4,8,16,32,64,128,256,512,1024]
          end
          example "iterates in the  problem" do
            expect(MLL::nest_list(->(i){ i.even? ? i/2 : (i*3+1)/2 }, 100, 20)).to be_a Enumerator
            expect(MLL::nest_list(->(i){ i.even? ? i/2 : (i*3+1)/2 }, 100, 20).to_a).to eq [100,50,25,38,19,29,44,22,11,17,26,13,20,10,5,8,4,2,1,2,1]
          end
          example "linear congruential pseudorandom generator" do
            expect(MLL::nest_list(->(i){ (i*59)%101 }, 1, 15)).to be_a Enumerator
            expect(MLL::nest_list(->(i){ (i*59)%101 }, 1, 15).to_a).to eq [1,59,47,46,88,41,96,8,68,73,65,98,25,61,64,39]
          end
          example "random walk" do
            expect(( r = Random.new(0); MLL::nest_list(->(i){ i+[-1,1][r.rand(2)] }, 0, 20) )).to be_a Enumerator
            expect(( r = Random.new(0); MLL::nest_list(->(i){ i+[-1,1][r.rand(2)] }, 0, 20).to_a )).to eq [0,-1,0,1,0,1,2,3,4,5,6,7,6,5,6,5,4,3,2,1,2]
          end
          example "successively rotate a list" do
            expect(MLL::nest_list(->(i){ i.rotate 1 }, [1,2,3,4], 4)).to be_a Enumerator
            expect(MLL::nest_list(->(i){ i.rotate 1 }, [1,2,3,4], 4).to_a).to eq [[1,2,3,4],[2,3,4,1],[3,4,1,2],[4,1,2,3],[1,2,3,4]]
          end

        end

        describe "Properties & Relations" do

          # TODO "Nest gives the last element of NestList:"

          example "nesting zero times simply returns to the original argument" do
            expect(MLL::nest_list(->{fail}, 5, 0)).to be_a Enumerator
            expect(MLL::nest_list(->(*args){fail}, 5, 0).to_a).to eq [5]
          end
          example "#fold_list automatically inserts second arguments from a list" do
            expect(MLL::nest_list(->(i  ){ i*2 }, 3,     4).to_a).to eq \
                   MLL::fold_list(->(i,j){ i*j }, 3, [2]*4).to_a
          end

        end

      end

    end

    # http://reference.wolfram.com/language/guide/ApplyingFunctionsToLists.html
    describe "Applying Functions to Lists" do

      describe "#fold_list" do

        describe "Basic Examples" do

          example "fold_list(function, list)" do
            expect(MLL::fold_list(MLL.method(:plus),[1,2,3,4])).to be_a Enumerator
            expect(MLL::fold_list(MLL.method(:plus),[1,2,3,4]).to_a).to eq [1,3,6,10]
          end
          example "fold_list(function, n, list)" do
            expect(MLL::fold_list(MLL.method(:plus),5,[1,2,3,4])).to be_a Enumerator
            expect(MLL::fold_list(MLL.method(:plus),5,[1,2,3,4]).to_a).to eq [5,6,8,11,15]
          end
          example "fold_list(lambda, n, list)" do
            expect(MLL::fold_list(->(base, power){ base ** power },2,[3,2,1])).to be_a Enumerator
            expect(MLL::fold_list(->(base, power){ base ** power },2,[3,2,1]).to_a).to eq [2,8,64,64]
          end

        end

        describe "Applications" do

          example "fold_list(function, n, list)" do
            expect(MLL::fold_list(MLL.method(:times), [*1..10])).to be_a Enumerator
            expect(MLL::fold_list(MLL.method(:times), [*1..10]).to_a).to eq [1,2,6,24,120,720,5040,40320,362880,3628800]
          end
          example "fold_list(lambda, n, list)" do
            expect(MLL::fold_list(->(a,b){ 10*a + b }, 0, [4,5,1,6,7,8])).to be_a Enumerator
            expect(MLL::fold_list(->(a,b){ 10*a + b }, 0, [4,5,1,6,7,8]).to_a).to eq [0,4,45,451,4516,45167,451678]
          end
          example "fold_list(lambda, n, list)" do
            expect(( r = Random.new(0); MLL::fold_list(MLL.method(:plus), 0, Array.new(20){ [-1,1][r.rand(2)] }) )).to be_a Enumerator
            expect(( r = Random.new(0); MLL::fold_list(MLL.method(:plus), 0, Array.new(20){ [-1,1][r.rand(2)] }).to_a )).to eq [0,-1,0,1,0,1,2,3,4,5,6,7,6,5,6,5,4,3,2,1,2]
          end

          # TODO "Find successively deeper parts in an expression:"

        end

        describe "Properties & Relations" do

          example "#fold_list makes a list of length n+1" do
            expect(MLL::fold_list(->{}, 0, [*1..10])).to be_a Enumerator
            expect(MLL::fold_list(->(*args){}, 0, [*1..10]).to_a.size).to eq 11
          end
          example "folding with an empty list does not apply the function at all" do
            expect(MLL::fold_list(->{}, 0, [])).to be_a Enumerator
            expect(MLL::fold_list(->(*args){}, 0, []).to_a).to eq [0]
          end
          example "Ruby#inject gives the last element of #fold_list" do
            f = ->(i,j){ i+j }
            expect(MLL::fold_list(f, [1,2,3])).to be_a Enumerator
            expect(MLL::fold_list(f, [1,2,3]).to_a.last).to eq [1,2,3].inject(&f)
          end
          # TODO "Functions that ignore their second argument give the same result as in NestList:"
          # TODO "Accumulate is equivalent to FoldList with Plus:"

        end

        describe "Neat Examples" do

          example "compute the minimum number of coins of different value needed to make up an amount" do
            pending "at least #mod is yet to be implemented"
            fail
          end

        end

      end

    end

    # TODO http://reference.wolfram.com/language/guide/ElementsOfLists.html
    # TODO http://reference.wolfram.com/language/guide/RearrangingAndRestructuringLists.html
    # TODO http://reference.wolfram.com/language/guide/MathematicalAndCountingOperationsOnLists.html

  end

  # http://reference.wolfram.com/language/guide/FunctionalProgramming.html
  describe "Functional Programming" do

    # http://reference.wolfram.com/language/guide/FunctionalIteration.html
    describe "Iteratively Applying Functions" do

      # TODO move #nest_list and #fold_list and others here?

      describe "#nest" do

        describe "Basic Examples" do

          example "the function to nest can be a pure function" do
            expect(MLL::nest(->(i){ (1+i)**2 }, 1, 3)).to eq 676
          end

        end

        describe "Scope" do

          example "nesting can return a single number" do
            pending "#sqrt is yet to be implemented"
            fail
          end

        end

        describe "Applications" do

          example "newton iterations for" do
            pending "need to deal with Rationals first"
            fail
          end
          example "consecutive pairs of Fibonacci numbers" do
            pending "implement #dot ?"
            fail
          end

        end

        describe "Properties & Relations" do

          example "#fold automatically inserts second arguments from a list" do
            expect(MLL::nest(->(i){       i*2 }, 3, 4)).to eq \
                 ([2]*4).inject(3){ |i,j| i*j }
          end

        end

        # TODO neat graphic examples

      end

    end

  end

end

# TODO http://reference.wolfram.com/language/guide/HandlingArraysOfData.html
# TODO http://reference.wolfram.com/language/guide/ComputationWithStructuredDatasets.html

__END__

Table   Array
Times   Product
Plus    Total   Sum?
