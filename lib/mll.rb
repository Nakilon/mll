module MLL

  def self.define_function_that_can_enumerate name, &block
    # http://stackoverflow.com/a/12792313/322020
    (class << self; self end).class_eval do
      define_method name do |*args|
        if args.size == 1 && args.first.respond_to?(:map)
          args.first.lazy.map &method(name)
        else
          block.call *args
        end
      end
    end
  end

  define_function_that_can_enumerate :range do |*args|
    case args.size
    when 1 ; range 1, args[0] # TODO do smth with #table(-n)
    when 2 ; Range.new(args[0], args[1])
    when 3
      case args[2] <=> 0
      when 0 ; raise ArgumentError.new("step can't be zero")
      when 1 ; Range.new(args[0], args[1]).step args[2]
      else
        Enumerator.new do |e|
          from, to, step = *args
          while (step > 0) ? from <= to : from >= to
            e << from
            from += step
          end
        end
      end
    else
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1..3)") # unless (1..3).include? args.size
    end
  end

  def self.table f, *args
    # TODO make it lazy?

    [].tap do |result|
      [[result, args.map{ |r| range(*r).to_a }]].tap do |stack|
        stack.each do |ai, ri|
          ai.replace ri.first.map{ |i|
            if ri.size == 1
              f.call(*ai, i)
            else
              [*ai.dup, i].tap{ |t| stack << [t, ri.drop(1)] }
            end
          }
        end
      end
    end

  end

end
