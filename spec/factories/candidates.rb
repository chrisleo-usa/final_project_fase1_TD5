FactoryBot.define do
  factory :candidate do
    name { "Christopher Alves" }
    phone { "48988776655" }
    cpf { 12345678910 }
    biography { "Profissional da área de eventos migrando para a área da tecnologia" }
    email { "chris@gmail.com" }
    password { "123456" }
  end
end