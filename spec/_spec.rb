require_relative File.join "..", "lib", "mll"


# PERMATODO test all implemented exceptions
# PERMATODO test all types returned (not actually all but about lazyness)
# PERMATODO check for "Details" paragraphs to make more trivial examples
# PERMATODO leave here only useful tests, not demostrations -- move them to README.rb
# PERMATODO polymorphic functions should have ArgumentError-s and tests about that
# PERMATODO move Properties & Relations to some separate contexts maybe

# TODO move Properties & Relations to some separate contexts maybe

# TODO @fraggedICE wishes using Rational -- would also allow implementing more examples
# TODO elegantly get rid of repetitive type checks
# TODO ? let(:fake_lambda){ ->(*args){fail} }


# http://reference.wolfram.com/language/guide/LanguageOverview.html
describe MLL do

  def method_missing *args
    described_class.send *args
  end

  # http://reference.wolfram.com/language/guide/Syntax.html
  describe "Syntax" do

    # NO URL
    describe "Mathematics & Operators" do

      # http://reference.wolfram.com/language/ref/Subtract.html
      describe "#subtract" do

        example "less than 2 args raise ArgumentError" do
          expect{ subtract[0    ] }.to raise_error ArgumentError
        end
        example "more than 2 args raise ArgumentError" do
          expect{ subtract[0,0,0] }.to raise_error ArgumentError
        end

        describe "Basic Examples" do

          example "subtract numbers" do
            expect(subtract[10,3]).to eq 7
          end

        end

        describe "Scope" do

          example "threads element‐wise over lists" do
            expect(subtract[[1,2,3,4],0.5]).to be_a Enumerator
            expect(subtract[[1,2,3,4],0.5].to_a).to eq [0.5,1.5,2.5,3.5]
            expect(subtract[6,[3,2]]).to be_a Enumerator
            expect(subtract[6,[3,2]].to_a).to eq [3,4]
            expect(subtract[[[1,2],[3,4]],1]).to be_a Enumerator
            expect(subtract[[[1,2],[3,4]],1].to_a.map(&:to_a)).to eq [[0,1],[2,3]]
            expect(subtract[[3,4],[2,1]]).to be_a Enumerator
            expect(subtract[[3,4],[2,1]].to_a).to eq [1,3]
            expect(subtract[[[1,3],[2,4]],[1,2]]).to be_a Enumerator
            expect(subtract[[[1,3],[2,4]],[1,2]].to_a.map(&:to_a)).to eq [[0,2],[0,2]]
          end
          example "matrices subtract element-wise" do
            expect(subtract[[[5,6],[7,8]],[[4,3],[2,1]]]).to be_a Enumerator
            expect(subtract[[[5,6],[7,8]],[[4,3],[2,1]]].to_a.map(&:to_a)).to eq [[1,3],[5,7]]
          end

        end

      end

      # http://reference.wolfram.com/language/ref/Divide.html
      describe "#divide" do

        example "less than 2 args raise ArgumentError" do
          expect{ divide[0    ] }.to raise_error ArgumentError
        end
        example "more than 2 args raise ArgumentError" do
          expect{ divide[0,0,0] }.to raise_error ArgumentError
        end

        describe "Basic Examples" do

          example "divide numbers" do
            expect(divide[77,11]).to eq 7
          end

        end

        describe "Scope" do

          example "threads element‐wise over lists" do
            expect(divide[[2,3,4,5],2.0]).to be_a Enumerator
            expect(divide[[2,3,4,5],2.0].to_a).to eq [1,1.5,2,2.5]
            expect(divide[6,[3,2]]).to be_a Enumerator
            expect(divide[6,[3,2]].to_a).to eq [2,3]
            expect(divide[[[4,2],[6,8]],2]).to be_a Enumerator
            expect(divide[[[4,2],[6,8]],2].to_a.map(&:to_a)).to eq [[2,1],[3,4]]
            expect(divide[[2,3,4],[2,1,4]]).to be_a Enumerator
            expect(divide[[2,3,4],[2,1,4]].to_a).to eq [1,3,1]
            expect(divide[[[1,3],[2,4]],[1,2]]).to be_a Enumerator
            expect(divide[[[1,3],[2,4]],[1,2]].to_a.map(&:to_a)).to eq [[1,3],[1,2]]
          end
          example "matrices divide element-wise" do
            expect(divide[[[5,8],[9,8]],[[1,2],[3,4]]]).to be_a Enumerator
            expect(divide[[[5,8],[9,8]],[[1,2],[3,4]]].to_a.map(&:to_a)).to eq [[5,4],[3,2]]
          end

        end

        describe "Applications" do

          example "successive ratios in a list" do
            skip "waiting for Rationals to be used"
          end

        end

      end

      # http://reference.wolfram.com/language/ref/Plus.html
      describe "#plus" do

        describe "Details" do

          example "#plus[] is taken to be 0" do
            expect(plus[]).to eq 0
          end
          example "#plus[x] is x" do
            expect(plus[5]).to eq 5
          end

        end

        describe "Basic Examples" do

          example "sums numbers" do
            expect(plus[2,3,4]).to eq 9
          end
          example "threads element‐wise over lists" do
            # idk why not in Scope
            expect(plus[[3,4,5],2]).to be_a Enumerator
            expect(plus[[3,4,5],2].to_a).to eq [5,6,7]
            expect(plus[2,3,[4,5]]).to be_a Enumerator
            expect(plus[2,3,[4,5]].to_a).to eq [9,10]
            expect(plus[[[1,2],[3,4]],[5,6]]).to be_a Enumerator
            expect(plus[[[1,2],[3,4]],[5,6]].to_a.map(&:to_a)).to eq [[6,7],[9,10]]
          end

        end

        describe "Scope" do

          example "threads element‐wise over lists" do
            expect(plus[[10,20,30],[1,2,3]]).to be_a Enumerator
            expect(plus[[10,20,30],[1,2,3]].to_a).to eq [11,22,33]
            expect(plus[[[1,2],[3,4]],5]).to be_a Enumerator
            expect(plus[[[1,2],[3,4]],5].to_a.map(&:to_a)).to eq [[6,7],[8,9]]
          end
          example "matrices add element-wise" do
            expect(plus[[[1,2],[3,4]],[[5,6],[7,8]]]).to be_a Enumerator
            expect(plus[[[1,2],[3,4]],[[5,6],[7,8]]].to_a.map(&:to_a)).to eq [[6,8],[10,12]]
          end

        end

        describe "Possible Issues" do

          # idk why not in 'Properties & Relations'
          example "accumulate makes a cumulative sum" do
            expect(fold_list[plus, 0, [1,2,3]]).to be_a Enumerator
            expect(fold_list[plus, 0, [1,2,3]].to_a).to eq [0,1,3,6]
          end
          
        end

      end

      # http://reference.wolfram.com/language/ref/Times.html
      describe "#times" do

        describe "Details" do

          example "#times[] is taken to be 1" do
            expect(times[]).to eq 1
          end
          example "#times[x] is x" do
            expect(times[5]).to eq 5
          end

        end

        describe "Basic Examples" do

          example "multiplies numbers" do
            expect(times[2,3,4]).to eq 24
          end
          example "threads element‐wise over lists" do
            expect(times[[3,4,5],2]).to be_a Enumerator
            expect(times[[3,4,5],2].to_a).to eq [6,8,10]
            expect(times[2,3,[4,5]]).to be_a Enumerator
            expect(times[2,3,[4,5]].to_a).to eq [24,30]
            expect(times[[[1,2],[3,4]],[5,6]]).to be_a Enumerator
            expect(times[[[1,2],[3,4]],[5,6]].to_a.map(&:to_a)).to eq [[5,10],[18,24]]
          end

        end

        describe "Scope" do

          example "threads element‐wise over lists" do
            expect(times[[2,3],[4,5]]).to be_a Enumerator
            expect(times[[2,3],[4,5]].to_a).to eq [8,15]
            expect(times[[[1,2],[3,4]],5]).to be_a Enumerator
            expect(times[[[1,2],[3,4]],5].to_a.map(&:to_a)).to eq [[5,10],[15,20]]
          end
          example "matrices multiply element-wise" do
            expect(times[[[4,3],[2,1]],[[5,6],[7,8]]]).to be_a Enumerator
            expect(times[[[4,3],[2,1]],[[5,6],[7,8]]].to_a.map(&:to_a)).to eq [[20,18],[14,8]]
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

        describe "Details" do

          example "#table[expr,spec1,spec2] is effectively equivalent to #table[#table[expr,spec2],spec1]" do
            expect(table[->(i,j){ [i,j] }, 2, 3]).to eq table[->(i){ table[->(j){ [i,j] }, 3] }, 2]
          end

        end

        describe "Basic Examples" do

          example "a table of the first 10 squares" do
            expect(table[->(i){ i**2 }, 10]).to be_a Array
            expect(table[->(i){ i**2 }, 10]).to eq [1,4,9,16,25,36,49,64,81,100]
          end
          example "a table with running from 0 to 20 in steps of 2" do
            expect(table[->(i){ i+2 }, [0, 20, 2]]).to be_a Array
            expect(table[->(i){ i+2 }, [0, 20, 2]]).to eq [2,4,6,8,10,12,14,16,18,20,22]
          end
          example "make a 4×3 matrix" do
            expect(table[->(i,j){ 10*i + j }, 4, 3]).to be_a Array
            expect(table[->(i,j){ 10*i + j }, 4, 3]).to eq [[11,12,13],[21,22,23],[31,32,33],[41,42,43]]
          end

        end

        example "table(lambda, n1, min..max, [max, min, -step])" do
          expect(table[->(i,j,k){ [i,j,k] }, 3, 2..3, [5, 1, -2]]).to be_a Array
          expect(table[->(i,j,k){ [i,j,k] }, 3, 2..3, [5, 1, -2]]).to eq \
          [
           [[[1, 2, 5], [1, 2, 3], [1, 2, 1]], [[1, 3, 5], [1, 3, 3], [1, 3, 1]]],
           [[[2, 2, 5], [2, 2, 3], [2, 2, 1]], [[2, 3, 5], [2, 3, 3], [2, 3, 1]]],
           [[[3, 2, 5], [3, 2, 3], [3, 2, 1]], [[3, 3, 5], [3, 3, 3], [3, 3, 1]]]
          ]
        end

        describe "Scope" do

          # TODO: "Make a triangular array:"

          example "make an array from existing lists" do
            expect(table[->(base, power){ base ** power }, [[1,2,4]], [[1,3,4]]]).to be_a Array
            expect(table[->(base, power){ base ** power }, [[1,2,4]], [[1,3,4]]]).to eq [[1,1,1],[2,8,16],[4,64,256]]
            expect(table[plus, [[1]], [[2]]]).to be_a Array
            expect(table[plus, [[1]], [[2]]]).to eq [[3]]
          end

        end

        describe "Applications" do

          example "column table(binomial, )" do
            skip "#binomial and #column are yet to be implemented"
          end

        end

      end

      # http://reference.wolfram.com/language/ref/Range.html
      describe "#range" do

        # TODO take from docs more examples that involve other functions

        example "no args raise ArgumentError" do
          expect{ range[] }.to raise_error ArgumentError
        end
        example "more than 3 args raise ArgumentError" do
          expect{ range[1,2,3,4] }.to raise_error ArgumentError
        end
        example "step equal to 0 raise ArgumentError" do
          expect{ range[1,2,0] }.to raise_error ArgumentError
        end

        describe "Details" do

          example "the arguments need not be integers" do
            expect(range[0.25,2.9,1.25]).to be_a Enumerator
            expect(range[0.25,2.9,1.25].to_a).to eq [0.25,1.5,2.75]
          end

        end

        describe "Basic Examples" do

          example "range(n)" do
            expect(range[4]).to be_a Enumerator
            expect(range[4].to_a).to eq [1,2,3,4]
          end
          example "range(n1, n2)" do
            expect(range[2,5]).to be_a Enumerator
            expect(range[2,5].to_a).to eq [2,3,4,5]
          end
          example "range(min, max, step)" do
            expect(range[1,2,0.5]).to be_a Enumerator
            expect(range[1,2,0.5].to_a).to eq [1,1.5,2] # can be precision problems
            expect(range[2,6,2].to_a).to eq [2,4,6]
            expect(range[-4,9,3].to_a).to eq [-4,-1,2,5,8]
          end

        end

        # NOTE: Wolfram Mathematica can't do this
        example "range(max, min, -step)" do
          expect(range[10,-5,-2]).to be_a Enumerator
          expect(range[10,-5,-2].to_a).to eq [10,8,6,4,2,0,-2,-4]
          expect(range[3,1,-1].to_a).to eq [3,2,1]
        end

        describe "Generalizations & Extensions" do

          example "use a list of range specifications" do
            expect(range[[5,2,6,3]]).to be_a Enumerator
            range[[5,2,6,3]].each do |i|
              expect(i).to be_a Enumerator
            end
            expect(range[[5,2,6,3]].to_a.map(&:to_a)).to eq [[1,2,3,4,5],[1,2],[1,2,3,4,5,6],[1,2,3]]
          end

        end

        describe "Applications" do

          example "produce a geometric sequence" do
            skip "#power is yet to be implemented"
            expect(power[2, range[5]]).to be_a Enumerator
            expect(power[2, range[5]].to_a).to eq [2,4,8,16,32]
          end

        end

        describe "Properties & Relations" do

          example "#range[imin,imax,di] is equivalent to #table[i,[imin,imax,di]]" do
            expect(range[2,8,3].to_a).to eq table[->(i){ i }, [2,8,3]]
          end

          example "use #range or #span (;;) as #part specification" do
            skip "#span and #part are yet to be implemented"
          end

        end

        example "range(min..max)" do
          expect(range[1..3]).to be_a Enumerator
          range[1..3].each do |i|
            expect(i).to be_a Enumerator
          end
          expect(range[1..3].to_a.map(&:to_a)).to eq [[1],[1,2],[1,2,3]]
        end

        describe "Neat Examples" do

          example "make nested ranges" do
            range[range[range[3]]].tap do |o|
              expect(o).to be_a Enumerator
              o.each do |i|
                expect(i).to be_a Enumerator
                i.each do |j|
                  expect(j).to be_a Enumerator
                end
              end
            end
            expect(range[range[range[3]]].to_a.map{ |i| i.to_a.map(&:to_a) }).to eq [[[1]],[[1],[1,2]],[[1],[1,2],[1,2,3]]]
          end

        end

      end

      # http://reference.wolfram.com/language/ref/Subdivide.html
      describe "#subdivide" do

        example "no args raise ArgumentError" do
          expect{ subdivide[] }.to raise_error ArgumentError
        end
        example "more than 3 args raise ArgumentError" do
          expect{ subdivide[1,2,3,4] }.to raise_error ArgumentError
        end
        # example "division into 0 parts raises ArgumentError" do
        #   expect{ subdivide[0] }.to raise_error ArgumentError
        # end

        describe "Details" do

          example "generates a list of length n+1" do
            expect(subdivide[5]).to be_a Enumerator
            expect(subdivide[5].size).to eq 6
          end

        end

        describe "Basic Examples" do

          example "subdivide the unit interval into 4 equal parts" do
            expect(subdivide[4]).to be_a Enumerator
            expect(subdivide[4].to_a).to eq [0,0.25,0.5,0.75,1]
          end
          example "subdivide the interval 0 to 10 into 5 equal parts" do
            expect(subdivide[10,5]).to be_a Enumerator
            expect(subdivide[10,5].to_a).to eq [0,2,4,6,8,10]
          end
          example "subdivide the interval -1 to 1 into 8 equal parts using machine precision" do
            expect(subdivide[-1,1,8]).to be_a Enumerator
            expect(subdivide[-1,1,8].to_a).to eq [-1,-0.75,-0.5,-0.25,0,0.25,0.5,0.75,1]
          end

          # NOTE: Wolfram Mathematica can't do this
          example "subdivide(max, min, n)" do
            expect(subdivide[1,-1,8]).to be_a Enumerator
            expect(subdivide[1,-1,8].to_a).to eq [1,0.75,0.5,0.25,0,-0.25,-0.5,-0.75,-1]
          end

        end

        describe "Properties & Relations" do

          example "subdivide[xmin,xmax,n] is equivalent to xmin+(xmax-xmin)Range[0,n]/n" do
            expect(subdivide[2,10,4].to_a).to eq plus[2,divide[times[10-2,range[0,4]],4]].to_a
          end

        end

      end

      # http://reference.wolfram.com/language/ref/NestList.html
      describe "#nest_list" do

        example "gives a list of length n+1" do
          expect(nest_list[->{}, 0, 5]).to be_a Enumerator
          expect(nest_list[->(*args){}, 0, 5].to_a.size).to eq 6
        end

        describe "Basic Examples" do

          example "???" do
            skip "#cos (or #sqrt or anything unar is yet to be implemented"
          end

        end

        describe "Scope" do

          example "nesting can return a single number" do
            skip "#sqrt is yet to be implemented"
          end

        end

        describe "Applications" do

          example "powers of 2" do
            expect(nest_list[->(i){ 2*i }, 1, 10]).to be_a Enumerator
            expect(nest_list[->(i){ 2*i }, 1, 10].to_a).to eq [1,2,4,8,16,32,64,128,256,512,1024]
          end
          example "iterates in the  problem" do
            expect(nest_list[->(i){ i.even? ? i/2 : (i*3+1)/2 }, 100, 20]).to be_a Enumerator
            expect(nest_list[->(i){ i.even? ? i/2 : (i*3+1)/2 }, 100, 20].to_a).to eq [100,50,25,38,19,29,44,22,11,17,26,13,20,10,5,8,4,2,1,2,1]
          end
          example "linear congruential pseudorandom generator" do
            expect(nest_list[->(i){ (i*59)%101 }, 1, 15]).to be_a Enumerator
            expect(nest_list[->(i){ (i*59)%101 }, 1, 15].to_a).to eq [1,59,47,46,88,41,96,8,68,73,65,98,25,61,64,39]
          end
          example "random walk" do
            expect(( r = Random.new(0); nest_list[->(i){ i+[-1,1][r.rand(2)] }, 0, 20] )).to be_a Enumerator
            expect(( r = Random.new(0); nest_list[->(i){ i+[-1,1][r.rand(2)] }, 0, 20].to_a )).to eq [0,-1,0,1,0,1,2,3,4,5,6,7,6,5,6,5,4,3,2,1,2]
          end
          example "successively rotate a list" do
            expect(nest_list[->(i){ i.rotate 1 }, [1,2,3,4], 4]).to be_a Enumerator
            expect(nest_list[->(i){ i.rotate 1 }, [1,2,3,4], 4].to_a).to eq [[1,2,3,4],[2,3,4,1],[3,4,1,2],[4,1,2,3],[1,2,3,4]]
          end

        end

        describe "Properties & Relations" do

          example "#nest gives the last element of #nest_list" do
            expect(nest_list[->(i){ i*2 }, 3, 4].to_a.last).to eq nest[->(i){ i*2 }, 3, 4]
          end

          example "nesting zero times simply returns to the original argument" do
            expect(nest_list[->{fail}, 5, 0]).to be_a Enumerator
            expect(nest_list[->(*args){fail}, 5, 0].to_a).to eq [5]
          end
          example "#fold_list automatically inserts second arguments from a list" do
            expect(nest_list[->(i  ){ i*2 }, 3,     4].to_a).to eq \
                   fold_list[->(i,j){ i*j }, 3, [2]*4].to_a
          end

        end

      end

    end

    # http://reference.wolfram.com/language/guide/ApplyingFunctionsToLists.html
    describe "Applying Functions to Lists" do

      # http://reference.wolfram.com/language/ref/FoldList.html
      describe "#fold_list" do

        describe "Details" do

          example "with a length n list, #fold_list generates a list of length n+1" do
            skip "waiting got Wolfram team to fix the reported bug"
          end
          example "#fold_list[f,list] is equivalent to #fold_list[f,[list][0],list[1..-1]]" do
            expect(fold_list[plus,[1,2,3]]).to be_a Enumerator
            expect(fold_list[plus,[1,2,3]].to_a).to eq fold_list[plus,1,[2,3]].to_a
          end

        end

        describe "Basic Examples" do

          example "cumulative sums of the elements of the list" do
            expect(fold_list[plus,5,[1,2,3,4]]).to be_a Enumerator
            expect(fold_list[plus,5,[1,2,3,4]].to_a).to eq [5,6,8,11,15]
          end
          example "cumulative powers" do
            expect(fold_list[->(base, power){ base ** power },2,[3,2,1]]).to be_a Enumerator
            expect(fold_list[->(base, power){ base ** power },2,[3,2,1]].to_a).to eq [2,8,64,64]
          end
          example "start from the first element of the list" do
            expect(fold_list[plus,[1,2,3,4]]).to be_a Enumerator
            expect(fold_list[plus,[1,2,3,4]].to_a).to eq [1,3,6,10]
          end

        end

        describe "Applications" do

          # TODO maybe move it to README.md
          example "generate a random walk" do
            expect(( r = Random.new(0); fold_list[plus, 0, Array.new(20){ [-1,1][r.rand(2)] }] )).to be_a Enumerator
            expect(( r = Random.new(0); fold_list[plus, 0, Array.new(20){ [-1,1][r.rand(2)] }].to_a )).to eq [0,-1,0,1,0,1,2,3,4,5,6,7,6,5,6,5,4,3,2,1,2]
          end

          example "find successively deeper parts in an expression" do
            expect(fold_list[->(list,index){ list[index] }, [[1,2],[3,[4,5],6,7],8], [1,1,0]]).to be_a Enumerator
            expect(fold_list[->(list,index){ list[index] }, [[1,2],[3,[4,5],6,7],8], [1,1,0]].to_a).to eq [[[1,2],[3,[4,5],6,7],8],[3,[4,5],6,7],[4,5],4]
          end

        end

        describe "Properties & Relations" do

          example "makes a list of length n+1" do
            expect(fold_list[->{}, 0, [*1..10]]).to be_a Enumerator
            expect(fold_list[->(*args){}, 0, [*1..10]].to_a.size).to eq 11
          end
          example "folding with an empty list does not apply the function at all" do
            expect(fold_list[->{}, 0, []]).to be_a Enumerator
            expect(fold_list[->(*args){}, 0, []].to_a).to eq [0]
          end
          example "Ruby#inject gives the last element of #fold_list" do
            f = ->(i,j){ i+j }
            expect(fold_list[f, [1,2,3]]).to be_a Enumerator
            expect(fold_list[f, [1,2,3]].to_a.last).to eq [1,2,3].inject(&f)
          end
          example "functions that ignore their second argument give the same result as in #nest_list" do
            expect(fold_list[->(i,_){ [i] }, 0, range[5]].to_a).to eq nest_list[->(i){ [i] }, 0, 5].to_a
          end

        end

        describe "Neat Examples" do

          example "compute the minimum number of coins of different value needed to make up an amount" do
            skip "at least #mod is yet to be implemented"
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

      # http://reference.wolfram.com/language/ref/Nest.html
      describe "#nest" do

        describe "Basic Examples" do

          example "the function to nest can be a pure function" do
            expect(nest[->(i){ (1+i)**2 }, 1, 3]).to eq 676
          end

        end

        describe "Scope" do

          example "nesting can return a single number" do
            skip "#sqrt is yet to be implemented"
          end

        end

        describe "Applications" do

          example "newton iterations for" do
            skip "waiting for Rationals to be used"
          end
          example "consecutive pairs of Fibonacci numbers" do
            skip "#dot is yet to be implemented"
          end

        end

        describe "Properties & Relations" do

          example "Ruby#inject automatically inserts second arguments from a list" do
            expect(nest[->(i){ i*2 }, 3, 4]).to eq ([2]*4).inject(3){ |i,j| i*j }
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

Table     Array
Times     Product
Plus      Total   Sum?
NestList  Accumulate
