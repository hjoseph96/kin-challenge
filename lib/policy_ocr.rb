require 'pry'
module PolicyOcr

  @file = File.readlines("./spec/fixtures/sample.txt").map(&:chomp)
  @lines = @file.size / 4
  @max_chars = @file[0].size

  # Prioritizing readability
  def self.ascii_to_i
    {
      [
        ' _ ',
        '| |',
        '|_|',
        '   '
      ].join => '0',
      [
        '   ',
        '  |',
        '  |',
        '   '
      ].join => '1',
      [
        ' _ ',
        ' _|',
        '|_ ',
        '   '
      ].join => '2',
      [
        ' _ ',
        ' _|',
        ' _|',
        '   '
      ].join => '3',
      [
        '   ',
        '|_|',
        '  |',
        '   '
      ].join => '4',
      [
        ' _ ',
        '|_ ',
        ' _|',
        '   '
      ].join => '5',
      [
        ' _ ',
        '|_ ',
        '|_|',
        '   '
      ].join => '6',
      [
        ' _ ',
        '  |',
        '  |',
        '   '
      ].join => '7',
      [
        ' _ ',
        '|_|',
        '|_|',
        '   '
      ].join => '8',
      [
        ' _ ',
        '|_|',
        ' _|',
        '   '
      ].join => '9'
    }
  end

  def self.ascii_to_digits
    ranges = (0..@max_chars - 1).each_slice(3).to_a

    # Go by each line of digits
    @file.each_slice(4).map do |policy_number|
      ranges.inject('') do |parsed_number , digit_range|
        ascii_digit = policy_number.inject('') {|digit, str| digit << str[digit_range.first..digit_range.last]}

        parsed_number << ascii_to_i[ascii_digit]
      end
    end
  end

  def self.validate_policy_numbers
    policy_numbers = ascii_to_digits
    policy_numbers.map do |p|
      d9, d8, d7, d6, d5, d4, d3, d2, d1 = p.split('').map(&:to_i)

      is_valid = (d1 + (2 * d2) + (3 * d3) + (4 * d4) + (5 * d5) + (6 * d6) + (7 * d7) + (8 * d8) + (9 * d9)) % 11 == 0

      { policy_number: p, valid: is_valid }
    end
  end
end
