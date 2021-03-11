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

  def self.cities
    response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome')

    return [] if response.status == 403

    json_response = JSON.parse(response.body, symbolize_names: true)
    cities = []
    json_response.each do |r|
      cities << District.new(id: r[:id], nome: r[:nome], sigla: r[:sigla])
    end

    cities
  end

  # def self.save
  #   url = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome'
  #   resp = Faraday.post(url, '{"sigla": "SP"}', "Content-Type": "application/json")
  #   return true if resp.status == 200
  #   false
  # end
end
