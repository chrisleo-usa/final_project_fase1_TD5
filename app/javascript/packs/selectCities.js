let stateInput = document.querySelector('#company_state')
let citiesInput = document.querySelector('#company_city')

stateInput.addEventListener('change', event => {

  let nodesSelectCities = citiesInput.childNodes;

  [...nodesSelectCities].map(node => node.remove());

  let state = stateInput.options[stateInput.selectedIndex].value;

  fetch(`https://servicodados.ibge.gov.br/api/v1/localidades/estados/${state}/municipios`)
  .then(res => res.json())
  .then(cities => {

    citiesInput.removeAttribute('disabled');

    cities.map(city => {
      const option = document.createElement('option');

      option.setAttribute('value', city.nome);
      option.textContent = city.nome;

      citiesInput.appendChild(option);
    })
  })
})