FactoryBot.define do
  factory :proposal do
    proposal_message { 'Parabéns, você foi aprovado, dê uma olhada nesta proposta' }
    proposal_salary { 7000 }
    start_date { '01/07/2021' }
  end
end
