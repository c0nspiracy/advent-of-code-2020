# frozen_string_literal: true

# Models a 3D game of life
class Life3D
  def initialize(size)
    @z_range = 0..0
    @y_range = 0...size
    @x_range = 0...size
  end

  def each_cube
    return enum_for(:each_cube) unless block_given?

    @z_range.each do |z|
      @y_range.each do |y|
        @x_range.each do |x|
          yield z, y, x
        end
      end
    end
  end

  def expand_universe
    @z_range = expand_dimension(@z_range)
    @y_range = expand_dimension(@y_range)
    @x_range = expand_dimension(@x_range)
  end

  private

  def expand_dimension(range)
    Range.new(range.begin - 1, range.end + 1)
  end
end
