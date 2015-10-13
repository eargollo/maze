require './maze_solver.rb'

describe 'full maze' do
  let :solver do
    size = Coordinate.new(2, 3, 2, 5)
    start = Coordinate.new(1, 2, 0, 0)
    finish = Coordinate.new(1, 0, 1, 4)
    rows = [
      [0, 0, 0, '*_***'],
      [0, 0, 1, '*__*_'],
      [0, 1, 0, '*****'],
      [0, 1, 1, '**__*'],
      [0, 2, 0, '*_***'],
      [0, 2, 1, '*__*_'],
      [1, 0, 0, '***_*'],
      [1, 0, 1, '**___'],
      [1, 1, 0, '*_***'],
      [1, 1, 1, '**_**'],
      [1, 2, 0, '__*_*'],
      [1, 2, 1, '__**_']
    ]

    solver = MazeSolver.new(size, start, finish)
    rows.each do |r|
      solver.add_row(r[0], r[1], r[2], r[3])
    end
    solver
  end

  it 'gathers possible movements' do
    expect(solver.possible_movements(Coordinate.new(1, 2, 0), 0)).to eql([:up])
    expect(solver.possible_movements(Coordinate.new(1, 2, 0), 1)).to eql([:up, :left, :back])
    expect(solver.possible_movements(Coordinate.new(0, 1, 1), 3)).to eql([])
    expect(solver.possible_movements(Coordinate.new(1, 0, 1), 2)).to eql([:left, :front])
  end

  it 'solves the sample maze' do
    solution = solver.solve
    expected_solution = [
      [1, 2, 0, 0],
      [1, 2, 1, 0],
      [1, 2, 1, 1],
      [0, 2, 1, 1],
      [0, 0, 1, 1],
      [0, 0, 1, 2],
      [1, 0, 1, 2],
      [1, 0, 1, 3],
      [1, 0, 1, 4]
    ]
    expect(solution.size).to eql(expected_solution.size)
    expect(solution).to eql(expected_solution)
  end
end

describe 'coordinate' do
  it 'initializes with an extended array' do
    array = [1, 2, 4, 6]
    c = Coordinate.new(*array)
    expect(c.x).to eql(1)
    expect(c.y).to eql(2)
    expect(c.z).to eql(4)
    expect(c.t).to eql(6)
  end
end

describe MazeInTime do
  it 'returns the right maze depending on the time' do
    rows = [
      [0, 0, 0, '*_***'],
      [0, 0, 1, '*__*_'],
      [0, 1, 0, '*****'],
      [0, 1, 1, '**__*'],
      [0, 2, 0, '*_***'],
      [0, 2, 1, '*__*_'],
      [1, 0, 0, '***_*'],
      [1, 0, 1, '**___'],
      [1, 1, 0, '*_***'],
      [1, 1, 1, '**_**'],
      [1, 2, 0, '__*_*'],
      [1, 2, 1, '__**_']
    ]
    expected = [
      '**********__',
      '__**__**_*__',
      '*_*_*_*_*_**',
      '***_**__**_*',
      '*_***_*_***_'
    ]
    mit = MazeInTime.new(Coordinate.new(2, 3, 2, 5))
    rows.each do |r|
      mit.add(Coordinate.new(r[0], r[1], r[2], 0), r[3])
    end
    expected.each_with_index do |e, i|
      expect(mit.maze(i).to_s).to eql(e)
    end
  end
end

describe Maze do
  it 'initializes with all space' do
    maze = Maze.new(Coordinate.new(2, 3, 4))
    2.times do |x|
      3.times do |y|
        4.times do |z|
          expect(maze.wall?(Coordinate.new(x, y, z))).to be_false
          expect(maze.space?(Coordinate.new(x, y, z))).to be_true
        end
      end
    end
  end

  it 'sets a wall into a coordinate' do
    maze = Maze.new(Coordinate.new(2, 3, 4))
    maze.wall(Coordinate.new(1,1,1))
    expect(maze.to_s).to eql('_________________*______')
    expect(maze.wall?(Coordinate.new(1,1,1))).to be_true
    expect(maze.space?(Coordinate.new(1,1,1))).to be_false
  end

  it 'shows the maze' do
    solver = MazeSolver.new(size, start, finish)
    rows.each do |r|
      solver.add_row(r[0], r[1], r[2], r[3])
    end

    solver.view
  end

end
