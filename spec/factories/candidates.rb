FactoryBot.define do
  factory :candidate do
    name { 'Christopher Alves' }
    phone { '48988776655' }
    cpf { 123_456_789_10 }
    biography { 'Profissional da área de eventos migrando para a área da tecnologia' }
    email { 'chris@gmail.com' }
    password { '123456' }
  end
end
