module MLL

  class << self

    def dimensions
      lambda do |list, limit = nil|
        list = [list]
        enumerator = Enumerator.new do |e|
          # String.size shall not pass
          while list.all?{ |i| i.respond_to? :each } &&
                list.map(&:size).uniq.size == 1
            # TODO refactor into depth-first yielding
            e << list.first.size
            list.flatten! 1
          end
        end
        limit ? enumerator.lazy.take(limit) : enumerator
      end
    end

    def tally
      lambda do |list, test = nil| # implement #sameq ?
        return Hash[ list.group_by{ |i| i }.map{ |k, v| [k, v.size] } ] unless test
        Hash.new{ 0 }.tap do |result|
          list.each do |item|
            result[
              list.find{ |key| test[key, item] }
            ] += 1
          end
        end
      end
    end

    def nest
      lambda do |expr, n, f|
        n.times{ expr = f.call expr }
        expr
      end
    end

    def nest_list
      lambda do |expr, n, f|
        Enumerator.new do |e|
          e << expr
          n.times do
            e << expr = f.call(expr)
          end
        end
      end
    end

    def nest_while
      # TODO finish me
      lambda do |expr, f, test|
        expr = f[expr] while test[expr]
        expr
      end
    end

    def fold_list
      lambda do |x, list, f = nil|
        unless f
          f = list
          x, *list = x.to_a
        end
        # TODO use Ruby#inject ?
        Enumerator.new do |e|
          e << x
          list.each do |i|
            e << x = f.call(x, i)
          end
        end
      end
    end

    def map
      # TODO validate depths
      # TODO break on passing all depths
      lambda do |list, depths, f = nil|
        depths, f = [1], depths unless f
        depths = Range.new(*depths) if depths.size == 2
        depths = Range.new(1,depths) if depths.is_a? Integer
        g = lambda do |list, depth|
          next list unless list.is_a? Array
          temp = list.lazy.map{ |i| g[i, depth + 1] }
          temp = temp.lazy.map &f if depths.include? depth
          temp
        end
        g[list, 1]
      end
    end

    def table
      lambda do |f, *args|
        [].tap do |result|
          [[result, args.map{ |r| # add lazy?
            r.respond_to?(:map) && r.first.respond_to?(:map) ?
              r.first : range[*r]
          }]].tap do |stack|
            stack.each do |ai, ri|
              # TODO try to make #table lazy (Enumerator instead of Array)
              # "no implicit conversion of Enumerator::Lazy into Array"
              # "undefined method `replace' for #<Enumerator::Lazy: []>"
              ai.replace ri.first.map{ |i|
                if ri.size == 1
                  f.respond_to?(:call) ? f.call(*ai, i) : f
                else
                  [*ai.dup, i].tap{ |t| stack << [t, ri.drop(1)] }
                end
              }
            end
          end
        end
      end
    end

    # http://www.unicode.org/charts/PDF/U2500.pdf
    # https://en.wikipedia.org/wiki/Box_Drawing
    def grid
      lambda do |table, **options|
        # TODO negative spacings?
        options[:spacings] ||= [1, 1]
        spacings_horizontal, spacings_vertical = [*options[:spacings]]
        spacings_vertical ||= 1
        raise ArgumentError.new("unknown value of :alignment option '#{options[:alignment]}'") unless \
          alignment = {
            nil => :center,
            :center => :center,
            :left => :ljust,
            :right => :rjust,
          }[options[:alignment]]
        frames = {
          nil  => "              ",
          true => "┃ ┏┓ ┗┛━ ┃━━┃ ",
          :all => "┃┃┏┓╋┗┛━━┣┳┻┫ ",
        }[options[:frame]]
        raise ArgumentError.new("unknown value of :frame option '#{options[:frame]}'") if options[:frame] && !frames
        # TODO smth with this #.all?
        table = [table] unless table.all?{ |e| e.respond_to? :each }
        width = table.map(&:size).max - 1
        strings = table.map{ |row| row.dup.tap{ |a| a[width] = a[width] }.map(&:to_s) }
        sizes = strings.transpose.map{ |col| col.map(&:size).max + [spacings_horizontal * 2 - 2, 0].max }
        # TODO https://reference.wolfram.com/language/ref/Alignment.html
        border_vertical  = [frames[9], sizes.map{ |size|  frames[8] * size }.join((frames[4] unless spacings_horizontal.zero?)), frames[12]]
        spacing_vertical = [frames[0], sizes.map{ |size| frames[13] * size }.join((frames[0] unless spacings_horizontal.zero?)), frames[0]]
        gap_vertical = lambda do |i|
          j = i - 1
          [*-j..j].map{ |k| [border_vertical][k] || spacings_vertical }
        end.call spacings_vertical
        [
          [frames[2], sizes.map{ |size| frames[7] * size }.join((frames[10] unless spacings_horizontal.zero?)), frames[3]].join,
          *([spacing_vertical.join] * [spacings_vertical - 1, 0].max),
          strings.map{ |row| [frames[0], row.zip(sizes).map{ |str, size|
            str.method(alignment).call(size)
          }.join((frames[1] unless spacings_horizontal.zero?)), frames[0]].join }.join(
            ?\n + gap_vertical.map{ |gap| gap.join + ?\n }.join
          ),
          *([spacing_vertical.join] * [spacings_vertical - 1, 0].max),
          [frames[5], sizes.map{ |size| frames[7] * size }.join((frames[11] unless spacings_horizontal.zero?)), frames[6]].join,
        ].join(?\n) + ?\n
      end
    end

    def define_listable_function name, &block
      (class << self; self end).class_eval do
        define_method name do
          lambda do |*args|
            case args.map{ |i| i.respond_to? :map }
              when [true] ; args.first.lazy.map &method(name).call
              when [true, true] ; args.first.lazy.zip(args.last).map{ |i, j| send(name)[i, j] }
              when [true, false] ; args.first.lazy.map{ |i| send(name)[i, args.last] }
              when [false, true] ; args.last.lazy.map{ |i| send(name)[args.first, i] }
            else
              block.call *args
            end
          end
        end
      end
    end

  end

  # TODO not sure if we need any other kind of Listability except of #range[[Array]]
  define_listable_function :range do |*args|
    case args.size
    when 1 ; range[1, args[0]] # TODO do smth with #table(-n)
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

  def self.subdivide
    lambda do |*args|
      case args.size
        when 1 ; subdivide[1, args[0]]
        when 2 ; subdivide[0, args[0], args[1]]
        when 3
          # raise ArgumentError.new("can't divide into 0 parts") if args[2].zero?
          range[args[0], args[1], (args[1] - args[0]) * 1.0 / args[2]]
      else
        raise ArgumentError.new("wrong number of arguments (#{args.size} for 1..3)")
      end
    end
  end

  define_listable_function(:subtract) { |*args| raise ArgumentError.new("need two arguments") unless args.size == 2 ; args[0] - args[1] }
  define_listable_function(:divide)   { |*args| raise ArgumentError.new("need two arguments") unless args.size == 2 ; args[0] / args[1] }
  define_listable_function(:_plus)    { |*args| raise ArgumentError.new("need two arguments") unless args.size == 2 ; args[0] + args[1] }
  define_listable_function(:_times)   { |*args| raise ArgumentError.new("need two arguments") unless args.size == 2 ; args[0] * args[1] }
  # TODO #power[]
  # define_listable_function (:power)   { |*args| raise ArgumentError.new("need two arguments") unless args.size == 2 ; args[0] ** args[1] }

  # http://reference.wolfram.com/language/ref/Orderless.html
  def self.define_orderless_function name, start, &block
    (class << self; self end).class_eval do # http://stackoverflow.com/a/12792313/322020
      define_method name do
       lambda do |*args|
          args.inject(start) do |memo, obj|
            block.call memo, obj
          end
        end
      end
    end
  end

  define_orderless_function(:plus,  0) { |a, b| _plus.call  a, b }
  define_orderless_function(:times, 1) { |a, b| _times.call a, b }
  
  def self.mean
    lambda do |list|
      divide[times[plus[*list], 1.0], list.size]
    end
  end

end
