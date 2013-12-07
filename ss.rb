#!/usr/bin/env ruby

require 'pp'

class SecretSanta
    attr_accessor :names

    def initialize(names = nil, options = {} )
        @names = names
        @pairs = nil
        @debug = options[:debug]
        
        #if @names
        #    @pairs = pair
        #end
        #pp @pairs
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
    ss1.pair

    puts "Test 2: one name"
    ss2 = SecretSanta.new([names.last], opts)
    ss2.pair

    puts "Test 3: only duplicates"
    ss3 = SecretSanta.new(names[2,4], opts)
    ss3.pair

    puts "Test 4: some duplicates"
    ss4 = SecretSanta.new(names, opts)
    ss4.pair

    puts "Test 5: no names"
    ss5 = SecretSanta.new(names[names.size+1], opts)
    ss5.pair
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
    testing
end
