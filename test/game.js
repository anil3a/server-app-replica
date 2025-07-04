const dog = document.getElementById('dog');
const gameContainer = document.getElementById('gameContainer');

function getRandomPosition() {
  const containerWidth = gameContainer.clientWidth;
  const containerHeight = gameContainer.clientHeight;
  const dogWidth = dog.clientWidth;
  const dogHeight = dog.clientHeight;

  const randomX = Math.floor(Math.random() * (containerWidth - dogWidth));
  const randomY = Math.floor(Math.random() * (containerHeight - dogHeight));

  return { randomX, randomY };
}

function moveDog() {
  const { randomX, randomY } = getRandomPosition();
  dog.style.left = `${randomX}px`;
  dog.style.top = `${randomY}px`;
}

function clickDog() {
  alert('Good job! You found the sneaky dog!');
  moveDog();
}

// Initial dog position
moveDog();

// Move the dog every 1 seconds
setInterval(moveDog, 1000);
