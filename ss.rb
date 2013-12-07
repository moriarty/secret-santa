#!/usr/bin/env ruby

require 'pp'

class SecretSanta
    attr_accessor :names

    def initialize(names = nil, options = {} )
        @names = names
        @pairs = nil
        @debug = options[:debug]
        
        if @names
            @pairs = pair
        end
    end
    
    def pairs
        @pairs
    end

    def pair
        if @names.nil?
            if @debug            
                puts "no names in list to pair."
            end
            return nil
        elsif @names.respond_to?("join") && @names.uniq.size != 1
            h = Hash.new {|hash, key| hash[key] = nil }
            uniq_names = @names.uniq.shuffle
            uniq_names.shuffle.each do |name|
                h[name]
            end
            if h.keys.first == uniq_names.last
                uniq_names.push(uniq_names.shift)
            end
            if h.keys.last == uniq_names.first
                uniq_names.push(uniq_names.shift)
            end
            
            h.keys.each do |key|
                if key == uniq_names.last
                    uniq_names.push(uniq_names.shift)
                    h[key] = uniq_names.pop
                else
                    h[key] = uniq_names.pop
                end
            end
            if @debug
                puts "pair called and names is a list"
                puts "The names are #{@names.join(", ")}."
                if @names.size != @names.uniq.size
                    puts "Non unique names were removed."
                end
            end
            return h
        else
            if @debug
                puts "secret santa isn't fun alone."
                puts "please provide a list of names."
                if @names.size > 1
                    puts "duplicate names are only counted once."
                end
            end
            return nil
        end
    end
end

def test_cases
    opts = { :debug => true }
    names = ["rubi", "miri", "max", "max"]

    puts "Test 1: list of names"
    ss1 = SecretSanta.new(names[0,3], opts)
    pp ss1.pairs

    puts "Test 2: one name"
    ss2 = SecretSanta.new([names.last], opts)
    pp ss2.pairs

    puts "Test 3: only duplicates"
    ss3 = SecretSanta.new(names[2,4], opts)
    pp ss3.pairs

    puts "Test 4: some duplicates"
    ss4 = SecretSanta.new(names, opts)
    pp ss4.pairs

    puts "Test 5: no names"
    ss5 = SecretSanta.new(names[names.size+1], opts)
    pp ss5.pairs
end 

def testing
    opts = {}
    names = ["rubi", "miri", "max", "lisa", "felix"]
    ss = SecretSanta.new(names, opts)
    
    (0...10).each do |num|
        print "run #", num, "\n"
        pp ss.pair
    end
    
end

if __FILE__ == $0
    if ARGV.size == 0
        print "usage: ", $0, " [namesfile | name1 name2 name3]\name3"
    elsif ARGV.size == 1
        print "reading the names from file\n"
        file = File.open(ARGV[0], "r")
        names = file.readlines.map(&:chomp)
        names = names.select{|name| name != ""}
        ss = SecretSanta.new(names)
        pp ss.pairs
    else
        print "reading the names from command line\n"
        ss = SecretSanta.new(ARGV)
        pp ss.pairs
    end
end
