def unquote(str)
  result = str.strip
  result = result[1..-2]  if result.match?(/^".*"$/)
  result = result.gsub(/""/, '"')
  result.strip
end

def value_by_id(filename)
  File.readlines(filename).drop(1).map{|line|
    id, value = line.chomp.split(';', 2)
    [id, unquote(value)]
  }.to_h
end

def row_by_id(filename, col_num)
  File.readlines(filename).drop(1).map{|line|
    id, *rest = line.chomp.split(';', col_num)
    [id, rest.map{|value| unquote(value) }]
  }.to_h
end

def getDay(coded_date)
  result = coded_date & 0b11111
  result != 0 ? result : nil
end

def getMonth(coded_date)
  result = (coded_date >> 5) & 0b1111
  result != 0 ? result : nil
end

def getYear(coded_date)
  result = (coded_date >> 9)
  result != 0 ? (result + 1800) : nil
end

def decode_date(coded_date)
  day = getDay(coded_date)
  month = getMonth(coded_date)
  year = getYear(coded_date)
  if day || month || year
    [day, month, year].map{|x| x || '_' }.join('.')
  else
    nil
  end
end


supplementary_table_names = ['fnames', 'names', 'lnames', 'nations', 'geoplace', 'works', 'sudorg', 'stat', 'prigovor',
  'fams', 'educat', 'arestorg', 'aresttyp', 'poddan', 'parties', 'delos', 'mortplac', 'birthyear', 'ages',
  'reaborg', 'reabreas', 'reprprev', 'reprnext'
]
link_table_names = ['fams', 'educat', 'arestorg', 'aresttyp', 'poddan', 'party', 'delo', 'mortplace',
                    'reaborg', 'reabreas', 'reprprev', 'reprnext', 'varfio', 'birthye']

supplementary = supplementary_table_names.map{|table_name|
  [table_name.to_sym, value_by_id("csv/#{table_name}.csv")]
}.to_h

link_tables = link_table_names.map{|table_name|
  [table_name.to_sym, value_by_id("csv/link#{table_name}.csv")]
}.to_h

books = row_by_id('csv/books.csv', 3)
varnames = row_by_id('csv/varnames.csv', 6)

data_from_linked_table = ->(supplementary_table_name, link_name, person_id){
  resource_id = link_tables[link_name][person_id]
  resource_id && supplementary[supplementary_table_name][resource_id]
}

COL_ORDER = [:person_id, :surname, :name, :patronimic, :birth_year, :birth_year_comment, :age, :sex,
  :birth_place, :nation, :citizenship, :occupation, :live_place, :education, :party, :family,
  :arest_date, :arest_organ, :arest_type,
  :criminal_case, :judicial_organ, :process_date, :criminal_article, :sentence,
  :was_executed, :death_place, :death_date,
  :previous_repression, :next_repression,
  :rehabilitation_organ, :rehabilitation_reason, :rehabilitation_date, 
  :all_name_variations, :name_variations, :surname_variations,
  :patronimic_variations, :fullname_variations,
  :memory_book, :memory_book_url,
]

puts COL_ORDER.join("\t")

File.open('csv/persons.csv') do |f|
  f.readline # drop header
  f.each_line.lazy.map{|line|
    line.chomp.split(";", 20).map(&:strip)
  }.map{|row|
    person_id, fname_id, name_id, lname_id = *row.shift(4)
    birthdate_coded, birthplace_id, nation_id, work_id, liveplace_id = *row.shift(5)
    arestdate_coded, sudorgan_id, suddate_coded, statya_id, prigovor_id = *row.shift(5)
    rasstrel, mortdate_coded, reabdate_coded, book_id, age_id, sex = *row

    varfio_id = link_tables[:varfio][person_id]
    name_variations_fields = varfio_id && varnames[varfio_id]

    {
      person_id: person_id,
      surname: supplementary[:fnames][fname_id],
      name: supplementary[:names][name_id],
      patronimic: supplementary[:lnames][lname_id],
      nation: supplementary[:nations][nation_id],
      birth_place: supplementary[:geoplace][birthplace_id],
      live_place: supplementary[:geoplace][liveplace_id],
      occupation: supplementary[:works][work_id],
      judicial_organ: supplementary[:sudorg][sudorgan_id],
      criminal_article: supplementary[:stat][statya_id],
      sentence: supplementary[:prigovor][prigovor_id],
      was_executed: rasstrel.upcase,
      memory_book: books[book_id][0],
      memory_book_url: books[book_id][1],
      age: supplementary[:ages][age_id],
      sex: sex.downcase,

      family: data_from_linked_table.(:fams, :fams, person_id),
      education: data_from_linked_table.(:educat, :educat, person_id),
      arest_organ: data_from_linked_table.(:arestorg, :arestorg, person_id),
      arest_type: data_from_linked_table.(:aresttyp, :aresttyp, person_id),
      citizenship: data_from_linked_table.(:poddan, :poddan, person_id),
      party: data_from_linked_table.(:parties, :party, person_id),
      rehabilitation_organ: data_from_linked_table.(:reaborg, :reaborg, person_id),
      rehabilitation_reason: data_from_linked_table.(:reabreas, :reabreas, person_id),
      previous_repression: data_from_linked_table.(:reprprev, :reprprev, person_id),
      next_repression: data_from_linked_table.(:reprnext, :reprnext, person_id),
      birth_year_comment: data_from_linked_table.(:birthyear, :birthye, person_id),
      criminal_case: data_from_linked_table.(:delos, :delo, person_id),
      death_place: data_from_linked_table.(:mortplac, :mortplace, person_id),

      birth_year: getYear(Integer(birthdate_coded))&.to_s, # No birthdate has precision more than year
      arest_date: decode_date(Integer(arestdate_coded)),
      process_date: decode_date(Integer(suddate_coded)),
      death_date: decode_date(Integer(mortdate_coded)),
      rehabilitation_date: decode_date(Integer(reabdate_coded)),

      all_name_variations: name_variations_fields && name_variations_fields[0],
      name_variations: name_variations_fields && name_variations_fields[1],
      surname_variations: name_variations_fields && name_variations_fields[2],
      patronimic_variations: name_variations_fields && name_variations_fields[3],
      fullname_variations: name_variations_fields && name_variations_fields[4],
    }
  }.map{|infos|
    COL_ORDER.map{|col_name|
      val = infos.fetch(col_name)
      (val && !val.empty?) ? val : 'None'
    }
  }.each{|row|
    puts row.join("\t")
  }
end
