
class Coordinate
  attr_writer :x, :y, :z, :t
  attr_reader :x, :y, :z, :t

  def initialize(x, y, z, t=0)
    @x = x
    @y = y
    @z = z
    @t = t
  end

  def ==(other)
    x == other.x && y == other.y && z == other.z && other.t == t
  end

  def to_s
    "(#{x},#{y},#{z},#{t})"
  end

  def self.from_string(str)
    numbers = str.split(/\s/)
    x = numbers[0].to_i
    y = numbers[1].to_i
    z = numbers[2].to_i
    t = numbers[3].to_i
    Coordinate.new(x, y, z, t)
  end
end

class Maze
  MOVEMENTS = [:up, :down, :left, :right, :front, :back]
  def initialize(size)
    @space = []
    @size = size
    size.x.times do |x|
      @space[x] = []
      size.y.times do |y|
        @space[x][y] = []
        size.z.times do |z|
          @space[x][y][z] = '_'
        end
      end
    end
  end

  def wall(coordinate)
    @space[coordinate.x][coordinate.y][coordinate.z] = '*'
  end

  def wall?(coordinate)
    # Out of boundaries is a wall
    return true if coordinate.x < 0 || coordinate.x >= @size.x || \
                   coordinate.y < 0 || coordinate.y >= @size.y || \
                   coordinate.z < 0 || coordinate.z >= @size.z
    @space[coordinate.x][coordinate.y][coordinate.z] == '*'
  end

  def space?(coordinate)
    !wall?(coordinate)
  end

  def move(from, m)
    send(m, from)
  end

  def possible?(from, m)
    to = move(from, m)
    space?(to)
  end

  def up(from)
    to = from.dup
    to.z += 1
    to
  end

  def down(from)
    to = from.dup
    to.z -= 1
    to
  end

  def left(from)
    to = from.dup
    to.x -= 1
    to
  end

  def right(from)
    to = from.dup
    to.x += 1
    to
  end

  def back(from)
    to = from.dup
    to.y -= 1
    to
  end

  def front(from)
    to = from.dup
    to.y += 1
    to
  end

  def view
    @size.z.times do |z|
      puts "Floor #{z}"
      @size.y.times do |y|
        @size.x.times do |x|
          print @space[x][y][z]
        end
        puts
      end
    end
  end

  def to_s
    res = ''
    @size.x.times do |x|
      @size.y.times do |y|
        @size.z.times do |z|
          res += @space[x][y][z]
        end
      end
    end
    res
  end
end

class MazeInTime
  def initialize(size)
    @mazes = []
    @size = size
    size.t.times do
      @mazes << Maze.new(size)
    end
  end

  def add(coordinate, walls)
    @size.t.times do |i|
      # puts "I #{i}"
      # puts "walls #{walls}"
      # puts "initial #{walls[0]}"
      # puts "maze #{@mazes[0]}"
      @mazes[i].wall(coordinate) if walls[i] == "*"
    end
  end

  def maze(time)
    @mazes[time]
  end
end

class MazeSolver
  def initialize(size, start, finish)
    @size = size
    @start = start
    @finish = finish
    @mit = MazeInTime.new(@size)
    @solutions = []
  end

  def add_row(x, y, z, row)
    @mit.add(Coordinate.new(x, y, z), row)
  end

  def show_solutions
    @solutions.each_with_index do |sol, i|
      puts "Solution #{i} with #{sol.size} steps"
      sol.each do |step|
        puts "   #{step[0]} #{step[1]} #{step[2]}"
      end
    end
  end

  def solve
    try_all_movements(@start, 0)
    puts "Found #{@solutions.size} solutions"

    # show_solutions
    sanitize_solutions
    show_solutions
    sol = transformed_first_solution
    puts sol.size - 1
    sol.each do |step|
      puts "#{step.x} #{step.y} #{step.z} #{step.t}"
    end
    sol
  end

  def solutions
    @solutions
  end

  def transformed_first_solution
    tr = []
    @solutions.first.each do |step|
      tr << step[0]
    end
    tr << @solutions.first.last[2]
    tr
  end

  def sanitize_solutions
    # new_solutions = []
    # @solutions.each do |sol|
    #   ns = []
    #   sol.each_with_index do |step, i|
    #     # puts "Step #{step} ns = #{ns}"
    #     if ns.size == 0
    #       ns << step
    #     else
    #       # puts "   Last in ns is a #{ns.last[1]} and step has a #{step[1]}"
    #       if ns.last[1] == step[1] && ns.last[1] != :wait
    #         ns.last[2] = step[2]
    #       else
    #         ns << step
    #       end
    #     end
    #   end
    #   # puts "NS is #{ns}"
    #   new_solutions << ns
    # end
    # @solutions = new_solutions.sort { |a, b| a.size <=> b.size }
    @solutions = @solutions.sort { |a, b| a.size <=> b.size }
  end

  def try_all_movements(pos, time, solution = [])
    # puts "Started with pos #{pos} time #{time} solution #{solution}"
    if pos == @finish
      # puts "\n\n*****FOUND SOLUTION!!!\n\n"
      @solutions << solution
      # puts "Return with solution found"
      return true
    end
    if time >= @size.t
      # puts "Finished time (> #{@size.t})"
      return false
    end
    # sleep(1)
    # Try all possible movements at current time
    possible = possible_movements(pos, time)
    possible.each do |try|
      # puts "---Try from pos #{pos} at time #{time} to move #{try} Previous #{solution}..."
      to = @mit.maze(time).move(pos, try)
      to.t = time
      if inside_solution?(solution, to)
        # puts "---Not possible to move #{try} because I have passed there!"
      else
        try_all_movements(to, time, solution + [[pos, try, to]])
      end
    end
    # Check if it is possible to wait in place
    if time + 1 < @size.t
      # There is a next time
      next_maze = @mit.maze(time + 1)
      if next_maze.space?(pos)
        # It is possible to wait
        # Try all possible movements at the next time
        to = pos.dup
        to.t = time + 1
        try_all_movements(to, time + 1, solution + [[pos, :wait, to]])
      end
    end
    # puts "No time in the future, nothing to do... returning"
    false
  end

  def inside_solution?(solution, to)
    solution.each do |step|
      return true if step[0] == to
    end
    false
  end

  def possible_movements(pos, time)
    maze = @mit.maze(time)
    possible = []
    Maze::MOVEMENTS.each do |mov|
      possible << mov if maze.possible?(pos, mov)
    end
    possible
  end

  def view
    @size.t.times do |i|
      puts "Time #{i}"
      @mit.maze(i).view
    end
  end
end

class MazeGenerator
  RAND = 70

  def initialize(x, y, z, t)
    @size = Coordinate.new(x, y, z, t)
  end

  def create_maze
    generator = Random.new
    maze = []
    @size.x.times do |i|
      @size.y.times do |j|
        @size.z.times do |k|
          s = ''
          @size.t.times do |l|
            prob = (generator.rand * 100) .to_i
            if prob > RAND
              s << '_'
            else
              s << '*'
            end
          end
          puts "#{i} #{j} #{k} #{s}"
        end
      end
    end
  end
end

size = Coordinate.from_string(gets)
from = Coordinate.from_string(gets)
to = Coordinate.from_string(gets)

solver = MazeSolver.new(size, from, to)

total = size.x * size.y * size.z
total.times do 
  maze_row = gets
  fields = maze_row.split(' ')
  solver.add_row(fields[0].to_i, fields[1].to_i, fields[2].to_i, fields[3])
end

solver.view

solver.solve

# mg = MazeGenerator.new(2,3,2,5)
# mg.create_maze
