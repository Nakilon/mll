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
