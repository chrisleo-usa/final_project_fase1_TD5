require 'rails_helper'

describe District do
  context 'PORO' do
    it 'should initialize a new payment method' do
      state = District.new(id: '10', sigla: 'SC')

      expect(state.id).to eq('10')
      expect(state.sigla).to eq('SC')
    end
  end

  context 'fetch API data' do
    it 'should get all states' do
      # MOCK
      resp_json = File.read(Rails.root.join('spec/support/apis/get_states.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json)
      allow(Faraday).to receive(:get).with('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
                                     .and_return(resp_double)

      states = District.states

      expect(states.length).to eq(27)
    end

    it 'should return empty if not authorized' do
      # MOCK
      resp_double = double('faraday_response', status: 403, body: '')
      allow(Faraday).to receive(:get).with('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
                                     .and_return(resp_double)

      states = District.states

      expect(states.length).to eq(0)
    end
  end
end
