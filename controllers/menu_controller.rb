require_relative '../models/address_book'

class MenuController
    attr_reader :address_book

    def initialize
        @address_book = AddressBook.new
    end

    def main_menu
        puts "Main Menu - #{address_book.entries.count} entries"
        puts "1 - View all entries"
        puts "2 - View entry by record number"
        puts "3 - Create an entry"
        puts "4 = Search for an entry"
        puts "5 - Import entries from a CSV"
        puts "6 - Delete all entries"
        puts "7 - Exit"
        puts "\n"
        print "Enter your selection: "

        selection = gets.to_i

        case selection
            when 1
                system "clear"
                view_all_entries
                main_menu
            when 2
                system "clear"
                view_entry_number
                main_menu
            when 3
                system "clear"
                create_entry
                main_menu
            when 4
                system "clear"
                search_entries
                main_menu
            when 5
                system "clear"
                read_csv
                main_menu
            when 6
                system "clear"
                nuke_it_all
                main_menu
            when 7
                puts "Good-bye!"
                exit(0)
            else
                system "clear"
                puts "Sorry, \"#{selection}\" is not a valid input.\n\n"
                main_menu
        end
    end
    def view_all_entries
        if address_book.entries.count == 0
            puts "There are no address records\n\n"
            main_menu
        else
            address_book.entries.each do |entry|
                system "clear"
                puts entry.to_s + "\n\n"
                entry_submenu(entry)
            end
        end

        system "clear"
        puts "End of entries\n\n"
    end

    def view_entry_number
        if address_book.entries.count == 0
            puts "There are no address records\n\n"
            main_menu
        else
            print "Enter record number from 1 - #{address_book.entries.count}: "
            selection = gets.chomp.to_i
            system "clear"
            if address_book.entries.size < selection || selection <= 0
                puts "Sorry, that is not a valid record.\n\n"
                main_menu
            end
            puts address_book.entries[selection-1].to_s + "\n\n"
        end
    end

    def create_entry
        system "clear"
        puts "New AddressBloc Entry\n\n"
        print "Name: "
        name = gets.chomp
        print "Phone number: "
        phone = gets.chomp
        print "Email: "
        email = gets.chomp

        address_book.add_entry(name, phone, email)

        system "clear"
        puts "New entry created!\n\n"
    end

    def delete_entry(entry)
        address_book.entries.delete(entry)
        puts "\"#{entry.name}\" has been deleted\n\n"
    end

    def nuke_it_all
        if address_book.entries.count == 0
            puts "There are no address records\n\n"
            main_menu
        else
            print "Type \"yes\" to delete all entries from the address book. "
            selection = gets.chomp.downcase
            system "clear"
            if selection == "yes"
                address_book.nuke
                puts "All entries have been deleted\n\n"
            else
                puts "No entries were deleted\n\n"
            end
        end
    end

    def edit_entry(entry)
        print "\nUpdated name: "
        name = gets.chomp
        print "Updated phone number: "
        phone_number = gets.chomp
        print "Updated email: "
        email = gets.chomp

        entry.name = name if !name.empty?
        entry.phone_number = phone_number if !phone_number.empty?
        entry.email = email if !email.empty?
        system "clear"
        puts "Updated entry:"
        puts entry
    end

    def search_entries
        if address_book.entries.count == 0
            puts "There are no address records\n\n"
            main_menu
        else
            print "Search by name: "
            name = gets.chomp
            match = address_book.binary_search(name)
            system "clear"
            if match
                puts match.to_s
                search_submenu(match)
            else
                puts "No match found for \"#{name}\"\n\n"
            end
        end
    end

    def search_submenu(entry)
        puts "\nd - delete entry"
        puts "e - edit this entry"
        puts "m - return to main menu"
        selection = gets.chomp

        case selection
            when "d"
                system "clear"
                delete_entry(entry)
                main_menu
            when "e"
                edit_entry(entry)
                system "clear"
                main_menu
            when "m"
                system "clear"
                main_menu
            else
                system "clear"
                puts "\"#{selection}\" is not a valid input\n\n"
                puts entry.to_s
                search_submenu(entry)
        end
    end

    def read_csv
        print "Enter CSV file to import: "
        file_name = gets.chomp
        system "clear"

        if file_name.empty?
            puts "No CSV file read\n\n"
            main_menu
        end

        begin
            entry_count = address_book.import_from_csv(file_name).count
            puts "#{entry_count} new entries added from #{file_name}\n\n"
        rescue
            puts "\"#{file_name}\" is not a valid CSV file. Please enter the name of a valid CSV file.\n\n"
            read_csv
        end
    end

    def entry_submenu(entry)
        puts "n - next entry"
        puts "d - delete entry"
        puts "e - edit this entry"
        puts "m - return to main menu"

        selection = gets.chomp

        case selection
            when "n"
            when "d"
                delete_entry(entry)
            when "e"
                edit_entry(entry)
            when "m"
                system "clear"
                main_menu
            else
                puts "\n\"#{selection}\" is not a valid input.\n\n"
                entry_submenu(entry)
        end
    end
end
