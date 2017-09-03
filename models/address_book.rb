require_relative 'entry'

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
end
