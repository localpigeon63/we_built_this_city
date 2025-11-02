require 'json'
require 'csv'

conf = JSON.parse(File.read("#{ARGV[0]}/config.json"))

settlement_type = conf['settlement_type']
races = conf['races']
classes = conf['classes']
professions = conf['professions']
backgrounds = conf['backgrounds']
level_range = ((conf['level_range'][0])..(conf['level_range'][1])).to_a
genders = conf['genders']

settlement_population_range = {
    "hamlet" => 10..30,
    "village" => 25..300,
    "town" => 250..5000,
    "city" => 4000..50_000,
    "metropolis" => 50_000..300_000
}

settlement_size = settlement_population_range[settlement_type].to_a.shuffle.first

def exponential_pick(level_range, lambda:)
  raise ArgumentError, "lambda must be positive" if lambda <= 0

  n = level_range.size
  u = rand # uniform in [0, 1)
  x = -Math.log(1 - u) / lambda  # exponential random variable

  # Map x to array index space (decay toward 0)
  idx = (x * n).to_i
  idx = 0 if idx >= n # clamp to first index

  level_range[idx]
end


headers = ['race', 'class', 'profession', 'background', 'level', 'gender']
CSV.open('Roma/population.csv', 'w', write_headers:true, headers: headers) do |csv|
    settlement_size.times do
        race = races.shuffle.first
        clss = classes.shuffle.first
        if clss == "commoner"
            profession = professions.shuffle.first
        else
            profession = "N/A"
        end
        background = backgrounds.shuffle.first
        level = exponential_pick(level_range, lambda: 12)
        gender = genders.shuffle.first
        csv << [race, clss, profession, background, level, gender]
    end
end

puts 'written to Roma/population.csv'