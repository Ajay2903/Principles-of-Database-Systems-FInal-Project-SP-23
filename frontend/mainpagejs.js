const loginButton = document.getElementById("login-button");
const closeButton = document.getElementById("close-button");
const loginModal = document.getElementById("login-popup");
const loginForm = document.getElementById("login-form");
const usernameInput = document.getElementById("username");
const passwordInput = document.getElementById("password");

// Function to show the login modal
function showLoginModal() {
  loginModal.style.display = "block";
}

// Function to hide the login modal
function hideLoginModal() {
  loginModal.style.display = "none";
}

// Function to handle form submission
function handleFormSubmit(event) {
  event.preventDefault();

  const username = usernameInput.value;
  const password = passwordInput.value;

  // Perform login validation here, e.g. by sending an AJAX request to a server-side API

  // For demo purposes, we just check if the username and password fields are non-empty
  if (username.trim() === "" || password.trim() === "") {
    alert("Please enter both username and password.");
    return;
  }

  alert(`Welcome, ${username}!`);
  hideLoginModal();
}

// Add click event listeners to login and close buttons
loginButton.addEventListener("click", showLoginModal);
closeButton.addEventListener("click", hideLoginModal);

// Add submit event listener to login form
loginForm.addEventListener("submit", handleFormSubmit);