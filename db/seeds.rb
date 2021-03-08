# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Candidates
Candidate.create!(name: 'Christopher Alves', phone: '48988776655', cpf: 12345678910, 
                                    biography: 'Profissional da área de eventos migrando para a área da tecnologia', 
                                    email: 'chris@gmail.com', password: '123456')

Candidate.create!(name: 'Susan Ristau', phone: '48991567741', cpf: 98765432110, 
                                    biography: 'Estudante de Desenvolvimento Web a procura de sua primeira oportunidade', 
                                    email: 'susan@yahoo.com.br', password: '123456')

# Campus Code - Sem logo
campuscode = Company.create!(name: 'Campus Code', address: 'Rua da Campus Code', complement: '222, sala 123', city: 'São Paulo', state: 'SP', cnpj: 1234567891011, 
                            site: 'www.campuscode.com.br', social_media: 'www.linkedin.com/in/campuscode', 
                            domain: 'campuscode')

Employee.create!(email: 'joao@campuscode.com', password: '123456', admin: 1, company: campuscode)
Employee.create!(email: 'henrique@campuscode.com', password: '123456', admin: 0, company: campuscode)

Job.create!(title: 'Ruby on Rails Developer Jr', description: 'Vaga para Ruby on Rails Developer', 
                      salary_range: 3300.0, requirements: 'Conhecimento em Ruby, Ruby on Rails, NodeJS, SQLite3',
                      deadline_application: '05/04/2021', total_vacancies: 2, level: 1, company: campuscode)

Job.create!(title: 'Back End Developer', description: 'Vaga para desenvolvedor Back End Júnior', 
                        salary_range: 5000.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                        deadline_application: '01/03/2021', total_vacancies: 2, level: 1, company: campuscode)

# TreinaDev - Com logo
treinadev = Company.create!(name: 'TreinaDev', address: 'Rua da Portal Solar', complement: '987, sala 900', city: 'São Paulo', state: 'SP', cnpj: 9876543211011, 
                                site: 'www.treinadev.com.br', social_media: 'www.linkedin.com/in/treinadev', 
                                domain: 'treinadev')

treinadev.logo.attach(io: File.open(Rails.root.join('spec', 'support', 'tdlogo.png')), filename: 'tdlogo.png')

Employee.create!(email: 'fred@treinadev.com', password: '123456', admin: 1, company: treinadev)
Employee.create!(email: 'jonata@treinadev.com', password: '123456', admin: 0, company: treinadev)

Job.create!(title: 'Javascript Developer Pl', description: 'Vaga para Desenvolvedor Javascript com experiência (Pleno)', 
                      salary_range: 7500.0, requirements: 'Conhecimento sólido em Javascript, HTML, CSS, SASS, REACT',
                      deadline_application: '10/08/2021', total_vacancies: 2, level: 2, company: treinadev)

Job.create!(title: 'Front End Developer Jr', description: 'Vaga para Desenvolvedor Front End voltado para Vue.Js', 
                        salary_range: 6500.0, requirements: 'Conhecimento sólido em Java, Ruby, Ruby on Rails, NodeJS, SQLite3',
                        deadline_application: '20/04/2021', total_vacancies: 2, level: 1, company: treinadev)

# # Enrollments, proposals and responses
# chris_back_campus = Enrollment.create!(job: back_job, candidate: chris_candidate, status: :approved)
# chris_back_proposal = Proposal.create!(proposal_message: 'Congratulations, you have been approved, look your proposal', 
#                                       proposal_salary: 3000.0, start_date: '05/04/2021', enrollment: chris_back_campus)
# chris_decline_proposal = Decline.create!(reason: 'I\'m so sorry, but i already got a new job', proposal: chris_back_proposal)


# chris_ruby_campus = Enrollment.create!(job: ruby_job, candidate: chris_candidate, status: :approved)
# chris_ruby_proposal = Proposal.create!(proposal_message: 'Congratulations, you have been approved, look your proposal', 
#                                       proposal_salary: 3300.0, start_date: '05/04/2021', enrollment: chris_ruby_campus)
# chris_accept_proposal = Accept.create!(start_date: '05/04/2021', proposal: chris_ruby_proposal)


# chris_js_treinadev = Enrollment.create!(job: js_job, candidate: chris_candidate, status: :denied)
# chris_js_reject = Reject.create!(message: 'Sorry, but we are looking for person with more experience', enrollment: chris_js_treinadev)


# chris_front_treinadev = Enrollment.create!(job: front_job, candidate: chris_candidate, status: :pending)


# susan_back_campus = Enrollment.create!(job: back_job, candidate: susan_candidate, status: :approved)
# susan_back_proposal = Proposal.create!(proposal_message: 'Congratulations, you have been approved, what you think about this proposal?', 
#                                       proposal_salary: 3500.0, start_date: '01/03/2021', enrollment: susan_back_campus)
# susan_accept_proposal = Accept.create!(start_date: '01/03/2021', proposal: susan_back_proposal)


# susan_js_treina = Enrollment.create!(job: js_job, candidate: susan_candidate, status: :denied)
# susan_js_reject = Reject.create!(message: 'Sorry, but we are looking for person with more experience in Front End', enrollment: susan_js_treina)



