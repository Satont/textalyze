# frozen_string_literal: true

require 'unicode/emoji'

require_relative 'sentence'

module Textalyze
	## Analyze text with multiple sentences
	class Text
		emojis = (
			Unicode::Emoji::LIST.values.map(&:values).flatten.join.split('').uniq - ('0'..'9').to_a
		).freeze

		sentences_delimiters = ".?!#{emojis.join}"
		SENTENCES_SPLIT_REGEXP = /([^#{sentences_delimiters}]+[#{sentences_delimiters}]+)\s*/x.freeze

		attr_reader :raw_sentences

		def initialize(text, *args, **kwargs)
			@raw_sentences = text.scan(/([^.?!]+[.?!]+)\s*/).flatten

			@sentences = @raw_sentences.map do |raw_sentence|
				Sentence.new raw_sentence, *args, **kwargs
			end
		end

		%w[match? capsed?].each do |method_name|
			define_method method_name do |*args, **kwargs|
				@sentences.any? do |sentence|
					sentence.public_send method_name, *args, **kwargs
				end
			end
		end
	end
end
