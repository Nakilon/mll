require_relative File.join "..", "lib", "mll"


# http://reference.wolfram.com/language/guide/LanguageOverview.html
describe MLL do

  # http://reference.wolfram.com/language/guide/ListManipulation.html
  describe "List Manipulation" do

    # http://reference.wolfram.com/language/guide/ConstructingLists.html
    describe "Constructing Lists" do

      # http://reference.wolfram.com/language/ref/Range.html
      describe "range" do

        example "range( >3 args )" do
          expect{ MLL::range(1,2,3,4) }.to raise_error ArgumentError
        end

        describe "Basic Examples" do

          example "range(n)" do
            expect(MLL::range(4)).to be_a Enumerator
            expect(MLL::range(4).to_a).to eq [1,2,3,4]
          end
          example "range(imin, imax)" do
            expect(MLL::range(2,5)).to be_a Enumerator
            expect(MLL::range(2,5).to_a).to eq [2,3,4,5]
          end
          example "range(imin, imax, id)" do
            expect(MLL::range(1,2,3)).to be_a Enumerator
            expect(MLL::range(1,2,0.5).to_a).to eq [1,1.5,2]
            expect(MLL::range(2,6,2).to_a).to eq [2,4,6]
            expect(MLL::range(-4,9,3).to_a).to eq [-4,-1,2,5,8]
          end
          # example "range(imin, imax, id)" do
          #   expect(MLL::range(2,5,2)).to be_a Enumerator
          #   expect(MLL::range(2,5,2).to_a).to eq [2,4]
          #   expect(MLL::range(2,6,2).to_a).to eq [2,4,6]
          # end
        end

        describe "Generalizations & Extensions" do

          example "range([n1, n2, n3, n4])" do
            # expect(MLL::range([2,3])).to be_a Enumerator # TODO revive me
            MLL::range([5,2,6,3]).each do |i|
              expect(i).to be_a Enumerator
            end
            expect(MLL::range([5,2,6,3]).map(&:to_a)).to eq [[1,2,3,4,5],[1,2],[1,2,3,4,5,6],[1,2,3]]
          end

        end

        describe "Applications" do

          example "power(2, range(5))" do
            pending "#power is yet to be implemented"
            p power(2, range(5))
            expect(power(2, range(5))).to eq [2,4,8,16,32]
          end

        end

        describe "Neat Examples" do

          example "range(range(n))" do
            # expect(MLL::range(MLL::range(3))).to be_a Enumerator # TODO revive me
            MLL::range(MLL::range(5)).each do |i|
              expect(i).to be_a Enumerator
            end
            expect(MLL::range(MLL::range(5)).map(&:to_a)).to eq [[1],[1,2],[1,2,3],[1,2,3,4],[1,2,3,4,5]]
          end
          example "range(range(range(n)))" do
            # expect(MLL::range(MLL::range(3))).to be_a Enumerator # TODO revive me
            # MLL::range(MLL::range(MLL::range(3))).each do |i|
            #   expect(i).to be_a Enumerator
            # end
            expect(MLL::range(MLL::range(MLL::range(3))).map{ |i| i.map(&:to_a) }).to eq [[[1]],[[1],[1,2]],[[1],[1,2],[1,2,3]]]
          end

          # TODO Nest[Range,3,6]

        end

        # TODO "Find an inverse permutation:"
        # TODO "Use Range or Span (;;) as Part specification:"

      end

    end

    # http://reference.wolfram.com/language/guide/ElementsOfLists.html
    # http://reference.wolfram.com/language/guide/RearrangingAndRestructuringLists.html
    # http://reference.wolfram.com/language/guide/ApplyingFunctionsToLists.html
    # http://reference.wolfram.com/language/guide/MathematicalAndCountingOperationsOnLists.html

  end

  # http://reference.wolfram.com/language/guide/FunctionalProgramming.html

end


=begin

describe "range" do

  example "n.range" do
    expect(5.range).to be_a Enumerator
    expect(5.range.to_a).to eq [1,2,3,4,5]
  end

  example "[imin, imax].range" do
    expect([2,5].range).to be_a Enumerator
    expect([2,5].range.to_a).to eq [2,3,4,5]
  end
  example "[imin, imax, id].range" do
    expect([2,5,2].range).to be_a Enumerator
    expect([2,5,2].range.to_a).to eq [2,4]
    expect([2,6,2].range.to_a).to eq [2,4,6]
  end
  example "[[n1,n2]].range" do
    # expect([[2,3]].range).to be_a Enumerator # TODO revive me
    [[2,3]].range.each do |i|
      expect(i).to be_a Enumerator
    end
    # expect([[2,3]].range.map(&:to_a)).to eq [[1,2],[1,2,3]]
    expect([[2,3]].range.map(&:to_a)).to eq [[1,2],[1,2,3]]
  end

  # using methods instead of functions helps us with method_missing but forces to add []
  example "n.range.range" do
    # expect([3.range].range).to be_a Enumerator # TODO revive me
    expect([3.range].range.map(&:to_a)).to eq [[1],[1,2],[1,2,3]]
  end

  # TODO 4 args should fail

end

=end
