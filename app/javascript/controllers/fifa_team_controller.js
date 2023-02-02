import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select'

export default class extends Controller {
  static targets = [ "radio" ]

  connect() {
    var selector = document.querySelector('[data-controller="fifa_team"]');
    this.slim = new SlimSelect({
      select: selector
    });

    this.radioTargets.forEach(radio => {
      radio.addEventListener("change", this.change.bind(this))
    })
  }

  change(event) {
    fetch(`/fifa_teams/?gender=${event.target.value}&min_stars=4.5&max_stars=5`)
      .then(response => response.json())
      .then(data => this.populateLeagues(data));
  }

  populateLeagues(leagues) {
    this.slim.setSelected([]);
    this.slim.setData(this.convertLeaguesToHash(leagues));
  }

  convertLeaguesToHash(leagues){
    return leagues.map(league => ({text: league, value: league}));
  }
}