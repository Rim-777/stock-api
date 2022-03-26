# frozen_string_literal: true

shared_examples 'contracts/invalid_entity_attributes' do
  context 'invalid value' do
    let(:expected_message) do
      { key => ['must be a hash'] }
    end

    context 'invalid type' do
      before do
        params[key] = []
      end

      it_behaves_like 'contracts/invalid_attribute'
    end

    context 'nil' do
      before do
        params[key] = nil
      end

      it_behaves_like 'contracts/invalid_attribute'
    end
  end

  context '/name' do
    let(:sub_key) { :name }

    context 'missing key' do
      before do
        params[key].delete(sub_key)
      end

      let(:expected_message) do
        { key => { sub_key => ['is missing'] } }
      end

      it_behaves_like 'contracts/invalid_attribute'
    end

    context 'invalid value' do
      context 'empty' do
        before do
          params[key][sub_key] = ''
        end

        let(:expected_message) do
          { key => { sub_key => ['must be filled'] } }
        end

        it_behaves_like 'contracts/invalid_attribute'
      end

      context 'nil' do
        before do
          params[key][sub_key] = nil
        end

        let(:expected_message) do
          { key => { sub_key => ['must be a string'] } }
        end

        it_behaves_like 'contracts/invalid_attribute'
      end
    end
  end
end
