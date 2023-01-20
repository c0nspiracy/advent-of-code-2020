# frozen_string_literal: false

rule_lines, strings = ARGF.readlines("\n\n", chomp: true).map { |blob| blob.lines(chomp: true) }

rules = rule_lines.each_with_object({}) do |line, memo|
  index, rule = line.split(": ")
  memo[index] = rule
end

def full_line_regex_for(index, pattern, patterns)
  Regexp.new(/^#{regex_for(index, pattern, patterns)}$/)
end

def regex_for(index, pattern, patterns)
  pattern = patterns[index] if index

  case pattern
  when /(\d+) \| \1 #{index}/
    re = regex_for(Regexp.last_match[1], nil, patterns)
    /(#{re})+/
    # Regexp.new("#{re}+")
    # "(#{re}+)"
  when /(\d+) (\d+) \| \1 #{index} \2/
    re1 = regex_for(Regexp.last_match[1], nil, patterns)
    re2 = regex_for(Regexp.last_match[2], nil, patterns)
    /(?<e>#{re1}\g<e>*#{re2})+/
    # "(?<group>#{re1}(\\g<group>*)#{re2})"
  when /\|/
    alt1, alt2 = pattern.split(" | ")
    Regexp.union(regex_for(nil, alt1, patterns), regex_for(nil, alt2, patterns))
    # "(" + [regex_for(nil, alt1, patterns), regex_for(nil, alt2, patterns)].join("|") + ")"
  when /\d+/
    #puts pattern
    Regexp.new(pattern.scan(/\d+/).map { |n| "(#{regex_for(n, nil, patterns)})" }.join)
    # "(" + pattern.scan(/\d+/).map { |n| regex_for(n, nil, patterns) }.join + ")"
  when /"(\w)"/
    Regexp.new(Regexp.last_match[1])
    # pattern.scan(/\w/).first
  end
end

#rules["8"] = "42+"
#rules["11"] = "(?<e>42 \\g<e>* 31)*"
# 8: 42 | 42 8
# 11: 42 31 | 42 11 31
rules["8"] = "42 | 42 908"
rules["908"] = "42 | 42 909"
rules["909"] = "42 | 42 910"
rules["910"] = "42 | 42 911"
rules["911"] = "42 | 42 912"
rules["912"] = "42 | 42 913"
rules["913"] = "42 | 42 914"
rules["914"] = "42 | 42 915"
rules["915"] = "42 | 42 916"
rules["916"] = "42"

rules["11"] = "42 31 | 42 1011 31"
rules["1011"] = "42 31 | 42 1012 31"
rules["1012"] = "42 31 | 42 1013 31"
rules["1013"] = "42 31 | 42 1014 31"
rules["1014"] = "42 31 | 42 1015 31"
rules["1015"] = "42 31 | 42 1016 31"
rules["1016"] = "42 31 | 42 1017 31"
rules["1017"] = "42 31 | 42 1018 31"
rules["1018"] = "42 31 | 42 1019 31"
rules["1019"] = "42 31 | 42 1020 31"
rules["1020"] = "42 31"
pattern = "^#{rules['0']}$"
loop do
  nums = pattern.scan(/\d+/)
  break if nums.empty?

  nums.each { |num| pattern.gsub!(/\b#{num}\b/, "(#{rules[num]})") }
end
pattern.gsub!(/[" ]/, "")
pattern = /#{pattern}/
puts pattern
c = strings.count { |string| string.match?(pattern) }
puts c

# patterns["8"] = "42 | 42 8"
# patterns["11"] = "42 31 | 42 11 31"
# re = full_line_regex_for("0", nil, patterns)
# puts re.inspect
# c = strings.reject(&:empty?).count { |s| s.match? /#{re}/ }
# puts c
