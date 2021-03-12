FactoryBot.define do
  factory :company do
    name { 'Campus Code' }
    cnpj { '012_345_678_910_11' }
    address { 'Rua São Paulo' }
    complement { 'nº 222, sala 700' }
    city { 'São Paulo' }
    state { 'SP' }
    site { 'www.campuscode.com.br' }
    social_media { 'www.linkedin/in/campuscode' }
    domain { 'campuscode' }
  end
end
