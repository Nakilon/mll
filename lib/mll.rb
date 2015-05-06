# http://reference.wolfram.com/language/guide/LanguageOverview.html
module MLL

  # http://reference.wolfram.com/language/guide/ListManipulation.html

    # http://reference.wolfram.com/language/guide/ConstructingLists.html

    # http://reference.wolfram.com/language/ref/Range.html
    def self.range *args
      # see also http://ruby-doc.org/core-1.9.3/Range.html#method-i-step
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1..3)") unless (1..3).include? args.size
      if args.size == 1
        if args[0].respond_to?(:map)
          args[0].map &method(:range)
        else
          range 1, args[0]
        end
      else
        Range.new(args[0], args[1]).step(args[2] || 1)
      end
    end

    # http://reference.wolfram.com/language/guide/ElementsOfLists.html
    # http://reference.wolfram.com/language/guide/RearrangingAndRestructuringLists.html
    # http://reference.wolfram.com/language/guide/ApplyingFunctionsToLists.html
    # http://reference.wolfram.com/language/guide/MathematicalAndCountingOperationsOnLists.html

  # http://reference.wolfram.com/language/guide/FunctionalProgramming.html

end

      # http://reference.wolfram.com/language/guide/HandlingArraysOfData.html
      # http://reference.wolfram.com/language/guide/ComputationWithStructuredDatasets.html

module Enumerable
  STDERR.puts "WARNING: #{name}#range was already defined" if method_defined? "range"
  def range
    # if self.respond_to? :each
      if self.first.respond_to? :each
        raise ArgumentError.new("if the first #range parameter responds to :each, it should be the only argument") \
          if self.size > 1
        self.first.zip.map &:range
      else
        case self.size
        when 1 ; [1,self.first].range
        when 2 ; Range.new(*self.take(2)).step(1) # to convert Rage into Enumerator
        when 3 ; Range.new(*self.take(2)).step(self.drop(2).first)
        when 4 ; raise ArgumentError.new("wrong number of arguments (#{self.size} for 1..3)")
        end
      end
    # else
    #   [1, self].range
    # end
  end
end

class Fixnum
  STDERR.puts "WARNING: #{name}#range was already defined" if method_defined? "range"
  def range
    # if self.respond_to? :each
    #   if self.first.respond_to? :each
    #     self.map &:range
    #   else
    #     Range.new(*self[0,2]).step(self[2] || 1)
    #   end
    # else
      [self].range
    # end
  end
end
