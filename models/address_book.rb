require_relative 'entry'
require 'csv'

class AddressBook
    attr_reader :entries

    def initialize
        @entries = []
    end

    def add_entry(name, phone_number, email)
        index = 0
        entries.each do |entry|
            if name < entry.name
                break
            end
            index += 1
        end
        entries.insert(index, Entry.new(name, phone_number, email))
    end

    def remove_entry(name, phone_number, email)
        index = 0
        entries.each do |entry|
            if entry.name != "#{name}"
                index += 1
                break
            end
            if entry.phone_number != "#{phone_number}"
                index += 1
                break
            end
            if entry.email != "#{email}"
                index += 1
                break
            end
            entries.delete_at(index)
        end
    end

    def import_from_csv(file_name)
        csv_text = File.read(file_name)
        csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
        csv.each do |row|
            row_hash = row.to_hash
            add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
        end
    end
end
