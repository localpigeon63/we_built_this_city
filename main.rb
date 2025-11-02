require 'json'
require 'csv'

puts "hello, world"

conf = JSON.parse(File.read('Roma/config.json'))

pp conf

settlement_type = conf['settlement_type']
races = conf['races']
classes = conf['classes']
professions = conf['professions']

settlement_population_range = {
    "hamlet" => 10..30
}

settlement_size = settlement_population_range[settlement_type].to_a.shuffle.first

headers = ['race', 'class', 'profession']
CSV.open('Roma/population.csv', 'w', write_headers:true, headers: headers) do |csv|
    settlement_size.times do
        row = [races.shuffle.first, classes.shuffle.first, professions.shuffle.first]
        csv << row
    end
end

puts 'written to Roma/population.csv'