module MLL

  # https://reference.wolfram.com/language/ref/Listable.html
  def self.define_listable_function name, &block
    (class << self; self end).class_eval do # http://stackoverflow.com/a/12792313/322020
      define_method name do |*args|
# p [name, args]
        next block.call *args unless args[0].respond_to? :map
        next args[0].lazy.map{ |i| send name, i, *args.drop(1) } unless args[1].respond_to? :map
        # raise "idk how to list this function" if args.size > 2
        next args[0].lazy.zip(args[1]).map{ |i,j| send name, i, j, *args.drop(2) }
      end
    end
  end

  define_listable_function :range do |*args|
    case args.size
    when 1 ; range 1, args[0] # TODO do smth with #table(-n)
    when 2 ; Range.new(args[0], args[1]).step
    when 3
      case args[2] <=> 0
      when 0 ; raise ArgumentError.new("step can't be zero")
      when 1 ; Range.new(args[0], args[1]).step args[2]
      else
        Enumerator.new do |e|
          from, to, step = *args
          # while (step > 0) ? from <= to : from >= to
          while from >= to
            e << from
            from += step
          end
        end
      end
    else
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1..3)")
    end
  end

  def self.table f, *args
    [].tap do |result|
      [[result, args.map{ |r| # add lazy?
        r.respond_to?(:map) && r.first.respond_to?(:map) ?
          r.first : range(*r)
      }]].tap do |stack|
        stack.each do |ai, ri|
          # TODO try to make #table lazy (Enumerator instead of Array)
          # "no implicit conversion of Enumerator::Lazy into Array"
          # "undefined method `replace' for #<Enumerator::Lazy: []>"
          ai.replace ri.first.map{ |i|
            if ri.size == 1
              f.call(*ai, i)
            else
              [*ai.dup, i].tap{ |t| stack << [t, ri.drop(1)] }
            end
          }#.to_a # WTF
        end
      end
    end
  end

  define_listable_function :divide do |a, b|
    a / b
  end

  def self.subdivide *args
    case args.size
    when 1 ; subdivide 1, args[0]
    when 2 ; subdivide 0, args[0], args[1]
    when 3 ; range(args[0], args[1], (args[1] - args[0]) * 1.0 / args[2])
    else
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1..3)")
    end
  end

end
