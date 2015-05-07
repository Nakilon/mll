module MLL

  def self.define_function_that_can_enumerate name, &block
    # http://stackoverflow.com/a/12792313/322020
    (class << self; self end).class_eval do
      define_method name do |*args|
        if args.size == 1 && args.first.respond_to?(:map)
          args.first.map &method(name)
        else
          block.call *args
        end
      end
    end
  end

  define_function_that_can_enumerate :range do |*args|
    raise ArgumentError.new("wrong number of arguments (#{args.size} for 1..3)") unless (1..3).include? args.size
    next range 1, args[0] if args.size == 1
    Range.new(args[0], args[1]).step(args[2] || 1)
  end

end


=begin

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

=end
