class District
  attr_reader :id, :sigla

  def initialize(id:, sigla:)
    @id = id
    @sigla = sigla
  end

  def self.states
    response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')

    return [] if response.status == 403

    json_response = JSON.parse(response.body, symbolize_names: true)
    states = []
    json_response.each do |r|
      states << District.new(id: r[:id], sigla: r[:sigla])
    end

    states
  end
end
