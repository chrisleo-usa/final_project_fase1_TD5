class District
  attr_reader :id, :sigla, :nome

  def initialize(id:, sigla:, nome:)
    @id = id
    @sigla = sigla
    @nome = nome
  end

  def self.states
    response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')

    return [] if response.status == 403

    json_response = JSON.parse(response.body, symbolize_names: true)
    states = []
    json_response.each do |r|
      states << District.new(id: r[:id], sigla: r[:sigla], nome: r[:nome])
    end

    states
  end
end
