# frozen_string_literal: true

describe Textalyze::Text do
	subject(:text) { described_class.new(raw_text, without: without) }

	let(:without) { [] }

	describe '#raw_sentences' do
		subject { super().raw_sentences }

		let(:raw_text) do
			"Hello! My name is Alexander. I'm here to ask you: how are you? He-he!!! Stop; how??!!"
		end

		let(:expected_result) do
			[
				'Hello!',
				'My name is Alexander.',
				"I'm here to ask you: how are you?",
				'He-he!!!',
				'Stop; how??!!'
			]
		end

		it { is_expected.to eq expected_result }
	end

	describe '#match?' do
		subject { super().match?(included: included, excluded: excluded) }

		let(:included) { %w[hello dear friend] }
		let(:excluded) { [] }

		context 'when text contains all included words in a single sentence' do
			let(:raw_text) { 'Hello there, dear friend. How are you?' }

			it { is_expected.to be true }
		end

		context 'when text contains all included words in different sentences' do
			let(:raw_text) { 'Hello there, friend. How are you, dear?' }

			it { is_expected.to be false }
		end

		context 'when text contains one of excluded words in a sentence with all included words' do
			let(:excluded) { %w[bad ass] }

			let(:raw_text) { 'Hello there, bad dear friend. How are you?' }

			it { is_expected.to be false }
		end
	end

	describe '#capsed?' do
		subject { super().capsed?(*args) }

		context 'with default allowed caps percentage' do
			let(:args) { [] }

			context 'when one of sentences is almost completely capsed' do
				let(:raw_text) { "HELLO, FRIEnd! how are you? i'm ok." }

				it { is_expected.to be true }
			end

			context 'when none of sentences is capsed enough' do
				let(:raw_text) { "It's YAML. That's ALL. Did you HEAR ME?" }

				it { is_expected.to be false }
			end

			context 'with known abbreviations' do
				let(:without) { %w[YAML XML HTML] }
				let(:raw_text) { 'Use YAML. HTML. XML.' }

				it { is_expected.to be false }
			end
		end

		context 'with 0% of allowed caps' do
			let(:args) { [0] }

			context 'when there is only one letter in one sentence in upper register' do
				let(:raw_text) { "Hello, friend! how are you? i'm ok." }

				it { is_expected.to be true }
			end

			context 'when all letters in all sentences in lower register' do
				let(:raw_text) { "hello, friend! how are you? i'm ok." }

				it { is_expected.to be false }
			end
		end

		context 'with 50% of allowed caps' do
			let(:args) { [50] }

			context 'when there is a bit more capsed than half in one sentence' do
				let(:raw_text) { "HELLO, Friend! how are you? i'm ok." }

				it { is_expected.to be true }
			end

			context 'when there is exactly a capsed half of text' do
				let(:raw_text) { "HEY, boy! HOW you? i'm OK." }

				it { is_expected.to be false }
			end

			context 'when there is a bit less capsed than half in all sentences' do
				let(:raw_text) { "HELLO, friend! HOW are you? i'm OK." }

				it { is_expected.to be false }
			end
		end

		context 'with 100% of allowed caps' do
			let(:args) { [100] }

			context 'when there is a complete capsed text' do
				let(:raw_text) { "HELLO, DEAR FRIEND! HOW ARE YOU? I'M OK." }

				it { is_expected.to be false }
			end
		end
	end
end
