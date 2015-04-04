require_relative File.join "..", "lib", "mll"

describe "mll" do

  describe "range" do

    example "range(n)" do
      expect(MLL::range(5).to_a).to eq [1,2,3,4,5]
    end
    example "range(imin, imax)" do
      expect(MLL::range(2,5).to_a).to eq [2,3,4,5]
    end
    example "range(imin, imax, id)" do
      expect(MLL::range(2,5,2).to_a).to eq [2,4]
      expect(MLL::range(2,6,2).to_a).to eq [2,4,6]
    end
    example "range([n1,n2])" do
      expect(MLL::range([2,3]).map(&:to_a)).to eq [[1,2],[1,2,3]]
    end
    example "range(range(n))" do
      expect(MLL::range(MLL::range(3)).map(&:to_a)).to eq [[1],[1,2],[1,2,3]]
    end

  end

end
