# frozen_string_literal: true

module Textalyze
	## Analyze a single sentence
	class Sentence
		class << self
			def regexps_cache
				@regexps_cache ||= {}
			end
		end

		def initialize(raw_sentence, without: [])
			@raw_sentence = without.reduce(raw_sentence) do |result, word|
				result.gsub word_regexp(word), ''
			end
			@alpha_size = @raw_sentence.scan(/[[:alpha:]]/).size
		end

		def match?(included:, excluded: [])
			included.all? { |words_with_spaces| words_with_spaces_match? words_with_spaces } &&
				excluded.none? { |words_with_spaces| words_with_spaces_match? words_with_spaces }
		end

		def capsed?(allowed_caps_percentage = 80)
			caps_proportion > allowed_caps_percentage / 100.0 && @alpha_size > 1
		end

		def words
			@words ||= @raw_sentence.scan(/[#{WORD_CHARS}]+/)
		end

		alias to_a words

		def question?
			@raw_sentence.include? '?'
		end

		private

		WORD_CHARS = "[:word:]'"
		private_constant :WORD_CHARS

		def words_with_spaces_match?(words_with_spaces)
			words_by_spaces = words_with_spaces.split(' ')
			words.each_cons(words_by_spaces.length).any? do |words_cons|
				matches = true
				words_by_spaces.each_with_index do |other_word, index|
					matches &&= other_word.casecmp?(words_cons[index])
					break unless matches
				end
				matches
			end
		end

		def word_regexp(word)
			self.class.regexps_cache[word] ||= /(^|[^#{WORD_CHARS}]+)#{word}([^#{WORD_CHARS}]+|$)/i
		end

		def caps_proportion
			@raw_sentence.scan(/[[:upper:]]/).size.to_f / @alpha_size
		end
	end
end
