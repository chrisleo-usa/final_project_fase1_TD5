FactoryBot.define do
  factory :job do
    title { "Ruby on Rails Developer" }
    description { "Vaga para Ruby on Rails Developer" }
    salary_range { 9000 }
    requirements { "Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite" }
    deadline_application { "10/04/2023" }
    total_vacancies { 5 }
    level { :junior }
  end
end