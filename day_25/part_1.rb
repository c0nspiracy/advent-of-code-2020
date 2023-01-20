# frozen_string_literal: true

class Crypt
  DIVISOR = 20_201_227

  def initialize(subject_number)
    @subject_number = subject_number
    @cache = { 0 => 1 }
  end

  def transform_subject_number(loop_size)
    return @cache[loop_size] if @cache.key?(loop_size)

    warm_cache(loop_size + 100_000) if @cache.keys.max < loop_size

    v = transform_subject_number(loop_size - 1)
    @cache[loop_size] = transform(v)
  end

  private

  def transform(n)
    (n * @subject_number).remainder(DIVISOR)
  end

  def warm_cache(loop_size)
    max_cached = @cache.keys.max
    return if max_cached >= loop_size

    v = @cache[max_cached]
    ((max_cached + 1)...loop_size).each do |n|
      v = transform(v)
      @cache[n] = v
    end
  end
end

input = ARGF.readlines(chomp: true)
card_key, door_key = input.map(&:to_i)

crypt_7 = Crypt.new(7)
door_secret_loop_size = (1..).find { |n| crypt_7.transform_subject_number(n) == door_key }

crypt_card = Crypt.new(card_key)
puts crypt_card.transform_subject_number(door_secret_loop_size)
