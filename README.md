# MLL (Mathematica Language Library)

Этот гем не ставит перед собой цель полностью имитировать типы данных, синтаксис Математики, или научить Ruby крутым визуализациям. Целью является вложить в Ruby мощь стандартной библиотеки. Прежде всего, List manipulation. В перспективе визуализация возможна при помощи других гемов.

## Usage

Планируется несколько способов использования этой библиотеки -- как доступ к ней через `MLL::`, так и манкипатчинг стандартных типов, таких как Numeric и Array.

### Examples:

    MLL::range(3).to_a               #=> [1, 2, 3]
    MLL::range(range(3)).map(&:to_a) #=> [[1], [1, 2], [1, 2, 3]]

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mll'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mll
