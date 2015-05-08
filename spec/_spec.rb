require_relative File.join "..", "lib", "mll"


# http://reference.wolfram.com/language/guide/LanguageOverview.html
describe MLL do

  # http://reference.wolfram.com/language/guide/ListManipulation.html
  describe "List Manipulation" do

    # http://reference.wolfram.com/language/guide/ConstructingLists.html
    describe "Constructing Lists" do

      # http://reference.wolfram.com/language/ref/Range.html
      describe "#range" do

        # TODO negative step and add it to README.rb

        example "range( >3 args )" do
          expect{ MLL::range(1,2,3,4) }.to raise_error ArgumentError
        end

        describe "Basic Examples" do

          example "range(n)" do
            expect(MLL::range(4)).to be_a Range
            expect(MLL::range(4).to_a).to eq [1,2,3,4]
          end
          example "range(imin, imax)" do
            expect(MLL::range(2,5)).to be_a Range
            expect(MLL::range(2,5).to_a).to eq [2,3,4,5]
          end
          example "range(imin, imax, id)" do
            expect(MLL::range(1,2,3)).to be_a Enumerator
            expect(MLL::range(1,2,0.5).to_a).to eq [1,1.5,2] # can be precision problems
            expect(MLL::range(2,6,2).to_a).to eq [2,4,6]
            expect(MLL::range(-4,9,3).to_a).to eq [-4,-1,2,5,8]
            # Ruby can't negative Range#step, haha!
            expect(MLL::range(10,-5,-2).to_a).to eq [10,8,6,4,2,0,-2,-4]
            expect(MLL::range(3,1,-1).to_a).to eq [3,2,1]
          end
        end

        describe "Generalizations & Extensions" do

          example "range([n1, n2, n3, n4])" do
            expect(MLL::range([5,2,6,3])).to be_a Enumerator
            MLL::range([5,2,6,3]).each do |i|
              expect(i).to be_a Range
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

          example "range(imin..imax)" do
            expect(MLL::range(MLL::range(3))).to be_a Enumerator
            MLL::range(MLL::range(3)).each do |i|
              expect(i).to be_a Range
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
                  expect(j).to be_a Range
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

      # http://reference.wolfram.com/language/ref/Table.html
      describe "#table" do

        describe "Basic Examples" do

          example "table(lambda, [n])" do
            expect(MLL::table(->(i){ i**2 }, [10])).to eq [1,4,9,16,25,36,49,64,81,100]
          end
          example "table(lambda, [imin, imax, id])" do
            expect(MLL::table(->(i){ i+2 }, [0, 20, 2])).to eq [2,4,6,8,10,12,14,16,18,20,22]
          end
          example "table(lambda, [n1], [n2])" do
            expect(MLL::table(->(i, j){ 10*i + j }, [4], [3])).to eq [[11,12,13],[21,22,23],[31,32,33],[41,42,43]]
          end

          example "matrix_form table(lambda, [n1], [n2])" do
            pending "#matrix_form is yet to be implemented"
            expect(MLL::matrix_form MLL::table(->(i, j){ 10*i + j }, [4], [3])).to eq "
            "
          end

        end

      end

    end

    # http://reference.wolfram.com/language/guide/ElementsOfLists.html
    # http://reference.wolfram.com/language/guide/RearrangingAndRestructuringLists.html
    # http://reference.wolfram.com/language/guide/ApplyingFunctionsToLists.html
    # http://reference.wolfram.com/language/guide/MathematicalAndCountingOperationsOnLists.html

  end

  # http://reference.wolfram.com/language/guide/FunctionalProgramming.html

end

      # http://reference.wolfram.com/language/guide/HandlingArraysOfData.html
      # http://reference.wolfram.com/language/guide/ComputationWithStructuredDatasets.html
