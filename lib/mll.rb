module MLL

  VERSION = "2.5.0"

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
            if r.respond_to? :map
              next r if r.is_a? Range
              next r.first if r.first.respond_to? :map # TODO check r.size?
            end
            range[*r]
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
      lambda do |table, spacings: [1, 1], **options|
        # TODO negative spacings?
        spacing_horizontal, spacing_vertical = spacings
        spacing_vertical ||= 1
        raise ArgumentError.new("unsupported value of :alignment option '#{options[:alignment]}'") unless \
          alignment = {
            nil => :center,
            :center => :center,
            :left => :ljust,
            :right => :rjust,
          }[options[:alignment]]
        raise ArgumentError.new("unsupported value of :frame option '#{options[:frame]}'") unless \
          frames = {
            nil  => "              ",
            true => "┃ ┏┓ ┗┛━ ┃━━┃ ",
            :all => "┃┃┏┓╋┗┛━━┣┳┻┫ ",
          }[options[:frame]]
        # TODO smth with this; maybe check out how Mathematica handles `Table[{1,{2,3},4}]`

        table = [table] unless table.all?{ |e| e.respond_to? :each }
        width = table.map(&:size).max
        table = table.map do |row|
          row.dup.tap do |row|
            row[width - 1] = row[width - 1]
          end.map &:to_s
        end
        rows = table.map{ |row| row.map{ |s| s.count ?\n }.max + 1 }
        cols = table.transpose.map{ |col| col.flat_map{ |s| s.scan(/.+/).map(&:size) }.max }

        chars = table.flat_map.with_index do |row, i|
          row.map.with_index do |s, j|
            lines = s.scan(/.+/)
            max = lines.map(&:size).max || 0
            lines.map!{ |line| line.ljust(max).method(alignment).call(cols[j]) }
            Array.new([rows[i] + spacing_vertical * 2 - 1, 1].max) do |k|
              Array.new([cols[j] + spacing_horizontal * 2 - 1, 1].max) do |l|
                m = k - spacing_vertical
                n = l - spacing_horizontal
                0<=m && m<lines.size && 0<=n && n<cols[j] ? lines[m][n] : frames[(
                  h = spacing_horizontal.zero?
                  v = spacing_vertical.zero?
                  k == 0 ? l == 0 ?
                    h ? v ? ?O : 7 : v ? 0 :
                      i.zero? ? j.zero? ? 2 : 10 : j.zero? ? 9 : 4 :
                    v ? 13 : i.zero? ? 7 : 8 : l == 0 ? j.zero? ? 0 : 1 : 13
                )]
              end
            end
          end.transpose.map{ |row| row.inject :+ }
        end

        borders_horizontal = fold_list[0, rows, ->i,j{ i + j + spacing_vertical * 2 - 1 }].to_a
        chars.each_with_index do |line, i|
          line.push frames[borders_horizontal.include?(i) && !spacing_vertical.zero? ? 12 : 0]
          line.unshift frames[i.zero? ? 2 : borders_horizontal.include?(i) && !spacing_vertical.zero? ? 9 : 0] if spacing_horizontal.zero?
        end
        borders_vertical = fold_list[0, cols, ->i,j{ i + j + spacing_horizontal * 2 - 1 }].to_a
        chars = chars.transpose.each_with_index do |line, i|
          line.push frames[i.zero? ? 5 : borders_vertical.include?(i) && !spacing_horizontal.zero? ? 11 : 7]
          line.unshift frames[i.zero? ? 2 : borders_vertical.include?(i) && !spacing_horizontal.zero? ? 10 : 7] if spacing_vertical.zero?
        end.transpose
        chars[-1][-1] = frames[6]
        chars[0][-1] = frames[3]

        chars.map{ |row| row.push ?\n }.join
      end
    end

    def subdivide
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

    def riffle
      lambda do |*args|
        case args.size
          when 2
            next riffle[*args, [2,-2,2]] unless args[1].respond_to?(:each) && args[0].size == args[1].size
            Enumerator.new do |e|
              args[0].zip(args[1]){ |i, j| e << i << j }
            end
          when 3
            args[2] = [args[2], -2, args[2]] unless args[2].respond_to? :each
            Enumerator.new do |e|
              min = (args[2][0] < 0) ? (args[0].size + args[2][0]) : args[2][0] - 1
              max = (args[2][1] < 0) ? (args[0].size + args[2][1]) : args[2][1]
              min, max = max, min if args[2][0] < 0
              step = args[2][2]
              pos = 0
              args[0].each_with_index do |x, i|
                # TODO make it not destructive
                (pos += 1; e << x)
                (pos += 1; e << (args[1].respond_to?(:each) ? args[1].rotate!.last : args[1])) if min - 1 <= i && i <= max && (pos - min) % step == 0
              end
            end
        else
          raise ArgumentError.new("wrong number of arguments (#{args.size} for 2..3)")
        end
      end
    end

    def most
      # not Enumerator because if the end is invisible we can't stop at -2
      lambda do |list|
        list[0..-2]
      end
    end

    def rest
      lambda do |list|
        Enumerator.new do |e|
          begin
            enum = list.to_enum.tap &:next
            loop{ e << enum.next }
          rescue StopIteration
            next
          end
        end
      end
    end

  end

  def self.define_listable_function name, &block
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

  # TODO not sure if we need any other kind of Listability except of #range[[Array]]
  define_listable_function :range do |*args|
    case args.size
    when 1 ; range[1, args[0]] # TODO do smth with #table(-n)
    when 2 ; Range.new(args[0], args[1]).step
    when 3
      case args[2] <=> 0
      when 0 ; raise ArgumentError.new("step can't be zero")
      # when 1 ; Range.new(args[0], args[1]).step args[2]
      else
        Enumerator.new do |e|
          from, to, step = *args
          step = step.abs * (to <=> from)
          while (step > 0) ? (from <= to) : (from >= to)
          # while from >= to
            e << from
            from += step
          end
        end
      end
    else
      raise ArgumentError.new("wrong number of arguments (#{args.size} for 1..3)")
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
