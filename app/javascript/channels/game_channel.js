import consumer from "./consumer"

let gameChannel;
let userId;

let containerDiv = document.getElementById('container');
if( containerDiv ) {
  userId = containerDiv.dataset['userId'];
}


let gameDiv = document.getElementsByClassName('game');
if( gameDiv.length > 0 ) {
  let gameId = gameDiv[0].dataset['gameId']
  let blackPlayerId = gameDiv[0].dataset['blackPlayerId'];
  let whitePlayerId = gameDiv[0].dataset['whitePlayerId'];

  console.log("this is user", userId, "trying watching the game ", gameId, " between ", blackPlayerId, " and ", whitePlayerId);
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
      console.log("gamestate", data['game_state']);
      console.dir(`----${userId}---${blackPlayerId}----${whitePlayerId}---`);
      if(data['game_state'] == 'waiting_for_black') {
        console.log("waiting for black")
        if (userId == blackPlayerId) { 
          console.log("it is my turn, I am black");
          letterInput.style.display = 'block';
        }
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
    console.log(str);
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

