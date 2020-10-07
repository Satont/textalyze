# frozen_string_literal: true

describe Textalyze::Sentence do
	subject(:sentence) { described_class.new(raw_sentence, without: without) }

	let(:without) { [] }

	describe '#match?' do
		subject { super().match?(included: included, excluded: excluded) }

		let(:included) { %w[hello dear friend] }
		let(:excluded) { [] }

		context 'when sentence contains all included words' do
			let(:raw_sentence) { 'Hello there, dear friend.' }

			it { is_expected.to be true }
		end

		context 'when sentence contains not all included words' do
			let(:raw_sentence) { 'Hello, dear.' }

			it { is_expected.to be false }
		end

		context 'when some of included words with spaces' do
			let(:included) { ['hello', 'dear friend'] }

			context 'when there are space-separated words from included in the same order' do
				let(:raw_sentence) { 'Hello, dear friend' }

				it { is_expected.to be true }
			end

			context 'when there is an extra word between space-separated words from included' do
				let(:raw_sentence) { 'Hello, dear my friend' }

				it { is_expected.to be false }
			end
		end

		context 'when sentence contains one of excluded words' do
			let(:excluded) { %w[bad ass] }

			let(:raw_sentence) { 'Hello, dear bad friend.' }

			it { is_expected.to be false }
		end

		context 'when some of excluded words with spaces' do
			let(:excluded) { ['shit', 'bad ass'] }

			context 'when there are space-separated words from excluded in the same order' do
				let(:raw_sentence) { 'Hello, dear friend, bad ass' }

				it { is_expected.to be false }
			end

			context 'when there is an extra word between space-separated words from excluded' do
				let(:raw_sentence) { 'Hello, dear friend, bad my ass' }

				it { is_expected.to be true }
			end
		end
	end

	describe '#capsed?' do
		subject { super().capsed?(*args) }

		context 'with default allowed caps percentage' do
			let(:args) { [] }

			context 'when it is almost completely capsed' do
				let(:raw_sentence) { 'HELLO, FRIEnd!' }

				it { is_expected.to be true }
			end

			context 'when it is not so capsed' do
				let(:raw_sentence) { "It's YAML." }

				it { is_expected.to be false }
			end

			context 'with known abbreviations' do
				let(:without) { %w[YAML XML HTML] }
				let(:raw_sentence) { 'Use YAML, HTML, XML' }

				it { is_expected.to be false }
			end
		end

		context 'with 0% of allowed caps' do
			let(:args) { [0] }

			context 'when there is only one letter in upper register' do
				let(:raw_sentence) { 'Hello, friend!' }

				it { is_expected.to be true }
			end

			context 'when all letters in lower register' do
				let(:raw_sentence) { 'hello.' }

				it { is_expected.to be false }
			end
		end

		context 'with 50% of allowed caps' do
			let(:args) { [50] }

			context 'when there is a bit more capsed than half' do
				let(:raw_sentence) { 'HELLO, Friend!' }

				it { is_expected.to be true }
			end

			context 'when there is exactly a capsed half of text' do
				let(:raw_sentence) { 'HEY, boy!' }

				it { is_expected.to be false }
			end

			context 'when there is a bit less capsed than half' do
				let(:raw_sentence) { 'HELLO, friend!' }

				it { is_expected.to be false }
			end
		end

		context 'with 100% of allowed caps' do
			let(:args) { [100] }

			context 'when there is a complete capsed text' do
				let(:raw_sentence) { 'HELLO, DEAR FRIEND!' }

				it { is_expected.to be false }
			end
		end
	end

	shared_examples 'correct words splitting' do
		let(:raw_sentence) { "Hello, dear; I'm here to ask: how are you?" }

		it { is_expected.to eq %w[Hello dear I'm here to ask how are you] }
	end

	describe '#words' do
		subject { super().words }

		include_examples 'correct words splitting'
	end

	describe '#to_a' do
		subject { super().to_a }

		include_examples 'correct words splitting'
	end

	describe '#question?' do
		subject { super().question? }

		context 'when it is' do
			let(:raw_sentence) { "Hello, dear; I'm here to ask: how are you?" }

			it { is_expected.to be true }

			context 'with additional chars' do
				let(:raw_sentence) { "Hello, dear; I'm here to ask: how are you?!!" }

				it { is_expected.to be true }
			end
		end

		context 'when it is not' do
			let(:raw_sentence) { "Hello, dear; I'm here to ask: how are you." }

			it { is_expected.to be false }
		end
	end
end
