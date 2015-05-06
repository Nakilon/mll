require_relative File.join "..", "lib", "mll"


describe MLL do

  describe "range" do

    example "range(n)" do
      expect(MLL::range(5)).to be_a Enumerator
      expect(MLL::range(5).to_a).to eq [1,2,3,4,5]
    end
    example "range(imin, imax)" do
      expect(MLL::range(2,5)).to be_a Enumerator
      expect(MLL::range(2,5).to_a).to eq [2,3,4,5]
    end
    example "range(imin, imax, id)" do
      expect(MLL::range(2,5,2)).to be_a Enumerator
      expect(MLL::range(2,5,2).to_a).to eq [2,4]
      expect(MLL::range(2,6,2).to_a).to eq [2,4,6]
    end
    example "range([n1,n2])" do
      # TODO add .to be_a Enumerator
      expect(MLL::range([2,3]).map(&:to_a)).to eq [[1,2],[1,2,3]]
    end
    example "range(range(n))" do
      # TODO add .to be_a Enumerator
      expect(MLL::range(MLL::range(3)).map(&:to_a)).to eq [[1],[1,2],[1,2,3]]
    end

  end

end


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
