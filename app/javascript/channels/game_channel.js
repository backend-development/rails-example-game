import consumer from "./consumer"

let gameChannel, userId, gameId, blackPlayerId, whitePlayerId;

let containerDiv = document.getElementById('container');
if( containerDiv ) {
  userId = containerDiv.dataset['userId'];
}


let gameDiv = document.getElementsByClassName('game');
if( gameDiv.length > 0 ) {
  gameId = gameDiv[0].dataset['gameId']
  blackPlayerId = gameDiv[0].dataset['blackPlayerId'];
  whitePlayerId = gameDiv[0].dataset['whitePlayerId'];

  console.log("this is user", userId, "watching the game ", gameId, " between ", blackPlayerId, " and ", whitePlayerId);
  gameChannel = consumer.subscriptions.create({
    channel: "GameChannel",
    game_id: gameId
  }, {
    connected() {
      console.log("connected successfully");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log(data);
      if( data['board'] ) {
        containerDiv.innerHTML = data['board'];
      }
      if( (data['game_state'] == 'waiting_for_black') && (userId == blackPlayerId) ) { 
        console.log("it is my turn, I am black");
        letterInput.style.display = 'block';
      }
      if( (data['game_state'] == 'waiting_for_white') && (userId == whitePlayerId) ) {
        console.log("it is my turn, I am white");
        letterInput.style.display = 'block';
      }      
    }
  });
}

let letterInput = document.getElementById('letter');
if(letterInput) {
  const a = 97;
  const z = 123; 
  //loop through the values from i to j
  for(let l = a; l < z; l++){
    let str =String.fromCharCode(l);
    letterInput.innerHTML += `<button data-letter='${str}'>${str}</button>`;
  }
  document.querySelectorAll('#letter button').forEach(function(element){
    element.addEventListener('click', function(){
      let letter = this.dataset['letter'];
      console.log("clicked", letter);
      gameChannel.send({ guess: letter });
      letterInput.style.display = 'none';
    })
  });
}

let joinButton = document.getElementById('join');
if( joinButton ) {
  

  joinButton.addEventListener('click',function(){
    console.log("I want to join!", userId);
    gameChannel.send({ command: 'join' });
  });
}

