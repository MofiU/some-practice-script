require 'forwardable'
require 'colorized_string'

class Chess
  def initialize(is_mine = false)
    @is_mine = is_mine
  end

  def mine?
    @is_mine
  end

  def set_mine
    @is_mine = true
  end
end

class Cell
  extend Forwardable
  attr_reader :row, :column, :chess, :is_click
  attr_accessor :nearby_mine_count

  def_delegators :@chess, :mine?, :set_mine

  def initialize(row, column, chess)
    @row = row
    @column = column
    @chess = chess
    @is_click = false
    @nearby_mine_count = 0
  end

  def clicked?
    @is_click
  end

  def click
    raise ClickMine, 'Boom...Boom...Boom....少侠别难过，请重新来过' if mine?
    raise UnableClick, '已经试探过该区域，重复试探无效' if clicked?
    @is_click = true
  end

  class ClickMine < StandardError; end
  class UnableClick < StandardError; end
end


class Board
  attr_reader :cells, :mine_cells
  def initialize(cells)
    @cells = cells
    @mine_cells = @cells.select(&:mine?)
    generate_cells_nearby_mine_count
  end

  def cells_count
    @cells.size
  end

  def mines_count
    @mine_cells.size
  end

  def clicked_cells_count
    @cells.select(&:clicked?).size
  end

  def click(row, column)
    cell = find_cell(row, column)
    raise BeyondBoard, '超出棋盘边界，无效值'  if cell.nil?
    cell.click
  end

  def display(display_tool, all)
    display_tool.show(@cells, all)
  end

  class BeyondBoard < StandardError; end

  private
  def generate_cells_nearby_mine_count
    @cells.each do |cell|
      cell.nearby_mine_count += 1 if !left_top(cell).nil? && left_top(cell).mine?
      cell.nearby_mine_count += 1 if !top(cell).nil? && top(cell).mine?
      cell.nearby_mine_count += 1 if !right_top(cell).nil? && right_top(cell).mine?
      cell.nearby_mine_count += 1 if !left(cell).nil? && left(cell).mine?
      cell.nearby_mine_count += 1 if !right(cell).nil? && right(cell).mine?
      cell.nearby_mine_count += 1 if !left_bottom(cell).nil? && left_bottom(cell).mine?
      cell.nearby_mine_count += 1 if !bottom(cell).nil? && bottom(cell).mine?
      cell.nearby_mine_count += 1 if !right_bottom(cell).nil? && right_bottom(cell).mine?
    end
  end

  def find_cell(row, column)
    cells.find { |cell| cell.row == row && cell.column == column }
  end

  def left_top(target_cell)
    find_cell(target_cell.row - 1, target_cell.column - 1)
  end

  def top(target_cell)
    find_cell(target_cell.row - 1, target_cell.column)
  end

  def right_top(target_cell)
    find_cell(target_cell.row - 1, target_cell.column + 1)
  end

  def left(target_cell)
    find_cell(target_cell.row , target_cell.column - 1)
  end

  def right(target_cell)
    find_cell(target_cell.row, target_cell.column + 1)
  end

  def left_bottom(target_cell)
    find_cell(target_cell.row + 1, target_cell.column - 1)
  end

  def bottom(target_cell)
    find_cell(target_cell.row + 1, target_cell.column)
  end

  def right_bottom(target_cell)
    find_cell(target_cell.row + 1, target_cell.column + 1)
  end
end

class Rule
  def win?(board)
    board.mines_count + board.clicked_cells_count == board.cells_count
  end
end

class Game
  extend Forwardable
  attr_reader :board, :rule, :rows, :columns, :mine_count
  def_delegator :board, :click
  def_delegator :rule, :win?

  def initialize(rows, columns, mine_count)
    @board = Board.new(cells(rows, columns, mine_count))
    @rule = Rule.new
    @display_tool = Display.new
  end

  def display(all = false)
    board.display(@display_tool, all)
  end

  def run
      puts "游戏生成成功"
    loop do
      display
      print "请输入坐标如 x,y : "
      position = STDIN.gets.chomp.split(',')
      begin
        click(position[0].to_i, position[1].to_i)
      rescue Board::BeyondBoard => e
        puts ColorizedString[e.message].colorize(:red)
        next
      rescue Cell::ClickMine => e
        display(true)
        puts ColorizedString[e.message].colorize(:red)
        Process.exit
      rescue Exception => e
        puts ColorizedString[e.message].colorize(:red)
        next
      end
      if win?(board)
        puts ColorizedString["算你吊，你赢了"].colorize(:cyan)
        Process.exit
      end
    end
  end

  private
  def cells(rows, columns, mine_count)
    cells = []
    rows.times do |row|
      columns.times do |column|
        cells << Cell.new(row + 1, column + 1, Chess.new)
      end
    end
    cells.map(&:chess).sample(mine_count).each(&:set_mine)
    cells
  end

end

class Display

  def show(cells, all = false)
    puts '------------------------------------------------'
    size = Math.sqrt(cells.size).to_i
    (size+1).times do |row|
      print ColorizedString[row.to_s.ljust(5)].colorize(:green)
    end
    puts

    cells.each_slice(size).with_index do |rows, index|
      print ColorizedString["#{index + 1}".ljust(5)].colorize(:green)
      rows.each do |cell, index|

          if cell.clicked? || all
            if cell.mine?
              print ColorizedString["O".ljust(5)].colorize(:red)
            else
              print ColorizedString[cell.nearby_mine_count.to_s.ljust(5)].colorize(:cyan)
            end
          else
            print '*'.ljust(5)
          end
      end
      puts
    end
    puts '------------------------------------------------'
  end
end

puts "设置难度"
puts "1: 低(3*3 3颗雷)"
puts "2: 低(5*5 5颗雷)"
puts "3: 低(7*7 7颗雷)"

level = STDIN.gets.chomp.to_i

game =
case level
when 1
  Game.new(3, 3, 3)
when 2
  Game.new(5, 5, 5)
when 3
  Game.new(7, 7, 7)
else
  puts ColorizedString["你是智障？不会看提示？"].colorize(:red)
  Process.exit
end

game.run
